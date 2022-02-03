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
        AspectVGrid(items: game.getCards(count: 18), aspectRatio: 2/3, content: { card in
            CardView(card: card, game: game).padding(4)
                .onTapGesture {
                    game.chose(card)
                }
        }, minimumColumns: 3).padding(4)
        
    }
}

struct CardView: View {
    let card: MatchGame<SETMatchGame.SETCardContent>.Card
    let game: SETMatchGame
    
    var body: some View {
       ZStack {
           let shape = RoundedRectangle(cornerRadius: 10)
           shape.fill().foregroundColor(.white)
           shape.strokeBorder(card.isSelected ? .yellow : .blue, lineWidth: 4)
           game.SETCardContentView(card: card)
       }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = SETMatchGame()
        
        SETMatchGameView(game: game)
            .previewDevice("iPhone 13 mini")
        SETMatchGameView(game: game)
            .preferredColorScheme(.dark)
            .previewDevice("iPhone 13 mini")
    }
}
