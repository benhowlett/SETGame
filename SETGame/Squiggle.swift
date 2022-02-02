//
//  Squiggle.swift
//  SETGame
//
//  Created by Ben Howlett on 2022-02-02.
//

import SwiftUI

struct Squiggle: Shape {
    func path(in rect: CGRect) -> Path {
        let leftCenter = CGPoint(x: rect.midX - rect.width * 0.125, y: rect.midY)
        let rightCenter = CGPoint(x: rect.midX + rect.width * 0.125, y: rect.midY)
        //let leftArcLeftSide = CGPoint(x: rect.midX - rect.width * 0.375, y: rect.midY)
        let leftArcRightSide = CGPoint(x: rect.midX + rect.width * 0.125, y: rect.midY)
        let rightArcLeftSide = CGPoint(x: rect.midX - rect.width * 0.125, y: rect.midY)
        //let rightArcRightSide = CGPoint(x: rect.midX + rect.width * 0.375, y: rect.midY)
        
        var path = Path()
        path.move(to: leftArcRightSide)
        path.addArc(center: leftCenter, radius: rect.width / 4, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 180), clockwise: true)
        path.addLine(to: rightArcLeftSide)
        path.addArc(center: rightCenter, radius: rect.width / 4, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 360), clockwise: true)
        path.addLine(to: leftArcRightSide)
        return path
    }
}
