//
//  Tab.swift
//  ExpenseTrack
//
//  Created by Thujeevan on 2023-09-28.
//

import SwiftUI

struct TabBar: View {
    @Binding var activeTab: Tab
    @Binding var tabShapePosition: CGPoint
    init(activeTab: Binding<Tab>, tabShapePosition: Binding<CGPoint>) {
        self._activeTab = activeTab
        self._tabShapePosition = tabShapePosition
    }

var body: some View {
    VStack(spacing: 0) {
            TabView(selection: $activeTab) {
                Dashboard()
                   .tag(Tab.dashboard)
                   .toolbar(.hidden, for: .tabBar)
                Budget()
                   .tag(Tab.budget)
                   .toolbar(.hidden, for: .tabBar)
                Add()
                   .tag(Tab.add)
                   .toolbar(.hidden, for: .tabBar)
                Report()
                   .tag(Tab.report)
                   .toolbar(.hidden, for: .tabBar)
                Profile()
                   .tag(Tab.profile)
                   .toolbar(.hidden, for: .tabBar)
            }
            CustomTabBarView(activeTab: $activeTab, tabShapePosition: $tabShapePosition)
        }
    }
}
