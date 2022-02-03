//
//  Oval.swift
//  SETGame
//
//  Created by Ben Howlett on 2022-02-02.
//

import SwiftUI

struct Oval: Shape {
    func path(in rect: CGRect) -> Path {
        Path(ellipseIn: CGRect(x: rect.minX, y: rect.midY - rect.width / 4, width: rect.width, height: rect.width / 2))
    }
}
