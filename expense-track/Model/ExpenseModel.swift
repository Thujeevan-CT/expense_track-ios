//
//  ExpenseModel.swift
//  ExpenseTrack
//
//  Created by Thujeevan on 2023-09-30.
//

import Foundation

struct ExpenseResponse: Codable {
    let statusCode: Int?
    let status: Bool?
    let data: ExpenseData
}

struct ExpenseData: Codable {
    let message: String
    let data: [ExpenseDetail]
}

struct ExpenseDetail: Codable, Identifiable {
    let id: String
    let amount: Int
    let description: String
    let location: String
    let date: String
    let status: String
//    let user: ExpenseUser
    let category: CategoryExpense
}

//struct ExpenseUser: Codable {
//    let id: String
//    let email: String
//    let full_name: String
//}

struct CategoryExpense: Codable {
    let id: String
    let name: String
}
