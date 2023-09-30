//
//  ExpenseCategoryModel.swift
//  ExpenseTrack
//
//  Created by Thujeevan on 2023-09-30.
//

import Foundation

struct ExpenseCategoryResponse: Codable {
    let statusCode: Int?
    let status: Bool?
    let data: ExpenseCategoryData
}

struct ExpenseCategoryData: Codable {
    let message: String
    let data: [ExpenseCategory]
}

struct ExpenseCategory: Codable, Identifiable {
    let id: String
    let name: String
    let status: String
    let created_at: String
    let updated_at: String
}
