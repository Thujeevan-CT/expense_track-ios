//
//  RegistrationModel.swift
//  ExpenseTrack
//
//  Created by Thujeevan on 2023-09-23.
//

import Foundation

struct RegistrationData: Codable {
    let first_name: String
    let last_name: String
    let email: String
    let password: String
}
