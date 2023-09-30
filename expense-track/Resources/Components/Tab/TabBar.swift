//
//  Tab.swift
//  ExpenseTrack
//
//  Created by Thujeevan on 2023-09-28.
//

import SwiftUI

struct TabBar<Content: View>: View {
    @Binding var activeTab: Tab
    @Binding var tabShapePosition: CGPoint
    let content: Content

    init(activeTab: Binding<Tab>, tabShapePosition: Binding<CGPoint>, @ViewBuilder content: () -> Content) {
        self._activeTab = activeTab
        self._tabShapePosition = tabShapePosition
        self.content = content()
    }

    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $activeTab) {
                content
                    .tag(Tab.dashboard)
                    .toolbar(.hidden, for: .tabBar)
            }.background(Color.purple)
            CustomTabBarView(activeTab: $activeTab, tabShapePosition: $tabShapePosition)
        }
    }
}
