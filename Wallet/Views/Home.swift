//
//  Home.swift
//  Wallet
//
//  Created by Maliks on 17/09/2023.
//

import SwiftUI
import Charts

struct Home: View {
    
    var size: CGSize
    
    @State private var expandCards: Bool = false
    @State private var showDetailView: Bool = false
    @State private var showDetailContent: Bool = false
    @State private var selectedCard: Card?
    
    @Namespace private var animation
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    
                } label: {
                    Image(systemName: "line.3.horizontal")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Your Balance")
                        .font(.caption)
                        .foregroundColor(.black)
                    
                    Text("$50000")
                        .font(.title.bold())
                }
            }
            .padding([.horizontal, .top], 15)
            
            // Cards View
            CardsView()
                .padding(.horizontal, 15)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 15) {
                    BottomScrollContent()
                }
                .padding(.top, 30)
                .padding([.horizontal, .bottom], 15)
            }
            .frame(maxWidth: .infinity)
            .background {
                // Custom Corners
                CustomCorner(corners: [.topLeft, .topRight], radius: 30)
                    .fill(.white)
                    .ignoresSafeArea()
                    .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: -5)
            }
            .padding(.top, 20)
        }
        .background {
            Rectangle()
                .fill(.black.opacity(0.05))
                .ignoresSafeArea()
        }
        .overlay(content: {
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()
                .overlay(alignment: .top, content: {
                    HStack {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    expandCards = false
                                }
                            }
                        
                        Spacer()
                        
                        Text("All Cards")
                            .font(.title2.bold())
                    }
                    .padding(15)
                })
                .opacity(expandCards ? 1 : 0)
        })
        .overlay(content: {
            if let selectedCard, showDetailView {
                DetailView(selectedCard)
                    .transition(.asymmetric(insertion: .identity, removal: .offset(y: 5)))
            }
        })
        .overlayPreferenceValue(CardRectKey.self) { preferences in
            if let cardPreference = preferences["CardRect"] {
                GeometryReader { reader in
                    let cardRect = reader[cardPreference]
                    
                    CardContent()
                        .frame(width: cardRect.width, height: expandCards ? nil : cardRect.height)
                        .offset(x: cardRect.minX, y: cardRect.minY)
                }
                .allowsHitTesting(!showDetailView)
            }
        }
    }
    
    @ViewBuilder
    func BottomScrollContent() -> some View {
        VStack(spacing: 15) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Instant Transfer")
                    .font(.title3.bold())
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(1...6, id: \.self) { index in
                            Image("Pic\(index)")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 55, height: 55)
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal, 15)
                    .padding(.top, 10)
                }
                .padding(.horizontal, -15)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Overview")
                        .font(.title3.bold())
                    
                    Spacer()
                    
                    Text("Last 4 Months")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Chart(sampleData) { overview in
                    ForEach(overview.value) { data in
                        BarMark(x: .value("Month", data.month, unit: .month), y: .value(overview.type.rawValue, data.amount))
                    }
                    .foregroundStyle(by: .value("Type", overview.type.rawValue))
                    .position(by: .value("Type", overview.type.rawValue))
                }
                .chartForegroundStyleScale(range: [Color.green.gradient, Color.red.gradient])
                .frame(height: 200)
                .padding(.top, 25)
            }
            .padding(.top, 15)
        }
    }
    
    @ViewBuilder
    func CardsView() -> some View {
        Rectangle()
            .foregroundColor(.clear)
            .frame(height: 245)
            .anchorPreference(key: CardRectKey.self, value: .bounds) { anchor in
                return ["CardRect": anchor]
            }
    }
    
    @ViewBuilder
    func CardView(_ card: Card) -> some View {
        GeometryReader {
            let size = $0.size
            
            VStack(spacing: 0) {
                Rectangle()
                    .fill(card.cardColor.gradient)
                    .overlay(alignment: .top) {
                        VStack {
                            HStack {
                                Image("Sim")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 55, height: 55)
                                
                                Spacer(minLength: 0)
                                
                                Image(systemName: "wave.3.right")
                                    .font(.largeTitle.bold())
                            }
                            
                            Text(card.cardBalance)
                                .font(.title2.bold())
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .offset(y: 5)
                        }
                        .padding(20)
                        .foregroundColor(.black)
                    }
                
                Rectangle()
                    .fill(.black)
                    .frame(height: size.height / 3.5)
                    .overlay {
                        HStack {
                            Text(card.carName)
                                .fontWeight(.semibold)
                            
                            Spacer(minLength: 0)
                            
                            Image("Visa")
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                        }
                        .foregroundColor(.white)
                        .padding(15)
                    }
            }
            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        }
    }
    
    @ViewBuilder
    func CardContent() -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                ForEach(cards.reversed()) { card in
                    
                    let index = CGFloat(indexOf(card))
                    let reversedIndex = CGFloat(cards.count - 1) - index
                    let displayingStackIndex = min(index, 2)
                    let displayScale = (displayingStackIndex / CGFloat(cards.count)) * 0.15
                    
                    ZStack {
                        if selectedCard?.id == card.id && showDetailView {
                            Rectangle()
                                .foregroundColor(.clear)
                        }
                        else {
                            CardView(card)
                                .rotation3DEffect(.init(degrees: expandCards ? (showDetailView ? 0 : -15) : 0), axis: (x: 1, y: 0, z: 0), anchor: .top)
                                .matchedGeometryEffect(id: card.id, in: animation)
                                .offset(y: showDetailView ? (size.height * 0.9) : 0)
                                .onTapGesture {
                                    if expandCards {
                                        selectedCard = card
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            showDetailView = true
                                        }
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                            withAnimation(.easeInOut(duration: 0.3)) {
                                                showDetailContent = true
                                            }
                                        }
                                    }
                                    else {
                                        withAnimation(.easeInOut(duration: 0.35)) {
                                            expandCards = true
                                        }
                                    }
                                }
                        }
                    }
                    .frame(height: 200)
                    .scaleEffect(1 - (expandCards ? 0 : displayScale))
                    .offset(y: expandCards ? 0 : (displayingStackIndex * -15))
                    .offset(y: reversedIndex * -200)
                    .padding(.top, expandCards ? (reversedIndex == 0 ? 0 : 80) : 0)
                }
            }
            .padding(.top, 45)
            .padding(.bottom, CGFloat(cards.count - 1) * -200)
        }
        .scrollDisabled(!expandCards)
    }
    
    @ViewBuilder
    func DetailView(_ card: Card) -> some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showDetailContent = false
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showDetailView = false
                        }
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title3.bold())
                }
                
                Spacer()
                
                Text("Transactions")
                    .font(.title2.bold())
            }
            .foregroundColor(.black)
            .padding(15)
            .opacity(showDetailContent ? 1 : 0)
            
            CardView(card)
                .rotation3DEffect(.init(degrees: showDetailContent ? 0 : -15), axis: (x: 1, y: 0, z: 0), anchor: .top)
                .matchedGeometryEffect(id: card.id, in: animation)
                .frame(height: 200)
                .padding([.horizontal, .top], 15)
                .zIndex(1000)

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 15) {
                    ForEach(expenses) { expense in
                        HStack(spacing: 12) {
                            Image(expense.productIcon)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(expense.product)
                                    .fontWeight(.bold)
                                
                                Text(expense.spendType)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer(minLength: 0)
                            
                            Text(expense.amountSpent)
                                .fontWeight(.semibold)
                        }
                        
                        Divider()
                    }
                }
                .padding(.top, 25)
                .padding([.horizontal, .bottom], 15)
            }
            .background {
                CustomCorner(corners: [.topLeft, .topRight], radius: 30)
                    .fill(.white)
                    .padding(.top, -120)
                    .ignoresSafeArea()
            }
            .offset(y: !showDetailContent ? (size.height * 0.7) : 0)
            .opacity(showDetailContent ? 1 : 0)
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .background {
            Rectangle()
                .fill(Color.gray)
                .ignoresSafeArea()
                .opacity(showDetailContent ? 1 : 0)
        }
    }
    
    private func indexOf(_ card: Card) -> Int {
        return cards.firstIndex { card.id == $0.id } ?? 0
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
