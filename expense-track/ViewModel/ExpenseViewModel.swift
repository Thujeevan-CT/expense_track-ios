//
//  ExpenseViewModel.swift
//  ExpenseTrack
//
//  Created by Thujeevan on 2023-09-30.
//

import Foundation
import Combine

class ExpenseViewModel: ObservableObject {
    @Published var expenses: [ExpenseDetail] = []
    @Published var amount = ""
    @Published var description = ""
    @Published var location = ""
    @Published var date = ""
    @Published var categoryID = ""
    @Published var isLoading: Bool = false
    
    private var cancellables: Set<AnyCancellable> = []
    
    func clearValues() {
        self.amount = ""
        self.description = ""
        self.location = ""
        self.date = ""
    }
    
    func addExpense(completion: @escaping (Bool, String?) -> Void) {
        self.isLoading = true
        guard var components = URLComponents(string: "\(Constants.baseURL)/expense") else {
            completion(false, "Invalid URL")
            return
        }
        
        components.queryItems = [
            URLQueryItem(name: "amount", value: amount),
            URLQueryItem(name: "description", value: description),
            URLQueryItem(name: "location", value: location),
            URLQueryItem(name: "date", value: date),
            URLQueryItem(name: "category_id", value: categoryID),
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
                print(response)
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
                                self.addExpense { Status, Message in }
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
    
    func fetchExpenses(completion: @escaping (Bool, String?) -> Void) {
        self.isLoading = true
        guard let components = URLComponents(string: "\(Constants.baseURL)/expense") else {
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
            .decode(type: ExpenseResponse.self, decoder: JSONDecoder())
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
                    self.expenses = response.data.data;
                    completion(true, "Retrieved")
                } else {
                    if response.statusCode == 406 {
                        self.isLoading = true
                        AuthManager.shared.refreshAuthToken { newToken in
                            if let jwtToken = newToken {
                                request.setValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
                                self.fetchExpenses {_,_ in}
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
