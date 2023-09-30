//
//  ForgotPasswordViewModel.swift
//  ExpenseTrack
//
//  Created by Thujeevan on 2023-09-25.
//

import Foundation
import Combine

struct SuccessResponse: Codable {
    let statusCode: Int?
    let status: Bool?
    let data: DataResponse?
    let message: ErrorMessage?
}

struct DataResponse: Codable {
    let status: Bool?
    let message: String
}

class ForgotPasswordViewModel: ObservableObject {
    @Published var email = ""
    @Published var code = ""
    @Published var password = ""
    @Published var isLoading: Bool = false
    
    private var cancellables: Set<AnyCancellable> = []
    
    func forgotPassword(completion: @escaping (Bool, String?) -> Void) {
        self.isLoading = true
        guard var components = URLComponents(string: "\(Constants.baseURL)/auth/forgot-password") else {
            completion(false, "Invalid URL")
            return
        }
        
        components.queryItems = [
            URLQueryItem(name: "email", value: email),
        ]
        
        guard let url = components.url else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
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
                if((response.status) != nil){
                    completion(true, response.data?.message)
                } else {
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
    
    func resetPassword(completion: @escaping (Bool, String?) -> Void) {
        self.isLoading = true
        guard var components = URLComponents(string: "\(Constants.baseURL)/auth/password-reset") else {
            completion(false, "Invalid URL")
            return
        }
        
        components.queryItems = [
            URLQueryItem(name: "email", value: email),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "password", value: password),
        ]
        
        guard let url = components.url else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
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
                    self.email = ""
                    self.code = ""
                    self.password = ""
                    completion(true, response.data?.message)
                } else {
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
}
