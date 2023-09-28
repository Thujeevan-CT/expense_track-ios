//
//  MainMenu.swift
//  ExpenseTrack
//
//  Created by Thujeevan on 2023-09-28.
//

import SwiftUI

struct MainMenu: View {
    @State private var activeTab: Tab = .dashboard
    @State private var tabShapePosition: CGPoint = .zero

    var body: some View {
        TabBar(activeTab: $activeTab, tabShapePosition: $tabShapePosition)
    }
}

struct MainMenu_Previews: PreviewProvider {
    static var previews: some View {
        MainMenu()
    }
}
