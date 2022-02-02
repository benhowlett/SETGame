//
//  SETMatchGame.swift
//  SETGame
//
//  Created by Ben Howlett on 2022-02-01.
//

import SwiftUI

class SETMatchGame: ObservableObject {
    typealias Card = MatchGame<SETCardContent>.Card
    
    // Create a deck of 81 SET cards. Is there a better way than nested for loops?
    static func createSETDeck() -> [Card] {
        var SETDeck: [Card] = []
        SymbolType.allCases.forEach {
            let symbol = $0
            for symbolCount in 1...3 {
                FillType.allCases.forEach {
                    let fill = $0
                    CardColor.allCases.forEach {
                        let color = $0
                        SETDeck.append(Card(content: SETCardContent(symbolType: symbol, symbolCount: symbolCount, color: color, symbolFill: fill), id: SETDeck.count * 2))
                    }
                }
            }
        }
        return SETDeck.shuffled()
    }
    
    static func createSETGame() -> MatchGame<SETCardContent> {
        let cards = createSETDeck()
        return MatchGame<SETCardContent>(cards: cards)
    }
    
    @Published private var model: MatchGame<SETCardContent> = createSETGame()
    
    // MARK: - Intents
    func getCards(count: Int) -> [Card] {
        var count = count
        if count > model.cards.count {
            count = model.cards.count
        }
        return Array(model.cards[0..<count])
    }
    
    // MARK: - SET Card Content
    struct SETCardContent {
        let symbolType: SymbolType
        let symbolCount: Int
        let color: CardColor
        let symbolFill: FillType
    }
    
    enum SymbolType: CaseIterable {
        case diamond
        case squiggle
        case oval
    }
    
    enum FillType: CaseIterable {
        case solid
        case open
        case striped
    }
    
    enum CardColor: CaseIterable {
        case green
        case purple
        case red
    }
    
    @ViewBuilder func SETCardContentView (card: Card) -> some View {
        let symbol = Diamond()
        
        VStack {
            ForEach(0..<card.content.symbolCount) { _ in
                symbol
            }
        }.padding(8)
    }
}
