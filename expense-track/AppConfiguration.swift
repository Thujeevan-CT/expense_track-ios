//
//  AppConfiguration.swift
//  ExpenseTrack
//
//  Created by Thujeevan on 2023-09-23.
//

import Foundation
import SwiftUI

struct AppConfig {
    let apiBaseUrl: String
}

class AppConfiguration: ObservableObject {
    @Published var config = AppConfig(apiBaseUrl: "https://expense-track-api.onrender.com/api/v1")
}

