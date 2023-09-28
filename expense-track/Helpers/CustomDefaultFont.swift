//
//  CustomDefaultFont.swift
//  ExpenseTrack
//
//  Created by Thujeevan on 2023-09-17.
//
import SwiftUI


extension Font {
    static func customFont(_ style: TextStyle, size: CGFloat) -> Font {
        if let customFont = Font.custom("Poppins-Bold", size: 48) {
            return customFont
        } else {
            return Font.system(size: size, weight: .regular) // Fallback to the system font
        }
    }
}
