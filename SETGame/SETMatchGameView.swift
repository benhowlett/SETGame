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
        VStack {
            Text("SET!").font(.title)
            AspectVGrid(items: game.cards, aspectRatio: 2/3, content: { card in
                CardView(card: card).padding(4)
                    .onTapGesture {
                        game.chose(card)
                    }
            }, minimumColumns: 3).padding(.horizontal, 4)
            Spacer()
            HStack {
                Button {
                    game.newGame()
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)//.foregroundColor(.blue)
                        Text("New Game").font(.title).foregroundColor(.white)
                    }
                }
                Spacer()
                Button {
                    game.dealCards()
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)//.foregroundColor(.blue)
                        Text("Deal Cards").font(.title).foregroundColor(.white)
                    }
                }
            }
            .padding(.horizontal)
            .frame(height: 60)
        }
    }
}

struct CardView: View {
    typealias Card = MatchGame<SETMatchGame.SETCardContent>.Card
    let card: Card
    
    var body: some View {
       ZStack {
           let shape = RoundedRectangle(cornerRadius: 10)
           shape.fill().foregroundColor(.white)
           shape.strokeBorder({(_ card: Card) -> Color in
               switch card.cardState {
               case .none: return Color.blue
               case .isMatched: return Color.green
               case .isSelected: return Color.yellow
               case .isNotMatched: return Color.red
               }
           }(card), lineWidth: 4)
           SETCardContentView(card: card)
       }
    }
    
    @ViewBuilder func SETCardContentView (card: SETMatchGame.Card) -> some View {
        VStack {
            if card.content.symbolFill == .open {
                ForEach(0..<card.content.symbolCount) { _ in
                    switch card.content.symbolType {
                    case .oval: Oval().stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round)).scale(0.9)
                    case .diamond: Diamond().stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round)).scale(0.9)
                    case .squiggle: Squiggle().stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round)).scale(0.9)
                    }
                }
            } else {
                ForEach(0..<card.content.symbolCount) { _ in
                    switch card.content.symbolType {
                    case .oval: Oval()
                    case .diamond: Diamond()
                    case .squiggle: Squiggle()
                    }
                }
            }
        }
        .padding(8)
        .foregroundColor({ () -> Color in
            switch card.content.color {
                case .green: return Color.green
                case .purple: return Color.purple
                case .red: return Color.red
            }
        }())
        .opacity({() -> Double in
            if card.content.symbolFill == .striped {
                return 0.3
            } else {
                return 1
            }
        }())
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = SETMatchGame()
        
        SETMatchGameView(game: game)
            .previewDevice("iPhone 13 mini")
//        SETMatchGameView(game: game)
//            .preferredColorScheme(.dark)
//            .previewDevice("iPhone` 13 mini")
    }
}
