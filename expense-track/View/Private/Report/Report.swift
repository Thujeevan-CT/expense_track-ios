//
//  Report.swift
//  ExpenseTrack
//
//  Created by Thujeevan on 2023-09-28.
//

import SwiftUI

struct Report: View {
    @Binding var activeTab: Tab
    @State private var selectedView: ViewOptions = .income
    @ObservedObject var incomeViewModel = IncomeViewModel()
    @ObservedObject var expenseViewModel = ExpenseViewModel()
    
    var body: some View {
        VStack {
            VStack {
                Text("Report").font(Font.custom("Poppins-SemiBold", size: 24))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }.padding(20)
            
            Picker("Choose a option", selection: $selectedView) {
                ForEach(ViewOptions.allCases, id: \.self) {
                    Text($0.rawValue)
                        .background(.orange)
                        .foregroundColor(.orange)
                        .font(Font.custom("Poppins-SemiBold", size: 14))
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20))
            
            ScrollView(.vertical, showsIndicators: true) {
                SelectedView(
                    activeTab: $activeTab, selected: selectedView, incomeViewModel: incomeViewModel, expenseViewModel: expenseViewModel
                )
            }
            
            Spacer()
        }.onAppear {
            incomeViewModel.fetchIncomes { _,_ in }
            expenseViewModel.fetchExpenses { _,_ in }
        }.onChange(of: selectedView) { newDuration in
            if selectedView.rawValue == ViewOptions.income.rawValue {
                incomeViewModel.fetchIncomes { _,_ in }
            } else if selectedView.rawValue == ViewOptions.expense.rawValue {
                expenseViewModel.fetchExpenses { _,_ in }
        }
    }
}

enum ViewOptions: String, CaseIterable {
    case income = "INCOME"
    case expense = "EXPENSE"
}

struct SelectedView: View {
    @Binding var activeTab: Tab
    var selected: ViewOptions
    @ObservedObject var incomeViewModel: IncomeViewModel
    @ObservedObject var expenseViewModel: ExpenseViewModel

    var body: some View {
        switch selected {
        case .income:
            VStack {
                if incomeViewModel.isLoading {
                    CardLoading(status: $incomeViewModel.isLoading)
                } else {
                    ForEach(0..<incomeViewModel.incomes.count, id: \.self) { index in
                        VStack {
                            HStack{
                                Text(String(incomeViewModel.incomes[index].source).uppercased()).frame(maxWidth: .infinity, alignment: .leading)
                                Text("Rs \(String(incomeViewModel.incomes[index].amount)).00")
                            }.frame(maxWidth: .infinity).padding(.bottom, 5)
                            HStack{
                                Text(String(incomeViewModel.incomes[index].date)).frame(maxWidth: .infinity, alignment: .leading)
                                Text(String(incomeViewModel.incomes[index].status).uppercased())
                                    .foregroundStyle(incomeViewModel.incomes[index].status == "active" ? Color.green : Color.red)
                            }.frame(maxWidth: .infinity)
                        }
                        .padding(.all, 10)
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(.top, 10)
                        .shadow(color: Color.black.opacity(0.13), radius: 20, x: 0, y: 0)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            
        case .expense:
            VStack {
                if expenseViewModel.isLoading {
                    CardLoading(status: $expenseViewModel.isLoading)
                } else {
                    ForEach(0..<expenseViewModel.expenses.count, id: \.self) { index in
                        VStack {
                            HStack{
                                Text(String(expenseViewModel.expenses[index].location).uppercased()).frame(maxWidth: .infinity, alignment: .leading)
                                Text("Rs \(String(expenseViewModel.expenses[index].amount)).00").foregroundStyle(Color.red)
                            }.frame(maxWidth: .infinity).padding(.bottom, 5)
                            HStack{
                                Text(String(expenseViewModel.expenses[index].date)).frame(maxWidth: .infinity, alignment: .leading)
                                Text(String(expenseViewModel.expenses[index].category.name))
                            }.frame(maxWidth: .infinity)
                        }
                        .padding(.all, 10)
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(.top, 10)
                        .shadow(color: Color.black.opacity(0.13), radius: 20, x: 0, y: 0)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
        }
        }
    }
}
