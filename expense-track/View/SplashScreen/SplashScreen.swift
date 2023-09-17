//
//  SplashScreen.swift
//  ExpenseTrack
//
//  Created by Thujeevan on 2023-09-17.
//

import SwiftUI

struct SplashScreen: View {
    @State private var isActive = false
    @State private var size = 0.4
    @State private var opacity = 0.7
    
    var body: some View {
        if(isActive){
            ContentView()
        } else {
            VStack {
                VStack {
                    Image("appstore").resizable().scaledToFill()
                    Text("Expense Track").font(Font.custom("Poppins-Bold", size: 42)).frame(maxWidth: .infinity).foregroundColor(.white)
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear{
                    withAnimation(.easeIn(duration: 1.2)) {
                        self.size = 0.42
                        self.opacity = 1.0
                    }
                }
            }.onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.isActive = true
                }
            }.background(LinearGradient(gradient: Gradient(colors: [.purple,.blue]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all))
        }
    }
}
