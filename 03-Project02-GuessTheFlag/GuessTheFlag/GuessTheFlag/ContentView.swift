//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Cyberwool on 4/5/24.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Monaco", "Nigeria", "Poland", "Russia", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingGameOver = false
    @State private var showingScore = false
    @State private var scoreTitle = ""
    
    // Challenge 1
    @State private var score = 0
    // Challenge 3
    @State private var roundsCompleted = 0
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .clipShape(.capsule)
                                .shadow(radius: 5)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                // Challenge 1
                Text("Score: \(score)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            // Challenge 1
            Text("Your score is \(score).")
        }
        // Challenge 3
        .alert("Game Over!", isPresented: $showingGameOver) {
            Button("Restart Game", action: restartGame)
        } message: {
            Text((score == 40 ? "Perfect! " : "") + "Your final score is \(score).")
        }
    }
    
    func flagTapped(_ number: Int) {
        if (number == correctAnswer) {
            scoreTitle = "Correct!"
            // Challenge 1
            score += 5
        } else {
            // Challenge 2
            scoreTitle = "Wrong, that's the flag of \(countries[number])!"
            // Challenge 1
            score -= 5
        }
        showingScore = true
    }
    
    func askQuestion() {
        // Challenge 3
        roundsCompleted += 1
        if (roundsCompleted == 8) {
            showingGameOver = true
            // So a shuffle doesn't happen and show up in the background if it's game over.
            return
        }
        
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    // Challenge 3
    func restartGame() {
        askQuestion()
        score = 0
        roundsCompleted = 0
    }
}

#Preview {
    ContentView()
}
