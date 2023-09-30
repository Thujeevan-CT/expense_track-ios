//
//  ProfileViewModel.swift
//  ExpenseTrack
//
//  Created by Thujeevan on 2023-09-28.
//

import SwiftUI
import Combine

struct GetProfileResponse: Codable {
    let statusCode: Int?
    let status: Bool?
    let data: SucessProfileResponse?
    let message: String?
}

struct SucessProfileResponse: Codable {
    let message: String
    let user: User
}

class ProfileViewModel: ObservableObject {
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var isLoading: Bool = false

    private var cancellables: Set<AnyCancellable> = []
    
    func getProfile(completion: @escaping (Bool, String?) -> Void) {
        self.isLoading = true
        guard let components = URLComponents(string: "\(Constants.baseURL)/user/profile") else {
            completion(false, "Invalid URL")
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
            .decode(type: GetProfileResponse.self, decoder: JSONDecoder())
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
                    self.firstName = response.data?.user.first_name ?? ""
                    self.lastName = response.data?.user.last_name ?? ""
                    self.email = response.data?.user.email ?? ""
                    completion(true, "Get profile success.")
                } else {
                    if response.statusCode == 406 {
                        self.isLoading = true
                        AuthManager.shared.refreshAuthToken { newToken in
                            if let jwtToken = newToken {
                                request.setValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
                                self.getProfile { Status, Message in }
                                self.isLoading = false
                                return;
                            } else {
                                self.isLoading = false
                                print("Refresh token error")
                            }
                        }
                    }
                    completion(false, response.message)
                }
            })
            .store(in: &cancellables)
    }
    
    func updateProfile(completion: @escaping (Bool, String?) -> Void) {
        self.isLoading = true
        
        if let userID = UserDefaults.standard.string(forKey: Constants.userID) {
            guard var components = URLComponents(string: "\(Constants.baseURL)/user/update/\(userID)") else {
                completion(false, "Invalid URL")
                return
            }
            
            components.queryItems = [
                URLQueryItem(name: "first_name", value: firstName),
                URLQueryItem(name: "last_name", value: lastName),
            ]
            
            guard let url = components.url else {
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
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
                    } else {
                        if response.statusCode == 406 {
                            self.isLoading = true
                            AuthManager.shared.refreshAuthToken { newToken in
                                if let jwtToken = newToken {
                                    request.setValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
                                    self.updateProfile { Status, Message in }
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
        
    }
}
