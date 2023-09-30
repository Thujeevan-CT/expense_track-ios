//
//  Dashboard.swift
//  ExpenseTrack
//
//  Created by Thujeevan on 2023-09-26.
//

import SwiftUI

struct Main: View {
    @State private var activeTab: Tab = .dashboard
    @Namespace private var animation
    @State private var tabShapePosition: CGPoint = .zero
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        TabBar(activeTab: $activeTab, tabShapePosition: $tabShapePosition)
    }
}
