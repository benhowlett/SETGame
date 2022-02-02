//
//  Diamond.swift
//  SETGame
//
//  Created by Ben Howlett on 2022-02-02.
//

import SwiftUI

struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let leftPoint = CGPoint(x: center.x - rect.width / 2, y: rect.midY)
        let topPoint = CGPoint(x: rect.midX, y: rect.midY - rect.width / 4)
        let rightPoint = CGPoint(x: center.x + rect.width / 2, y: rect.midY)
        let bottomPoint = CGPoint(x: rect.midX, y: rect.midY + rect.width / 4)
        
        var path = Path()
        path.move(to: leftPoint)
        path.addLine(to: topPoint)
        path.addLine(to: rightPoint)
        path.addLine(to: bottomPoint)
        path.addLine(to: leftPoint)
        
        return path
    }
}
