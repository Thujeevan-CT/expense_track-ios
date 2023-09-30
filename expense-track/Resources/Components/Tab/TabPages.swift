//
//  TabPages.swift
//  ExpenseTrack
//
//  Created by Thujeevan on 2023-09-28.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case dashboard  = "Dashboard"
    case budget = "Budget"
    case add = "Track"
    case report = "Report"
    case profile = "Profile"
    
    var SystemImage: String {
        switch self {
            case .dashboard:
                    return "house"
            case .budget:
                    return "timer"
            case .add:
                    return "plus.circle"
            case .report:
                    return  "doc.text"
            case .profile:
                    return "person.crop.circle"
        }
    }
    
    var index: Int {
        return Tab.allCases.firstIndex(of: self) ?? 0
    }
    
}
