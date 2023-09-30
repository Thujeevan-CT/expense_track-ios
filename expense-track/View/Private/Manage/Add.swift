//
//  Add.swift
//  ExpenseTrack
//
//  Created by Thujeevan on 2023-09-28.
//

import SwiftUI
import Shimmer

struct Add: View {
    @Binding var activeTab: Tab
    @State private var selection: StatsOptions = .income
    @ObservedObject var expenseCategoryViewModel = ExpenseCategoryViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                Picker("Choose a option", selection: $selection) {
                    ForEach(StatsOptions.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(20)
                
                SelectedOption(activeTab: $activeTab, selected: selection, categories: expenseCategoryViewModel.expenseCategories)
                
                Spacer()
            }
        }.onAppear {
            expenseCategoryViewModel.fetchCategories()
        }
    }
}

enum StatsOptions: String, CaseIterable {
    case income = "INCOME"
    case expense = "EXPENSE"
}

struct Category: Hashable {
    let id: String
    let name: String
}

struct SelectedOption: View {
    @ObservedObject var incomeVM = IncomeViewModel()
    @ObservedObject var expenseVM = ExpenseViewModel()
    @Binding var activeTab: Tab
    
    @State private var selectedCategoryIndex = 0
    @State private var errorMessage: String = ""
    @State private var isShowSuccessPopup: Bool = false
    @State private var date = Date()
    
    var selected: StatsOptions
    var categories: [ExpenseCategory]
    
    var body: some View {
        switch selected {
        case .income:
            VStack {
                TextFieldUI(text: $incomeVM.amount, title: "Amount", placeholder: "Enter income amount", keyboardType: .numberPad).shimmering(active: incomeVM.isLoading)
                TextFieldUI(text: $incomeVM.source, title: "Source", placeholder: "Enter source type").shimmering(active: incomeVM.isLoading)
                DatePicker("Date", selection: $date, displayedComponents: [.date])
                    .frame(maxWidth: .infinity)
                    .padding(.top, 20)
                    .font(Font.custom("Poppins-Regular", size: 14))
                    .accentColor(Color(hex: "#6C0EB7")).shimmering(active: incomeVM.isLoading)
                Text(errorMessage.isEmpty ? "" : errorMessage).foregroundColor(Color.red).font(Font.custom("Poppins-regular", size: 13)).padding(.top, 5)
                if !incomeVM.isLoading {
                    ButtonUI(title: "Save"){
                        incomeVM.date = String(date.timeIntervalSince1970)
                        incomeVM.addIncome { success, message in
                            if (success) {
                                activeTab = .report
                            } else {
                                self.errorMessage = (message ?? message)!
                            }
                        }
                    }.padding(.top, 20).shimmering(active: incomeVM.isLoading)
                }
            }.padding(20)
        case .expense:
            VStack {
                TextFieldUI(text: $expenseVM.amount, title: "Amount", placeholder: "Enter expense amount", keyboardType: .numberPad).shimmering(active: expenseVM.isLoading)
                TextFieldUI(text: $expenseVM.description, title: "Description", placeholder: "Enter description").shimmering(active: expenseVM.isLoading)
                TextFieldUI(text: $expenseVM.location, title: "Location", placeholder: "Enter location").shimmering(active: expenseVM.isLoading)
                Text(errorMessage.isEmpty ? "" : errorMessage).foregroundColor(Color.red).font(Font.custom("Poppins-regular", size: 13)).padding(.top, 5)
                HStack {
                    Text("Select a category:")
                        .font(Font.custom("Poppins-Regular", size: 14))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Picker(selection: $selectedCategoryIndex, label: Text("Category")) {
                        ForEach(0..<categories.count, id: \.self) { index in
                            Text(categories[index].name)
                        }
                    }
                    .pickerStyle(MenuPickerStyle()).accentColor(Color(hex: "#6C0EB7"))
                }.frame(maxWidth: .infinity)
                DatePicker("Date", selection: $date, displayedComponents: [.date])
                    .frame(maxWidth: .infinity)
                    .padding(.top, 20)
                    .font(Font.custom("Poppins-Regular", size: 14))
                    .accentColor(Color(hex: "#6C0EB7"))
                if !expenseVM.isLoading {
                    ButtonUI(title: "Save"){
                        expenseVM.categoryID = categories[selectedCategoryIndex].id
                        expenseVM.date = String(date.timeIntervalSince1970)
                        expenseVM.addExpense { success, message in
                                if (success) {
                                    activeTab = .report
                                } else {
                                    self.errorMessage = (message ?? message)!
                                }

                        }
                    }.padding(.top, 20)
                }
            }.padding(20)
        }
    }
}
