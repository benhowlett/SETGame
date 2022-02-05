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
    private var cardsRemoved = false
    private var existingMatches: [[Int]] = []
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id })
        {
            // Clear previous selections when a 4th card is selected
            if selectedCardIndices.count >= 3 {
                for index in 0..<cards.count {
                    if cards[index].cardState != .isMatched {
                        cards[index].cardState = .none
                    }
                }
                selectedCardIndices = []
                removeMatchedCards()
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
            }
        }
    }
    
    init(cards: [Card], activeCardCount: Int) {
        self.cards = cards
        self.activeCardCount = activeCardCount
        findExistingMatches()
    }
    
    mutating func dealCards() {
        if selectedCardIndices.count == 3, selectionIsExistingMatch() {
            removeMatchedCards()
        }
        else if activeCardCount <= cards.count - 3 {
            activeCardCount += 3
        }
        findExistingMatches()
    }
    
    // Check the cards at the selectedCardIndices to see if they match
    mutating func removeMatchedCards() {
        //print("\(cards[0..<activeCardCount])")
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
                //print("\(cards[0..<activeCardCount])")
            }
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
        existingMatches = []
        for firstIndex in 0..<activeCardCount {
            for secondIndex in 0..<activeCardCount {
                for thirdIndex in 0..<activeCardCount {
                    if thirdIndex != firstIndex, thirdIndex != secondIndex {
                        if cardsMatch([firstIndex, secondIndex, thirdIndex]) {
                            existingMatches.append([firstIndex, secondIndex, thirdIndex].sorted())
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
        let content: CardContent
        let id: Int
    }
    
    enum CardState {
        case none
        case isSelected
        case isMatched
        case isNotMatched
    }
}
