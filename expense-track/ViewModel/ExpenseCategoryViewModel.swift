//
//  ExpenseCategoryViewModel.swift
//  ExpenseTrack
//
//  Created by Thujeevan on 2023-09-30.
//

import Foundation
import Combine

class ExpenseCategoryViewModel: ObservableObject {
    @Published var expenseCategories: [ExpenseCategory] = []
    @Published var isLoading: Bool = false

    private var cancellables: Set<AnyCancellable> = []

    func fetchCategories() {
        self.isLoading = true
        guard let components = URLComponents(string: "\(Constants.baseURL)/expense-category") else {
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
            .decode(type: ExpenseCategoryResponse.self, decoder: JSONDecoder())
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
                    self.expenseCategories = response.data.data
                } else {
                    if response.statusCode == 406 {
                        self.isLoading = true
                        AuthManager.shared.refreshAuthToken { newToken in
                            if let jwtToken = newToken {
                                request.setValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
                                self.fetchCategories()
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
