//
//  ContentView.swift
//  Flashzilla
//
//  Created by Andreas Zwikirsch on 26.08.22.
//

import SwiftUI

enum SheetType {
    case editCards, settings
}

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(x: 0, y: offset * 10)
    }
}

struct ContentView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled
    @State private var cards = [Card]()
    
    @State private var timeRemaining = 10000
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @Environment(\.scenePhase) var scenePhase
    @State private var isActive = true
    
    @State private var showingEditSceen = false
    @State var answerStatus = false
    @State private var showAlert = false
    
    @State private var leftHandMode = false
    
    @State private var showingSheet = false
    @State private var retryIncorrectCards = false
    @State private var sheetType = SheetType.editCards
    
    @State private var allCardsCount = 0
    @State private var correctCards = 0
    @State private var wrongCards = 0
    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Time: \(timeRemaining)")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 5)
                        .background(.black.opacity(0.75))
                        .clipShape(Capsule())
                    
                    HStack {
                        Image(systemName: "xmark.circle")
                            .font(.system(size: 25))
                        Text("\(wrongCards)")
                    }
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(.black.opacity(0.75))
                    .clipShape(Capsule())

                    HStack {
                        Image(systemName: "checkmark.circle")
                            .font(.system(size: 25))
                        Text("\(correctCards)/\(allCardsCount)")
                    }
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(.black.opacity(0.75))
                    .clipShape(Capsule())
                }
                
                ZStack {
                    ForEach(cards) { card in
                        CardView(card: card, retryIncorrectCards: self.retryIncorrectCards) { isCorrect in
                            withAnimation(.linear) {
//                                removeCard(at: self.index(for: card))
//                                setCardBackToStaple(at: self.index(for: card), card: card, retryIncorrectCards: retryIncorrectCards)
                                if isCorrect {
                                    self.correctCards += 1
                                }
                                else {
                                    self.wrongCards += 1

                                    // Challenge 2
                                    if self.retryIncorrectCards {
                                        self.restackCard(at: self.index(for: card))
                                        return
                                    }
                                }
                                
                                withAnimation {
                                    self.removeCard(at: self.index(for: card))
                                }
                            }
                        }
                        .stacked(at: self.index(for: card), in: cards.count)
                        .allowsHitTesting(self.index(for: card) == cards.count - 1)
                        .accessibilityHidden(self.index(for: card) < cards.count - 1)
//                        .alert(isPresented: $showAlert) {
//                            Alert(
//                                title: Text("How good did you know this card?"),
//                                message: Text("choose your level"),
//                                primaryButton: .default(Text("Perfect")) {
//                                    setCardBackToStaple(at: self.index(for: card), card: cards[cards.count-1], isCorrect: true)
//                                },
//                                secondaryButton: .default(Text("again pleace")) {
//                                    setCardBackToStaple(at: self.index(for: card), card: cards[cards.count-1], isCorrect: false)
//                                }
//                            )
//                        }
                    }
                }
                .allowsHitTesting(timeRemaining > 0)
                
                if cards.isEmpty {
                    Button("Start Again", action: resetCards)
                        .padding()
                        .background(.white)
                        .foregroundColor(.black)
                        .clipShape(Capsule())
                }
            }
            
            VStack {
                HStack {
                    if !leftHandMode {
                        Spacer()
                    }
                    
                    VStack {
                        Button {
                            self.showSheet(type: .editCards)
                            showingSheet = true
                        } label: {
                            Image(systemName: "plus.circle")
                                .padding(18)
                                .background(.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        
                        Button {
                            timeRemaining = 10000
                            resetCards()
                        } label: {
                            Image(systemName: "clock.arrow.circlepath")
                                .padding(18)
                                .background(.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        
                        Button {
                            cards.shuffle()
                        } label: {
                            Image(systemName: "shuffle.circle")
                                .padding(18)
                                .background(.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        
                        Button {
                            self.showSheet(type: .settings)
                        } label: {
                            Image(systemName: "gear")
                                .padding(18)
                                .background(.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                    }
                    
                    if leftHandMode {
                        Spacer()
                    }
                }
                
                Spacer()
            }
            .foregroundColor(.white)
            .font(.largeTitle)
            .padding()
            
            if differentiateWithoutColor || voiceOverEnabled {
                VStack {
                    Spacer()
                    
                    HStack {
                        Button {
                            withAnimation {
//                                removeCard(at: cards.count - 1)
//                                setCardBackToStaple(at: cards.count-1, card: cards[cards.count-1], retryIncorrectCards: false)
                            }
                        } label: {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibilityLabel("Wrong")
                        .accessibilityHint("Mark your answer as being incorrect")
                        
                        
                        Spacer()
                        
                        Button {
                            withAnimation {
//                                removeCard(at: cards.count - 1)
//                                setCardBackToStaple(at: cards.count-1, card: cards[cards.count-1], retryIncorrectCards: true)
                                
                            }
                        } label: {
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibilityLabel("Correct")
                        .accessibilityHint("Mark your answer as being correct")
                    }
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding()
                }
            }
        }
        .onReceive(timer) { time in
            guard isActive else { return }
            
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                if cards.isEmpty == false {
                    isActive = true
                }
            } else {
                isActive = false
            }
        }
//        .sheet(isPresented: $showingSheet, onDismiss: resetCards, content: EditCardsView.init)
        .sheet(isPresented: $showingSheet, onDismiss: resetCards) {
            // Challenge 3
            if self.sheetType == .editCards {
                EditCardsView()
            } else if self.sheetType == .settings {
                SettingsView(leftHandMode: $leftHandMode, retryIncorrectCards: $retryIncorrectCards)
            }
        }
        .onAppear {
            resetCards()
            allCardsCount = cards.count
        }
    }
    
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "Cards") {
            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
                cards = decoded
            }
        }
    }
    
    // Challenge 3
//    func setCardBackToStaple(at index: Int, card: Card, retryIncorrectCards: Bool) {
//        // if card is correct, just remove it
//        guard !retryIncorrectCards else {
//            removeCard(at: index)
//            return
//        }
//        guard let repositionCard = cards.first(where: { $0 == card }) else { return }
//        print("Answer repositionCard: \(repositionCard.answer)")
//        removeCard(at: index)
//
//        let randomNewPos = Int.random(in: 0..<cards.count-1)
//        cards.insert(repositionCard, at: randomNewPos)
//    }
    
    func restackCard(at index: Int) {
        guard index >= 0 else { return }

        let card = cards[index]
        cards.remove(at: index)
        cards.insert(card, at: 0)
    }
    
    func removeCard(at index: Int) {
        guard index >= 0 else { return }
        
        cards.remove(at: index)
        
        if cards.isEmpty {
            isActive = false
        }
    }
    
    func resetCards() {
//        cards = Array(repeating: Card.example, count: 10) // would also work
//        cards = Array<Card>(repeating: Card.example, count: 10)
        timeRemaining = 100
        isActive = true
        loadData()
        cards.shuffle()
        wrongCards = 0
        correctCards = 0
        allCardsCount = cards.count
    }
    
    // Challenge 3
    func index(for card: Card) -> Int {
        return cards.firstIndex(where: { $0.id == card.id }) ?? 0
    }

    // Challenge 3
    func showSheet(type: SheetType) {
        self.sheetType = type
        self.showingSheet = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
