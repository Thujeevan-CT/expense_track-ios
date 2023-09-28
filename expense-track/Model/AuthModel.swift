//
//  AuthModel.swift
//  ExpenseTrack
//
//  Created by Thujeevan on 2023-09-27.
//

import Foundation

class AuthModel: ObservableObject {
    @AppStorage("JWTToken") var jwtToken: String = ""
    @AppStorage("UserID") var userID: String = ""
}
