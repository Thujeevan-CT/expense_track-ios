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
        TabBar(activeTab: $activeTab, tabShapePosition: $tabShapePosition) {
            Dashboard()
                .tag(Tab.dashboard)
                .toolbar(.hidden, for: .tabBar)
            Budget()
                .tag(Tab.budget)
                .toolbar(.hidden, for: .tabBar)
            Add(activeTab: $activeTab)
                .tag(Tab.add)
                .toolbar(.hidden, for: .tabBar)
            Report(activeTab: $activeTab)
                .tag(Tab.report)
                .toolbar(.hidden, for: .tabBar)
            Profile()
                .tag(Tab.profile)
                .toolbar(.hidden, for: .tabBar)
        }
    }
}

struct MainMenu_Previews: PreviewProvider {
    static var previews: some View {
        MainMenu()
    }
}
