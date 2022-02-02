//
//  MatchGame.swift
//  SETGame
//
//  Created by Ben Howlett on 2022-02-01.
//

import Foundation

struct MatchGame<CardContent> {
    private(set) var cards: [Card]
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id })
        {
            cards[chosenIndex].isSelected.toggle()
        }
    }
    
    struct Card: Identifiable {
        var isMatched = false
        var isSelected = false
        let content: CardContent
        let id: Int
    }
}
