//
//  MatchGame.swift
//  SETGame
//
//  Created by Ben Howlett on 2022-02-01.
//

import Foundation

struct MatchGame<CardContent> {
    private(set) var cards: [Card]
    private(set) var activeCardCount: Int = 12
    private var selectedCardIndices: [Int] = []
    private var cardsRemoved = false
    private var existingMatches: [[Int]] = []
    private(set) var score = 0
    private(set) var isFirstDeal = true
    private(set) var dealt = Set<UUID>()
   
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id })
        {
            // Clear previous selections when a 4th card is selected
            if selectedCardIndices.count == 3 {
                removeMatchedCards()
                for index in 0..<cards.count {
                    if cards[index].cardState != .isMatched {
                        cards[index].cardState = .none
                    }
                }
                selectedCardIndices = []
                //removeMatchedCards()
                findExistingMatches()
            }
            
            // Only add a selected card to the list of selected cards if it wasn't already selected
            if cards[chosenIndex].cardState != .isSelected {
                selectedCardIndices.append(chosenIndex)
            }
            
            // When 3 cards are selected, check for a match
            if selectedCardIndices.count == 3 {
                if selectionIsExistingMatch() {
                    for index in 0..<selectedCardIndices.count {
                        cards[selectedCardIndices[index]].cardState = .isMatched
                    }
                    score += 1
                } else {
                    for index in 0..<selectedCardIndices.count {
                        cards[selectedCardIndices[index]].cardState = .isNotMatched
                    }
                    score -= 1
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
            }
        }
    }
    
    init(cards: [Card]) {
        self.cards = cards
    }
    
    mutating func dealCards() {
        if selectedCardIndices.count == 3, selectionIsExistingMatch() {
            removeMatchedCards()
        }
        else if activeCardCount <= cards.count - 3 {
            if !existingMatches.isEmpty {
                score -= 1
            }
            activeCardCount += 3
        }
        findExistingMatches()
    }
    
    // Check the cards at the selectedCardIndices to see if they match
    mutating func removeMatchedCards() {
        for card in cards {
            if let index = cards.firstIndex(where: { $0.id == card.id }), card.cardState == .isMatched {
                if cards.count > activeCardCount {
                    let newCard = cards.remove(at: activeCardCount)
                    cards.insert(newCard, at: index)
                    cards.remove(at: index + 1)
                } else {
                    cards.remove(at: index)
                }
                while activeCardCount > cards.count {
                    activeCardCount -= 1
                }
                cardsRemoved = true
            }
        }
    }
    
    mutating func flipCard(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }) {
            cards[chosenIndex].isFaceUp = true
        }
    }
    
    mutating func markFirstDealDone() {
        if isFirstDeal {
            isFirstDeal = false
        }
    }
    
    // Logic to check if the cards match. Tried to make this game-independant, but I'm not sure how well it would work with another set of rules
    private func cardsMatch(_ cardIndices: [Int]) -> Bool {
        var cardContentStrings: [[String]] = []
        for _ in 0..<("\(cards[0].content)".components(separatedBy: ",").count) {
            cardContentStrings.append([])
        }

        var contentMatches = true
        for index in 0..<cardIndices.count {
            let cardContent: [String] = "\(cards[cardIndices[index]].content)".components(separatedBy: ",")
            for index in 0..<cardContent.count {
                cardContentStrings[index].append(cardContent[index])
            }
        }

        for contentStrings in cardContentStrings {
            for content in contentStrings {
                if contentStrings.filter({$0 == content}).count == 2 {
                    contentMatches = false
                }
            }
        }
        return contentMatches
    }
    
    private mutating func findExistingMatches() {
        if cards.count > 3 {
            existingMatches = []
            for firstIndex in 0..<activeCardCount - 2 {
                for secondIndex in firstIndex + 1..<activeCardCount - 1 {
                    for thirdIndex in secondIndex + 1..<activeCardCount {
                        if thirdIndex != firstIndex, thirdIndex != secondIndex {
                            if cardsMatch([firstIndex, secondIndex, thirdIndex]) {
                                existingMatches.append([firstIndex, secondIndex, thirdIndex].sorted())
                            }
                        }
                    }
                }
            }
        }
    }
        
    private func selectionIsExistingMatch() -> Bool {
        var selectionIsAnExistingMatch = false
        let selection = selectedCardIndices.sorted()
        
        for match in existingMatches {
            if selection == match {
                selectionIsAnExistingMatch = true
                break
            }
        }
        return selectionIsAnExistingMatch
    }
    
    struct Card: Identifiable {
        var cardState: CardState = .none
        var isFaceUp: Bool = false
        let content: CardContent
        let id = UUID()
    }
    
    enum CardState {
        case none
        case isSelected
        case isMatched
        case isNotMatched
    }
}
