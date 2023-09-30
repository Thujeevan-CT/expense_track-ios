//
//  BudgetModel.swift
//  ExpenseTrack
//
//  Created by Thujeevan on 2023-09-30.
//

import Foundation

struct BudgetsResponse: Codable {
    let statusCode: Int?
    let status: Bool?
    let data: BudgetsData
}

struct BudgetsData: Codable {
    let message: String
    let data: [BudgetCodable]
}

struct BudgetCodable: Codable, Identifiable {
    let id: String
    let amount: Int
    let budget_type: String
    let start_date: String
    let end_date: String
    let status: String
    let user: UserBudget
    let category: CategoryBudget
}

struct UserBudget: Codable {
    let id: String
    let email: String
    let full_name: String
}

struct CategoryBudget: Codable {
    let id: String
    let name: String
}
