//
//  StatsViewModel.swift
//  ExpenseTrack
//
//  Created by Thujeevan on 2023-09-30.
//

import Foundation
import Combine

final class StatsViewModel: ObservableObject {
    @Published var monthlyCurrentCash: Int = 0
    @Published var currentCash: Int = 0
    @Published var incomeAmount: Int = 0
    @Published var expenseAmount: Int = 0
    @Published var expensePercentages: [ExpensePercentages] = []
    @Published var isLoading: Bool = false
    
    private var cancellables: Set<AnyCancellable> = []
    
    func fetchStats(durationType: String) {
        self.isLoading = true
        guard var components = URLComponents(string: "\(Constants.baseURL)/user/profile/stats") else {
            return
        }
        
        components.queryItems = [
            URLQueryItem(name: "duration_type", value: durationType),
        ]
        
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
            .decode(type: StatsResponse.self, decoder: JSONDecoder())
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
                    self.monthlyCurrentCash = response.data.stats.monthly_current_cash
                    self.currentCash = response.data.stats.current_cash
                    self.incomeAmount = response.data.stats.income_amount
                    self.expenseAmount = response.data.stats.expense_amount
                    self.expensePercentages = response.data.stats.expense_Percentages
                } else {
                    if response.statusCode == 406 {
                        self.isLoading = true
                        AuthManager.shared.refreshAuthToken { newToken in
                            if let jwtToken = newToken {
                                request.setValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
                                self.fetchStats(durationType: durationType)
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
