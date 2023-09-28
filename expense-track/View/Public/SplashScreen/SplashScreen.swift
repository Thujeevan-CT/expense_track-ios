//
//  SplashScreen.swift
//  ExpenseTrack
//
//  Created by Thujeevan on 2023-09-17.
//

import SwiftUI

struct SplashScreen: View {
    @State private var isActive = false
    @State private var size = 0.48
    @State private var opacity = 0.9
    
    var body: some View {
        if(isActive){
            ContentView()
        } else {
            VStack {
                VStack {
                    Image("appstore").resizable().scaledToFill()
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear{
                    withAnimation(.easeIn(duration: 1.2)) {
                        self.size = 0.5
                        self.opacity = 1.0
                    }
                }
            }.onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.isActive = true
                }
            }.background(LinearGradient(gradient: Gradient(colors: [Color(hex: "#6C0EB7"), Color(hex: "#6300E0")]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all))
        }
    }
}
