//
//  Card.swift
//  ExpenseTrack
//
//  Created by Thujeevan on 2023-09-30.
//

import SwiftUI

struct Card: View {
    var body: some View {
        VStack {
            ForEach(0..<budgetVM.budgets.count, id: \.self) { index in
                VStack {
                    HStack{
                        Text(String(budgetVM.budgets[index].budget_type).uppercased()).frame(maxWidth: .infinity, alignment: .leading)
                        Text("Rs " + String(budgetVM.budgets[index].amount) + ".00")
                    }.frame(maxWidth: .infinity).padding(.bottom, 5)
                    HStack{
                        Text(String(budgetVM.budgets[index].start_date)).frame(maxWidth: .infinity, alignment: .leading)
                        Text(String(budgetVM.budgets[index].end_date))
                    }.frame(maxWidth: .infinity)
                }
                .padding(.all, 10)
                .background(Color.white)
                .cornerRadius(10)
                .padding(.top, 10)
                .shadow(color: Color.black.opacity(0.13), radius: 20, x: 0, y: 0)
            }
        }.frame(maxWidth: .infinity)
    }
}

#Preview {
    Card()
}
