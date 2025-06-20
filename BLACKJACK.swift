import SwiftUI

// Entry point view that shows welcome screen and launches the game
struct ContentView: View {
    @State private var showGameScreen = false
    @State private var animateCards = false

    var body: some View {
        if showGameScreen {
            GameView()
        } else {
            ZStack {
                CheckeredBackground() // Custom background
                VStack(spacing: 20) {
                    Text("WELCOME TO BLACKJACK!")
                        .font(.largeTitle)
                        .padding()
                        .foregroundStyle(.white)
                        .bold()

                    // Suits with animation
                    HStack(spacing: 10) {
                        ForEach(["♠️", "♥️", "♣️", "♦️"], id: \.self) { symbol in
                            Text(symbol)
                                .font(.system(size: 70))
                                .scaleEffect(animateCards ? 1.2 : 0.7)
                                .opacity(animateCards ? 1 : 0)
                                .animation(.easeInOut(duration: 1).delay(Double.random(in: 0...0.5)), value: animateCards)
                        }
                    }

                    // Button to start the game
                    Button("Start Game") {
                        showGameScreen = true
                    }
                    .font(.title)
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(80)
                }

                .onAppear {
                    animateCards = true
                }
            }
        }
    }
}

// Checkered red and black background design
struct CheckeredBackground: View {
    let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 10)

    var body: some View {
        GeometryReader { geometry in
            let boxSize = geometry.size.width / 10
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(0..<300, id: \.self) { index in
                    Rectangle()
                        .fill((index / 10 + index % 10) % 2 == 0 ? Color.red : Color.black.opacity(0.7))
                        .frame(height: boxSize)
                        .cornerRadius(3)
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}

// Main game view with logic for score keeping, player/dealer turns, and results
struct GameView: View {
    @State var scores: [String] = ["King", "Queen", "Joker", "Ace", "2", "3", "4", "5", "6", "7", "8","9","10"]
    @State private var playerCards: [String] = []
    @State private var dealerCards: [String] = []
    @State private var playerScore = 0 
    @State private var dealerScore = 0
    @State private var playersTurn = true
    @State private var dealersTurn = false
    @State var gameStarted = false
    @State private var playerWins = 0
    @State private var dealerWins = 0
    @State private var round = 1
    @State private var showFinalResult = false
    @State private var card = ""
    @State private var autoPlay = false
    @State private var isWaiting = false

    // Start each round by setting 2 cards each for player and dealer
    func setDefaultCards() {
        playerCards = []
        dealerCards = []
        playerScore = 0 
        dealerScore = 0

        for _ in 0..<2 {
            if let pickedCard = scores.randomElement() {
                playerCards.append(pickedCard)
                playerScore += getCardValue(pickedCard)
            }
            if let pickedCard = scores.randomElement() {
                dealerCards.append(pickedCard)
                dealerScore += getCardValue(pickedCard)
            }
        }
    }

    // Assign card values based on type
    func getCardValue(_ card: String) -> Int {
        if let number = Int(card) {
            return number
        } else if ["King", "Queen", "Joker"].contains(card) {
            return 10
        } else if card == "Ace" {
            return 11
        } else {
            return 0
        }
    }

    // Ends current round and optionally starts new round or final result
    func endRound(_ winner: String) {
        // Prevent double counting
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if winner == "player" {
                playerWins += 1
            } else if winner == "dealer" {
                dealerWins += 1
            }
            if round == 3 {
                showFinalResult = true
            } else {
                round += 1
                setDefaultCards()
                playersTurn = true
                dealersTurn = false
            }
        }
    }

    // Reset the entire game to Round 1
    func resetGame() {
        setDefaultCards()
        playerWins = 0
        dealerWins = 0
        round = 1
        playersTurn = true
        dealersTurn = false
        showFinalResult = false
    }

    // Auto transition if player score >= 21
    func checkPlayerScore() {
        if playerScore >= 21 {
            isWaiting = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                playersTurn = false
                dealersTurn = true
                isWaiting = false
            }
        }
    } 

    // Auto stop dealer if score >= 17
    func checkDealerScore() {
        if dealerScore >= 17 {
            isWaiting = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                dealersTurn = false
                isWaiting = false
            }
        }
    } 

    // Recursive dealer play logic for auto-play
    func dealerAutoPlay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if dealersTurn && dealerScore < 17 {
                if let pickedCard = scores.randomElement() {
                    card = pickedCard
                    dealerScore += getCardValue(card)
                    dealerAutoPlay()
                }
            } else {
                dealersTurn = false
            }
        }
    }

    var body: some View {
        if showFinalResult {
            FinalResultView(
                playerWins: playerWins, 
                dealerWins: dealerWins,       
                onPlayAgain: {resetGame()}
            )
        } else {
            ZStack {
                CheckeredBackground()
                Color.black.opacity(0.3) // dimming overlay
                VStack(alignment: .center, spacing: 20) {
                    // Toggle for enabling/disabling dealer autoplay
                    Toggle("Dealer Auto Play", isOn: $autoPlay)
                        .foregroundStyle(.white)
                        .bold()
                    Divider()

                    // Scores
                    HStack {
                        if playersTurn {
                            Text("Player: \(playerScore)")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading)
                        }

                        if dealersTurn {
                            Text("Dealer: \(dealerScore)")
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .padding(.trailing)
                        }
                    }
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                    
                    // Outcome messages
                    if !playersTurn && !dealersTurn {
                        if playerScore > 21 {
                            Text("Player busts! Dealer wins!")
                                .onAppear { endRound("dealer") }
                                .font(.title2)
                                .foregroundColor(.white)
                                .bold()
                        } else if dealerScore > 21 {
                            Text("Dealer busts! Player wins!!!")
                                .onAppear { endRound("player") }
                                .font(.title2)
                                .foregroundColor(.white)
                                .bold()
                        } else if playerScore > dealerScore {
                            Text("Player wins!!!")
                                .onAppear { endRound("player") }
                                .font(.title2)
                                .foregroundColor(.white)
                                .bold()
                        } else if dealerScore > playerScore {
                            Text("Dealer wins!!!")
                                .onAppear { endRound("dealer") }
                                .font(.title2)
                                .foregroundColor(.white)
                                .bold()
                        } else {
                            Text("It's a push (tie)!")
                                .onAppear { endRound("tie") }
                                .font(.title2)
                                .foregroundColor(.white)
                                .bold()
                        }
                    } else if playersTurn {
                        Text("Player's Turn")
                            .font(.title2)
                            .foregroundColor(.white)
                            .bold()
                        if isWaiting {
                            Text("Calculating player's result...")
                                .foregroundColor(.white)
                                .italic()
                        }
                    } else if dealersTurn {
                        Text("Dealer's Turn")
                            .font(.title2)
                            .foregroundColor(.white)
                            .bold()
                        if isWaiting {
                            Text("Calculating dealer's result...")
                                .foregroundColor(.white)
                                .italic()
                        }
                    }
                    
                    Spacer().frame(height: 60)

                    // Display who is playing and last drawn card
                    HStack(spacing: 50) {
                        Text("PLAYER")
                        VStack {
                            Text("\(card)")
                        }
                        Text("DEALER")
                    }
                    .bold()
                    .padding()
                    .background(Color.white.opacity(0.5))
                    .cornerRadius(10)
                    .font(.title2)
                    
                    // Game action buttons
                    HStack {
                        Button("Hit", systemImage: "h.circle.fill") {
                            if playersTurn {
                                if let pickedCard = scores.randomElement() {
                                    card = pickedCard
                                    playerScore += getCardValue(card)
                                }
                            } else if dealersTurn && !autoPlay {
                                if let pickedCard = scores.randomElement() {
                                    card = pickedCard
                                    dealerScore += getCardValue(card)
                                }
                            }
                        }
                        .disabled(!playersTurn && !dealersTurn)
                        .labelStyle(.iconOnly)
                        .font(.largeTitle)
                        .tint(.white)
                        
                        Button("Stand", systemImage: "s.circle.fill") {
                            if playersTurn {
                                playersTurn = false
                                dealersTurn = true
                            } else {
                                dealersTurn = false
                            }
                        }
                        .disabled(!playersTurn && !dealersTurn)
                        .labelStyle(.iconOnly)
                        .font(.largeTitle)
                        .tint(.red)
                    }
                }

                // Triggers when game screen appears
                .onAppear {
                    if !gameStarted {
                        setDefaultCards()
                        gameStarted = true
                    }
                }

                // Auto-play trigger
                .onChange(of: dealersTurn) { newValue in
                    if newValue && autoPlay {
                        dealerAutoPlay()
                    }
                }

                // Monitors scores for logic transitions
                .onChange(of: playerScore) { _ in checkPlayerScore() }
                .onChange(of: dealerScore) { _ in checkDealerScore() }

                // Round label
                Text("🕹️ Round \(round) of 3")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.top)
            }
        }
    }
}

