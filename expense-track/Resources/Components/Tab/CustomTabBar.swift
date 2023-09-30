//
//  CustomTabBar.swift
//  ExpenseTrack
//
//  Created by Thujeevan on 2023-09-28.
//

import SwiftUI

struct CustomTabBarView: View {
    @Binding var activeTab: Tab
    @Namespace private var animation
    @Binding var tabShapePosition: CGPoint

    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            ForEach(Tab.allCases, id: \.rawValue) {
                TabItem(
                    tint: Color(hex: "#6C0EB7"),
                    inactiveTint: Color(hex: "#6C0EB7"),
                    tab: $0,
                    animation: animation,
                    activeTab: $activeTab,
                    position: $tabShapePosition
                )
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .background(content: {
            TabShape(midPoint: tabShapePosition.x)
                .fill(.white)
                .ignoresSafeArea()
                .shadow(color: Color(hex: "#6C0EB7").opacity(0.15), radius: 5,  x: 0, y: -5)
                .blur(radius: 2)
                .padding(.top, 25)
        })
        .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7), value: activeTab)
    }
}
