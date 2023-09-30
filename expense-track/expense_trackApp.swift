//
//  expense_trackApp.swift
//  expense-track
//
//  Created by Thujeevan on 2023-09-17.
//

import SwiftUI

@main
struct expense_trackApp: App {
    @StateObject var viewModel = LoginViewModel()
    
    var body: some Scene {
        WindowGroup {
            SplashScreen()
                .environment(\.font, Font.custom("Poppins-Regular", size: 14))
                .environmentObject(viewModel)
        }
    }
}