// View to display game results after 3 rounds
struct FinalResultView: View {
    let playerWins: Int
    let dealerWins: Int
    let onPlayAgain: () -> Void

    var body: some View {
        ZStack {
            CheckeredBackground()
            VStack(spacing: 20) {
                Text("🏁 Game Over 🏁")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)

                Text("Player Wins: \(playerWins)")
                    .font(.title2)
                    .foregroundColor(.white)
                    .bold()

                Text("Dealer Wins: \(dealerWins)")
                    .font(.title2)
                    .foregroundColor(.white)
                    .bold()

                if playerWins > dealerWins {
                    Text("🎉 Player is the overall winner!")
                        .font(.title2)
                        .foregroundColor(.white)
                        .bold()
                } else if dealerWins > playerWins {
                    Text("💀 Dealer is the overall winner!")
                        .font(.title2)
                        .foregroundColor(.white)
                        .bold()
                } else {
                    Text("🤝 It's a tie!")
                        .font(.title2)
                        .foregroundColor(.white)
                        .bold()
                }

                Button("🔁 Play Again") {
                    onPlayAgain()
                }
                .font(.title2)
                .padding()
                .background(Color.black)
                .foregroundColor(.white)
                .cornerRadius(80)
                .shadow(radius: 10)
            }
            .bold()
            .font(.title2)
            .foregroundColor(.white)
            .padding()
        }
    }
}