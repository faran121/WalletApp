//
//  OverviewModel.swift
//  Wallet
//
//  Created by Maliks on 17/09/2023.
//

import SwiftUI

struct OverviewModel: Identifiable {
    var id: UUID = .init()
    var type: OverviewType
    var value: [OverviewValue]
    
    struct OverviewValue: Identifiable {
        var id: UUID = .init()
        var month: Date
        var amount: Double
    }
}

enum OverviewType: String {
    case income = "Income"
    case expense = "Expense"
}

var sampleData: [OverviewModel] = [
    .init(type: .income, value: [
        .init(month: .addMonth(-4), amount: 3550),
        .init(month: .addMonth(-3), amount: 2981.5),
        .init(month: .addMonth(-2), amount: 1989.67),
        .init(month: .addMonth(-1), amount: 2987.3),
    ]),
    .init(type: .expense, value: [
        .init(month: .addMonth(-4), amount: 2871.2),
        .init(month: .addMonth(-3), amount: 1628.5),
        .init(month: .addMonth(-2), amount: 700),
        .init(month: .addMonth(-1), amount: 1987.3),
    ])
]

extension Date {
    static func addMonth(_ value: Int) -> Self {
        let calender = Calendar.current
        return calender.date(byAdding: .month, value: value ,to: .init()) ?? .init()
    }
}
