//
//  LoginViewModel.swift
//  ExpenseTrack
//
//  Created by Thujeevan on 2023-09-26.
//

import Foundation
import Combine

struct LoginResponse: Codable {
    let status: Bool?
    let data: SucessLoginResponse?
    let message: ErrorMessage?
}

struct SucessLoginResponse: Codable {
    let message: String
    let data: LoginData
}

struct LoginData: Codable {
    let token: String
    let user: User
}

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading: Bool = false

    private var cancellables: Set<AnyCancellable> = []
    
    func login(completion: @escaping (Bool, String?) -> Void) {
        self.isLoading = true
        guard var components = URLComponents(string: "\(Constants.baseURL)/auth/login") else {
            completion(false, "Invalid URL")
            return
        }
        
        components.queryItems = [
            URLQueryItem(name: "email", value: email),
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
            .decode(type: LoginResponse.self, decoder: JSONDecoder())
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
                    UserDefaults.standard.set(response.data?.data.token, forKey: Constants.jwtToken)
                    UserDefaults.standard.set(response.data?.data.user.id, forKey: Constants.userID)
                    completion(true, "Logged-in success")
                    self.email = ""
                    self.password = ""
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
