//
//  IncomeViewModel.swift
//  ExpenseTrack
//
//  Created by Thujeevan on 2023-09-30.
//

import Foundation
import Combine

class IncomeViewModel: ObservableObject {
    @Published var incomes: [IncomeDetail] = []
    @Published var amount = ""
    @Published var source = ""
    @Published var date = ""
    @Published var isLoading: Bool = false
    
    private var cancellables: Set<AnyCancellable> = []
    
    func clearValues() {
        self.amount = ""
        self.source = ""
        self.date = ""
    }
    
    func addIncome(completion: @escaping (Bool, String?) -> Void) {
        self.isLoading = true
        guard var components = URLComponents(string: "\(Constants.baseURL)/income") else {
            completion(false, "Invalid URL")
            return
        }
        
        components.queryItems = [
            URLQueryItem(name: "amount", value: amount),
            URLQueryItem(name: "source", value: source),
            URLQueryItem(name: "date", value: date),
        ]
        
        guard let url = components.url else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let jwtToken = UserDefaults.standard.string(forKey: Constants.jwtToken) {
            request.setValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
        }
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: SuccessResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completionStatus in
                switch completionStatus {
                case .finished:
                    self.isLoading = false
                    break
                case .failure(_):
                    self.isLoading = false
                    break
                }
            }, receiveValue: { response in
                self.isLoading = false
                if((response.status) != nil){
                    completion(true, response.data?.message)
                    self.clearValues()
                } else {
                    if response.statusCode == 406 {
                        self.isLoading = true
                        AuthManager.shared.refreshAuthToken { newToken in
                            if let jwtToken = newToken {
                                request.setValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
                                self.addIncome { Status, Message in }
                                self.isLoading = true
                                return;
                            } else {
                                self.isLoading = true
                                print("Refresh token error")
                            }
                        }
                    }
                    var messageString = ""
                    switch response.message {
                        case .single(let message):
                            messageString = message
                        case .multiple(let messages):
                            messageString = messages.joined(separator: ", ")
                        case .none:
                            break
                    }
                    completion(false, messageString)
                }
            })
            .store(in: &cancellables)
    }
    
    func fetchIncomes(completion: @escaping (Bool, String?) -> Void) {
        self.isLoading = true
        guard let components = URLComponents(string: "\(Constants.baseURL)/income") else {
            return
        }
        
        guard let url = components.url else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let jwtToken = UserDefaults.standard.string(forKey: Constants.jwtToken) {
            request.setValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
        }
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: IncomeResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completionStatus in
                switch completionStatus {
                case .finished:
                    self.isLoading = false
                    break
                case .failure(_):
                    self.isLoading = false
                    break
                }
            }, receiveValue: { response in
                if((response.status) != nil) {
                    self.incomes = response.data.data;
                    completion(true, "Retrieved")
                } else {
                    if response.statusCode == 406 {
                        self.isLoading = true
                        AuthManager.shared.refreshAuthToken { newToken in
                            if let jwtToken = newToken {
                                request.setValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
                                self.fetchIncomes {_,_ in}
                                self.isLoading = false
                                return;
                            } else {
                                self.isLoading = false
                                print("Refresh token error")
                            }
                        }
                    }
                }
            })
            .store(in: &cancellables)
    }
}
