//
//  MatchGame.swift
//  SETGame
//
//  Created by Ben Howlett on 2022-02-01.
//

import Foundation

struct MatchGame<CardContent> {
    private(set) var cards: [Card]
    private(set) var activeCardCount: Int
    private var selectedCardIndices: [Int] = []
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id })
        {
            var cardsRemoved = false
            // Clear previous selections when a 4th card is selected
            if selectedCardIndices.count >= 3 {
                for index in 0..<cards.count {
                    if cards[index].cardState != .isMatched {
                        cards[index].cardState = .none
                    }
                    selectedCardIndices = []
                }
            }
            
            // Only add a selected card to the list of selected cards if it wasn't already selected
            if cards[chosenIndex].cardState != .isSelected {
                selectedCardIndices.append(chosenIndex)
            }
            
            // When 3 cards are selected, check for a match
            if selectedCardIndices.count == 3 {
                if selectedCardsMatch() {
                    for index in 0..<selectedCardIndices.count {
                        cards[selectedCardIndices[index]].cardState = .isMatched
                    }
                } else {
                    for index in 0..<selectedCardIndices.count {
                        cards[selectedCardIndices[index]].cardState = .isNotMatched
                    }
                }
            } else {
                if cards[chosenIndex].cardState == .isSelected {
                    cards[chosenIndex].cardState = .none
                    if let indexToRemove = selectedCardIndices.firstIndex(where: { $0 == chosenIndex }) {
                        selectedCardIndices.remove(at: indexToRemove)
                    }
                } else {
                    cards[chosenIndex].cardState = .isSelected
                }
                
                // Remove matched cards from the deck
                for card in cards {
                    if let index = cards.firstIndex(where: { $0.id == card.id }), card.cardState == .isMatched {
                        cards.remove(at: index)
                        while activeCardCount > cards.count {
                            activeCardCount -= 1
                        }
                        cardsRemoved = true
                    }
                }
                
                // Update the index of the remaining selected card
                if cardsRemoved {
                    for card in cards {
                        if let index = cards.firstIndex(where: { $0.id == card.id }), card.cardState == .isSelected {
                            selectedCardIndices[0] = index
                        }
                    }
                }
            }
            print("\(selectedCardIndices)")
        }
    }
    
    init(cards: [Card], activeCardCount: Int) {
        self.cards = cards
        self.activeCardCount = activeCardCount
    }
    
    mutating func dealCards() {
        if activeCardCount <= cards.count - 3 {
            activeCardCount += 3
        }
    }
    
    // Logic to check if the cards match. Really tried to make this game-independant, but I'm not sure how well it would work with another set of rules
    private func selectedCardsMatch() -> Bool {
        var cardContentStrings: [[String]] = []
        for _ in 0..<("\(cards[0].content)".components(separatedBy: ",").count) {
            cardContentStrings.append([])
        }
        
        var contentMatches = true
        for index in 0..<selectedCardIndices.count {
            let cardContent: [String] = "\(cards[selectedCardIndices[index]].content)".components(separatedBy: ",")
            for index in 0..<cardContent.count {
                cardContentStrings[index].append(cardContent[index])
            }
        }
        
        for contentStrings in cardContentStrings {
            for content in contentStrings {
                print("\(content): \(contentStrings.filter({$0 == content}).count)")
                if contentStrings.filter({$0 == content}).count == 2 {
                    contentMatches = false
                }
            }
        }
        print("\(contentMatches)")
        return contentMatches
    }
            
    struct Card: Identifiable {
//        var isMatched = false
//        var isSelected = false
        var cardState: CardState = .none
        let content: CardContent
        let id: Int
    }
    
    enum CardState: CaseIterable {
        case none
        case isSelected
        case isMatched
        case isNotMatched
    }
}
