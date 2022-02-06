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
            gameBody
            Spacer()
            VStack {
                Text("Score: \(game.getScore())")
                HStack {
                    newGame
                    Spacer()
                    dealCards
                }
                .padding()
            }
        }
    }
    
    var gameBody: some View {
        AspectVGrid(items: game.cards, aspectRatio: DrawingConstants.cardAspectRatio, content: { card in
            CardView(card: card)
                .padding(DrawingConstants.cardPadding)
                .transition(AnyTransition.scale)
                .scaleEffect(card.cardState == .isMatched ? 1.05 : 1)
                .animation(.easeInOut, value: card.cardState)
                .onTapGesture {
                    game.chose(card)
                }
        }, minimumColumns: DrawingConstants.minCardColumns)
        .padding(.horizontal, DrawingConstants.cardPadding)
        
    }
    
    var newGame: some View {
        Button {
            withAnimation {
                game.newGame()
            }
        } label: {
            Text("New Game").font(.title)
        }
    }
    
    var dealCards: some View {
        Button {
            withAnimation {
                game.dealCards()                
            }
        } label: {
            Text("Deal Cards").font(.title)
        }
    }
    
    private struct DrawingConstants {
        static let cardPadding: CGFloat = 4
        static let minCardColumns: Int = 3
        static let cardAspectRatio: CGFloat = 2/3
    }
}

struct CardView: View {
    typealias Card = MatchGame<SETMatchGame.SETCardContent>.Card
    let card: Card

    var body: some View {
       ZStack {
           let shape = RoundedRectangle(cornerRadius: DrawingConstants.cardCornerRadius)
           shape.fill().foregroundColor(.white)
           shape.strokeBorder({(_ card: Card) -> Color in
               switch card.cardState {
               case .none: return Color.blue
               case .isMatched: return Color.green
               case .isSelected: return Color.yellow
               case .isNotMatched: return Color.red
               }
           }(card), lineWidth: DrawingConstants.cardStrokeWidth)
           SETCardContentView(card: card)
               
       }
    }
    
    @ViewBuilder func SETCardContentView (card: SETMatchGame.Card) -> some View {
        VStack {
            ForEach(0..<card.content.symbolCount, id: \.self) { _ in
                if card.content.symbolFill == .open {
                    switch card.content.symbolType {
                    case .oval: Oval().stroke(style: StrokeStyle(lineWidth: DrawingConstants.symbolStrokeWidth, lineCap: .round, lineJoin: .round)).scale(DrawingConstants.symbolScale)
                    case .diamond: Diamond().stroke(style: StrokeStyle(lineWidth: DrawingConstants.symbolStrokeWidth, lineCap: .round, lineJoin: .round)).scale(DrawingConstants.symbolScale)
                    case .squiggle: Squiggle().stroke(style: StrokeStyle(lineWidth: DrawingConstants.symbolStrokeWidth, lineCap: .round, lineJoin: .round)).scale(DrawingConstants.symbolScale)
                    }
                } else {
                    switch card.content.symbolType {
                    case .oval: Oval()
                    case .diamond: Diamond()
                    case .squiggle: Squiggle()
                    }
                }
            }
        }
        .padding(DrawingConstants.symbolPadding)
        .foregroundColor({ () -> Color in
            switch card.content.color {
                case .green: return Color.green
                case .purple: return Color.purple
                case .red: return Color.red
            }
        }())
        .opacity({() -> Double in
            if card.content.symbolFill == .striped {
                return DrawingConstants.stripedOpacity
            } else {
                return DrawingConstants.filledOpacity
            }
        }())
    }
    
    private struct DrawingConstants {
        static let cardCornerRadius: CGFloat = 10
        static let cardStrokeWidth: CGFloat = 4
        static let symbolPadding: CGFloat = 8
        static let symbolStrokeWidth: CGFloat = 4
        static let symbolScale: CGFloat = 0.9
        static let stripedOpacity: CGFloat = 0.3
        static let filledOpacity: CGFloat = 1
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
