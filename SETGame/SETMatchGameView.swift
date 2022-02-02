//
//  SETMatchGameView.swift
//  SETGame
//
//  Created by Ben Howlett on 2022-02-01.
//

import SwiftUI

struct SETMatchGameView: View {
    @ObservedObject var game: SETMatchGame
    
    var body: some View {
        AspectVGrid(items: game.getCards(count: 3), aspectRatio: 2/3, content: { card in
            CardView(card: card).padding(4)
        }, minimumColumns: 3)
        
    }
}

struct CardView: View {
    let card: MatchGame<SETMatchGame.SETCardContent>.Card
    
    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 10)
            shape.fill().foregroundColor(.white)
            shape.strokeBorder(lineWidth: 5)
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = SETMatchGame()
        
        SETMatchGameView(game: game)
            .previewDevice("iPhone 13 mini")
    }
}
