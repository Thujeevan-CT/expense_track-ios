//
//  AuthManager.swift
//  ExpenseTrack
//
//  Created by Thujeevan on 2023-09-28.
//

import Foundation
import Combine

struct RefreshTokenResponse: Codable {
    let status: Bool?
    let data: SucessRefreshTokenResponse?
    let message: String?
}

struct SucessRefreshTokenResponse: Codable {
    let message: String
    let data: TokenResponse
}

struct TokenResponse: Codable {
    let token: String
}


class AuthManager {
    static let shared = AuthManager()
    
    private init() {}
    
    private var cancellables: Set<AnyCancellable> = []
    
    func refreshAuthToken(completion: @escaping (String?) -> Void) {
        guard let refreshToken = UserDefaults.standard.string(forKey: Constants.jwtToken) else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: URL(string: "\(Constants.baseURL)/auth/refresh-token")!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(refreshToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: RefreshTokenResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completionStatus in
                switch completionStatus {
                case .finished:
                    break
                case .failure:
                    completion(nil)
                    break
                }
            }, receiveValue: { response in
                if let newToken = response.data?.data.token {
                    UserDefaults.standard.set(newToken, forKey: Constants.jwtToken)
                    completion(newToken)
                } else {
                    completion(nil)
                }
            })
            .store(in: &cancellables)
    }
}
