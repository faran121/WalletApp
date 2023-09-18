//
//  ExpenseModel.swift
//  Wallet
//
//  Created by Maliks on 17/09/2023.
//

import SwiftUI

struct Expense: Identifiable {
    var id: UUID = .init()
    var amountSpent: String
    var product: String
    var productIcon: String
    var spendType: String
}

var expenses: [Expense] = [
    Expense(amountSpent: "$120", product: "Amazon", productIcon: "Amazon", spendType: "Groceries"),
    Expense(amountSpent: "$10", product: "Youtube", productIcon: "Youtube", spendType: "Streaming"),
    Expense(amountSpent: "$15", product: "Dribbble", productIcon: "Dribbble", spendType: "Membership"),
    Expense(amountSpent: "$110", product: "Apple", productIcon: "Apple", spendType: "Apple Pay"),
    Expense(amountSpent: "$1200", product: "Patreon", productIcon: "Patreon", spendType: "Membership"),
    Expense(amountSpent: "$5", product: "Instagram", productIcon: "Instagram", spendType: "Ad Publish"),
    Expense(amountSpent: "$1.2", product: "Netflix", productIcon: "Netflix", spendType: "Movies"),
    Expense(amountSpent: "$60", product: "Photoshop", productIcon: "Photoshop", spendType: "Editing"),
    Expense(amountSpent: "$94", product: "Figma", productIcon: "Figma", spendType: "Pro Member"),
]
