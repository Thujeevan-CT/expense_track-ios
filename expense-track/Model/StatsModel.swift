//
//  StatsModel.swift
//  ExpenseTrack
//
//  Created by Thujeevan on 2023-09-30.
//

import Foundation

struct StatsResponse: Codable {
    let statusCode: Int?
    let status: Bool?
    let data: Stats
}

struct Stats: Codable {
    let message: String
    let stats: StatsData
}

struct StatsData: Codable {
    let monthly_current_cash: Int
    let current_cash: Int
    let income_amount: Int
    let expense_amount: Int
    let expense_Percentages: [ExpensePercentages]
}

struct ExpensePercentages: Codable {
    let category: String
    let category_name: String
    let total: Int
    let percentage: Double
}

