//
//  RegistrationViewModel.swift
//  ExpenseTrack
//
//  Created by Thujeevan on 2023-09-23.
//

import Foundation
import Combine

struct RegistrationSuccessResponse: Codable {
    let status: Bool?
    let data: RegistrationDataResponse?
    let message: ErrorMessage?
}

struct RegistrationDataResponse: Codable {
    let status: Bool
    let message: String
    let user: User
}

struct User: Codable {
    let id: String
    let first_name: String
    let last_name: String
    let email: String
    let role: String
    let status: String
}

class RegistrationViewModel: ObservableObject {
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading: Bool = false
    
    private var cancellables: Set<AnyCancellable> = []
    
    func registerUser(completion: @escaping (Bool, String?) -> Void) {
        self.isLoading = true
        guard var components = URLComponents(string: "\(Constants.baseURL)/auth/register") else {
            completion(false, "Invalid URL")
            return
        }
        
        // Registraion data attaching as query parameters
        components.queryItems = [
            URLQueryItem(name: "first_name", value: firstName),
            URLQueryItem(name: "last_name", value: lastName),
            URLQueryItem(name: "email", value: email),
            URLQueryItem(name: "password", value: password)
        ]
        
        guard let url = components.url else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: RegistrationSuccessResponse.self, decoder: JSONDecoder())
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
                if((response.data?.status) != nil){
                    // Success user registration
                    self.firstName = ""
                    self.lastName = ""
                    self.email = ""
                    self.password = ""
                    completion(true, response.data?.message)
                    
                } else {
                    // get error message from api
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
