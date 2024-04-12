//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Cyberwool on 4/11/24.
//

import SwiftUI

struct ContentView: View {
    @State private var game: Game = Game(rounds: 10)
    @State private var choiceTitle = " "
    @State private var previousChoice = true
    
    var body: some View {
        VStack {
            Spacer()
            makeHeader()
            Spacer()
            VStack {
                HStack {
                    makeButton(for: .rock)
                    makeButton(for: .paper)
                    makeButton(for: .scissors)
                }
                HStack {
                    makeButton(for: .lizard)
                    makeButton(for: .spock)
                }
            }
            Spacer()
            makeFooter()
            Spacer()
        }
    }
    
    func guess(move: Move) {
        let result = game.playRound(with: move)
        previousChoice = result
        choiceTitle = (result ? "Good choice!" : "Sorry, that's wrong.")
        if (!game.gameOver) {
            game.setUpNextRound()
        }
    }
    
    func resetGame() {
        choiceTitle = " "
        game.resetGame()
    }
    
    func makeButton(for move: Move) -> some View {
        Button {
            guess(move: move)
        } label: {
            GameMoveImage(move: move)
        }
        .disabled(game.gameOver ? true : false)
    }
    
    @ViewBuilder func makeHeader() -> some View {
        if (!game.gameOver) {
            GameMoveImage(move: game.computerMove)
            HStack(spacing: 0) {
                Text("Try to ")
                Text(game.tryToWin ? "win" : "loose")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                Text(" against ")
                Text("\(game.computerMove)")
                    .fontWeight(.bold)
                Text("!")
            }
        } else {
            VStack {
                Text("Game over!")
                    .fontWeight(.bold)
                HStack(spacing: 0) {
                    Text("Your score is ")
                    Text(String(game.score))
                        .fontWeight(.bold)
                    Text(".")
                }
            }
            .padding()
            Button("Play again?") {
                resetGame()
            }
        }
    }
    
    @ViewBuilder func makeFooter() -> some View {
        if (!game.gameOver) {
            Text(choiceTitle)
                .multilineTextAlignment(.center)
                .foregroundColor(previousChoice ? Color.green : Color.red)
        }
    }
}

struct GameMoveImage: View {
    var move: Move
    var body: some View {
        Image(move.description.lowercased())
            .resizable()
            .scaledToFit()
            .frame(height: 100)
            .padding()
    }
}

#Preview {
    ContentView()
}
