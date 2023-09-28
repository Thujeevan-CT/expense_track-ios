//
//  ContentView.swift
//  expense-track
//
//  Created by Thujeevan on 2023-09-17.
//

import SwiftUI

struct ContentView: View {
    @AppStorage(Constants.userID) var userID: String = ""
    
    var body: some View {
        if userID.isEmpty {
            Login().preferredColorScheme(.light)
        } else {
            MainMenu().preferredColorScheme(.light)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
