//
//  SETGameApp.swift
//  SETGame
//
//  Created by Ben Howlett on 2022-02-01.
//

import SwiftUI

@main
struct SETGameApp: App {
    let game = SETMatchGame()
    
    var body: some Scene {
        WindowGroup {
            SETMatchGameView(game: game)
        }
    }
}
