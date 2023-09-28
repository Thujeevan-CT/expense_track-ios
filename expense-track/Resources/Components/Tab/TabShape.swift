//
//  TabShape.swift
//  ExpenseTrack
//
//  Created by Thujeevan on 2023-09-28.
//

import SwiftUI

struct TabShape: Shape {
    var midPoint: CGFloat
    
    var animatableData: CGFloat {
        get { midPoint }
        set {
            midPoint = newValue
        }
    }
    
    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.addPath(Rectangle().path(in: rect))
            path.move(to: .init(x: midPoint - 60, y: 0))
            
            let to = CGPoint(x: midPoint, y: -25)
            let controlOne = CGPoint(x: midPoint - 25, y: 0)
            let controlTwo = CGPoint(x: midPoint - 25, y: -25)
            path.addCurve(to: to, control1: controlOne, control2: controlTwo)
            
            let toOne = CGPoint(x: midPoint + 60, y: 0)
            let control1 = CGPoint(x: midPoint + 25, y: -25)
            let control2 = CGPoint(x: midPoint + 25, y: 0)
            path.addCurve(to: toOne, control1: control1, control2: control2)
            
        }
    }
}
