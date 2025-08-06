# 🃏 Swift and SwiftUI Blackjack Game

Welcome to **SwiftUI Blackjack**, a visually engaging and beginner-friendly implementation of the classic card game! This version includes game animations, auto-play dealer logic, scorekeeping, and a three-round system to determine the overall winner. Unfortuantely, Swift UI can only work on Apple devices so you need one to run the code without issues.

## 🎮 Gameplay Features

* ✅ **3-Round Blackjack**: Play up to three rounds against the dealer and see who wins overall.
* 🎴 **Card Logic**: Includes all standard cards — from 2 through 10, face cards (King, Queen, Joker = 10), and Aces (= 11).
* 🔄 **Auto-Play Dealer**: Toggle automatic dealer turns.
* 💥 **Bust Detection**: Game detects when the player or dealer exceeds 21 and updates scores accordingly.
* 🧠 **Turn-Based Logic**: Player plays first, then the dealer. You can `Hit` or `Stand`.
* 🧮 **Score Comparison**: Winner is calculated based on standard Blackjack rules.
* 🎨 **Custom Checkered Background**: Stylish red and black game grid background.
* 🎬 **Animated Welcome Screen**: Card suits bounce into view when the app launches.

## 🛠 How It Works

Here is a video showing the gameplay: 

### Main Components

* **`ContentView`**: Shows animated welcome screen with a “Start Game” button.
* **`CheckeredBackground`**: Generates the visual grid using a `LazyVGrid`.
* **`GameView`**: The core gameplay interface, including game logic, turn management, and UI.
* **`FinalResultView`**: Displays who won after 3 rounds and offers a “Play Again” option.

### Key Logic

* **Card Values**:

  * Number cards: Value is the number.
  * `King`, `Queen`, `Joker`: Value = 10.
  * `Ace`: Value = 11 (no dual-value logic yet).
* **Round Progression**:

  * Each round ends when both turns are over.
  * Scores reset between rounds.
  * After round 3, a final result screen appears.
* **Player & Dealer Turns**:

  * Player hits or stands.
  * Dealer hits until score ≥ 17 or busts.
* **Animations**:

  * Card suits animate on the intro screen.
  * Transitions between turns are delayed slightly for UX polish.

## 🧪 How to Run

1. Open the project in **Xcode** (supports SwiftUI).
2. Run on a simulator or device.
3. Tap **Start Game** to begin playing!

## 📝 Customization Ideas

Here are a few ways to build on the game:

* ♠️ Add actual card images or suits to enhance visuals.
* ♣️ Implement smarter Ace logic (1 or 11).
* ♥️ Introduce chip betting and player funds.
* ♦️ Add sound effects and card dealing animations.

## 🔄 Game Controls

| Action          | Control                 |
| --------------- | ----------------------- |
| Hit             | Tap the `Hit` button    |
| Stand           | Tap the `Stand` button  |
| Dealer AutoPlay | Toggle switch on screen |
| Play Again      | Appears after 3 rounds  |

## 📂 File Structure

```bash
📁 SwiftUIBlackjack/
├── ContentView.swift        # Welcome screen and transition to game
├── CheckeredBackground.swift # Custom red/black checkerboard
├── GameView.swift           # Game logic, turn control, and scoring
├── FinalResultView.swift    # Displays outcome after 3 rounds
├── README.md                # You're here!
```

---

## 👨‍💻 Credits

Developed by Chimbusonma Ike-Nwodo. Feel free to reach out on [LinkedIn](https://www.linkedin.com/in/chimbusonma-ike-nwodo/)
