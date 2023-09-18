//
//  CardModel.swift
//  Wallet
//
//  Created by Maliks on 17/09/2023.
//

import SwiftUI

struct Card: Identifiable {
    var id: UUID = .init()
    var cardColor: Color
    var carName: String
    var cardBalance: String
}

var cards: [Card] = [
    .init(cardColor: Color("Card1"), carName: "John", cardBalance: "$5000"),
    .init(cardColor: Color("Card2"), carName: "Alice", cardBalance: "$6000"),
    .init(cardColor: Color("Card3"), carName: "Bob", cardBalance: "$11000"),
    .init(cardColor: Color("Card4"), carName: "Freya", cardBalance: "$22000")
]
