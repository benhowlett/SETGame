//
//  SETMatchGameView.swift
//  SETGame
//
//  Created by Ben Howlett on 2022-02-01.
//

import SwiftUI

struct SETMatchGameView: View {
    @ObservedObject var game: SETMatchGame
    @State private var dealt = Set<UUID>()
    @State private var dealDelay = 0.0
    @State private var lastDealtCount = 0
    @Namespace private var dealingNamespace
    
    var body: some View {
        VStack {
            Text("SET!").font(.title)
            gameBody
            Spacer()
            VStack {
                Text("Score: \(game.getScore())")
                HStack {
                    Spacer()
                    newGame
                    Spacer()
                    deckBody
                    Spacer()
                }
                .padding()
            }
        }
    }
    
    private func deal(_ card: SETMatchGame.Card) {
        dealt.insert(card.id)
    }

    private func isUndealt(_ card: SETMatchGame.Card) -> Bool {
        !dealt.contains(card.id)
    }
    
    private func dealAnimation(_ card: SETMatchGame.Card) -> Animation {
        var dealDuration = 0.0
        if game.isFirstDeal() {
            dealDuration = CardConstants.initialDealDuration
        } else {
            dealDuration = CardConstants.additionalDealDuration
        }
        let delay = Double((dealt.count-lastDealtCount)) * (dealDuration / Double((game.activeCards.count - lastDealtCount)))
        return Animation.easeInOut(duration: CardConstants.dealDuration).delay(delay)
    }
    
    private func zIndex(of card: SETMatchGame.Card) -> Double {
        -Double(game.allCards.firstIndex(where: { $0.id == card.id }) ?? 0)
    }
    
    var gameBody: some View {
        AspectVGrid(items: game.activeCards, aspectRatio: CardConstants.cardAspectRatio, minimumColumns: CardConstants.minCardColumns) { card in
            createCardView(from: card)                
        }
        .padding(.horizontal, CardConstants.cardPadding)
        
    }
    
    var deckBody: some View {
        ZStack {
            ForEach(game.allCards.filter(isUndealt)) { card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
                    .zIndex(zIndex(of: card))
            }
        }
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
        .onTapGesture {
            game.dealCards()
            for card in game.activeCards {
                withAnimation(dealAnimation(card)) {
                    deal(card)
                }
                game.flipCard(card)
            }
            game.markFirstDealDone()
            lastDealtCount = dealt.count
        }
    }
    
    @ViewBuilder private func createCardView(from card: SETMatchGame.Card) -> some View {
        if isUndealt(card) {
            Color.clear
        } else {
            CardView(card: card)
                .padding(CardConstants.cardPadding)
                .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale))
                .zIndex(zIndex(of: card))
                .onTapGesture {
                    withAnimation {
                        game.chose(card)
                    }
                }
        }
    }
    
    var newGame: some View {
        Button {
            dealt = []
            withAnimation {
                game.newGame()
            }
        } label: {
            Text("New Game").font(.title)
        }
    }
   
   
    private struct CardConstants {
        static let cardPadding: CGFloat = 4
        static let minCardColumns: Int = 3
        static let cardAspectRatio: CGFloat = 2/3
        static let undealtHeight: CGFloat = 90
        static let undealtWidth: CGFloat = undealtHeight * cardAspectRatio
        static let color: Color = .blue
        static let initialDealDuration: Double = 2
        static let additionalDealDuration: Double = 0.8
        static let dealDuration: Double = 0.4
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
