//
//  SETMatchGame.swift
//  SETGame
//
//  Created by Ben Howlett on 2022-02-01.
//

import SwiftUI

class SETMatchGame: ObservableObject {
    typealias Card = MatchGame<SETCardContent>.Card
    static var SETDeck: [Card] = []

    @Published private var model: MatchGame<SETCardContent> = createSETMatchGame()
    
    static func createSETMatchGame() -> MatchGame<SETCardContent> {
        if SETDeck.isEmpty {
            SETDeck = createSETDeck()
        }
        return MatchGame<SETCardContent>(cards: SETDeck.shuffled())
    }
    
    // Create a deck of 81 SET cards. Is there a better way than nested for loops?
    static func createSETDeck() -> [Card] {
        var deck: [Card] = []
        SymbolType.allCases.forEach {
            let symbol = $0
            for symbolCount in 1...3 {
                FillType.allCases.forEach {
                    let fill = $0
                    CardColor.allCases.forEach {
                        let color = $0
                        deck.append(Card(cardState: .none, content: SETCardContent(symbolType: symbol, symbolCount: symbolCount, color: color, symbolFill: fill)))
                    }
                }
            }
        }
        SETDeck.forEach({
            print("\($0.id)")
        })
        return deck
    }
    
    var activeCards: Array<Card> {
        Array(model.cards[0..<model.activeCardCount])
    }
    
    var allCards: Array<Card> {
        model.cards
    }
    
    // MARK: - Intents
    func chose(_ card: Card) {
        model.choose(card)
    }
    
    func dealCards() {
        model.dealCards()
    }
    
    func newGame() {
        model = SETMatchGame.createSETMatchGame()
    }
    
    func getScore() -> Int {
        model.score
    }
    
    func flipCard(_ card: Card) {
        model.flipCard(card)
    }
    
    func isFirstDeal() -> Bool {
        model.isFirstDeal
    }
    
    func markFirstDealDone() {
        model.markFirstDealDone()
    }
    
    // MARK: - SET Card Content
    struct SETCardContent {
        let symbolType: SymbolType
        let symbolCount: Int
        let color: CardColor
        let symbolFill: FillType
    }
    
    enum SymbolType: Int, CaseIterable {
        case diamond = 0
        case squiggle
        case oval
    }
    
    enum FillType: Int, CaseIterable {
        case solid = 0
        case open
        case striped
    }
    
    enum CardColor: Int, CaseIterable {
        case green = 0
        case purple
        case red
    }
    
}
