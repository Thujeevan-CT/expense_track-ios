//
//  UserModel.swift
//  ExpenseTrack
//
//  Created by Thujeevan on 2023-09-26.
//

import Foundation
import Combine

class UserDataModel: ObservableObject {
    @Published var token: String
    @Published var user: User

    init(token: String, user: User) {
        self.token = token
        self.user = user
    }

    struct User {
        var id: String
        var firstName: String
        var lastName: String
        var email: String
        var role: String
        var status: String
    }
}
