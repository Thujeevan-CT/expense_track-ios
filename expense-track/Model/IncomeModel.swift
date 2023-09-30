//
//  IncomeModel.swift
//  ExpenseTrack
//
//  Created by Thujeevan on 2023-09-30.
//

import Foundation

struct IncomeResponse: Codable {
    let statusCode: Int?
    let status: Bool?
    let data: IncomeData
}

struct IncomeData: Codable {
    let message: String
    let data: [IncomeDetail]
}

struct IncomeDetail: Codable, Identifiable {
    let id: String
    let amount: Int
    let source: String
    let date: String
    let status: String
    let user: IncomeUser
}

struct IncomeUser: Codable {
    let id: String
    let email: String
    let full_name: String
}
