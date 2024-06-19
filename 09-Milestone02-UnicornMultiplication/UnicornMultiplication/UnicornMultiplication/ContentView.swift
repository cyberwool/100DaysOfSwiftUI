//
//  ContentView.swift
//  UnicornMultiplication
//
//  Created by Cyberwool on 6/8/24.
//

import SwiftUI

struct ContentView: View {
    // Colors
    private let backgroundPink: Color = Color(red: 252/255, green: 221/255, blue: 226/255)
    private let unicornYellow: Color = Color(red: 254/255, green: 242/255, blue: 162/255)
    private let unicornBlue: Color = Color(red: 141/255, green: 179/255, blue: 210/255)
    private let unicornPink: Color = Color(red: 254/255, green: 179/255, blue: 203/255)
    
    // Game Selections
    @State private var questionsUpTo = 5.0
    @State private var questionCountOptions = ["5", "10", "15", "All"]
    @State private var questionCountSelection = 0
    
    // Gameplay
    @State private var multiplicationGame: MultiplicationGame? = nil    // Game hasn't started yet
    enum GameState { case menu, play, score }
    @State private var gameState: GameState = .menu     // Menu initially shown
    
    // Animation
    @State private var floatAmount: CGFloat = 0
    @State private var fadeAmount = [1.0, 1.0, 1.0, 1.0, 1.0]
    @State private var areAnswersTappable: Bool = true
    
    var body: some View {
        ZStack {
            Color(backgroundPink)
                .ignoresSafeArea(.all)
            
            // Show appropriate view for game state
            if gameState == .play && multiplicationGame != nil {
                playView()
            } else if gameState == .score && multiplicationGame != nil {
                scoreView()
            } else {
                menuView()
            }
        }
    }
    
    // MARK: - Views
    @ViewBuilder
    func menuView() -> some View {
        VStack {
            Spacer()
            
            Group {
                Image(.shootingStar)
                    .resizable()
                    .scaledToFit()
                    .containerRelativeFrame(.horizontal) { size, _ in size * 0.45 }
                DropshadowText("Unicorn Multiplication", color: unicornBlue)
                    .foregroundStyle(.white)
                    .frame(height: 45)
            }
            
            Spacer()
            
            Image(.blueUnicorn)
                .resizable()
                .scaledToFit()
                .containerRelativeFrame(.horizontal) { size, _ in size * 0.75 }
                .offset(y: floatAmount)
                .animation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true), value: floatAmount)
                .onAppear() {
                    floatAmount = -20
                }
                .onDisappear() {
                    floatAmount = 0
                }
            
            Spacer()
            
            Group {
                HStack {
                    Text("1")
                        .font(.footnote)
                    Slider(value: $questionsUpTo, in: 1...12, step: 1)
                        .accentColor(unicornYellow)
                    Text("12")
                        .font(.footnote)
                }
                
                Picker("How many questions?", selection: $questionCountSelection) {
                    ForEach(0..<questionCountOptions.count, id: \.self) {
                        Text(questionCountOptions[$0])
                    }
                }
                .pickerStyle(.segmented)
                .padding(.bottom)
            }
            .padding(.horizontal)
            
            themedButton(action: startGame, label: "Play Game!")
            
            Spacer()
        }
    }
    
    @ViewBuilder
    func playView() -> some View {
        VStack {
            if let nextQuestion = multiplicationGame?.nextQuestion {
                Spacer()
                
                DropshadowText("\(nextQuestion.factorOne) x \(nextQuestion.factorTwo)", color: unicornBlue)
                    .foregroundStyle(.white)
                    .padding(.top, 40)
                Group {
                    let answers = nextQuestion.possibleAnswers
                    HStack {
                        ForEach(0..<3, id: \.self) { index in
                            AnswerCloud(for: answers[index], color: unicornBlue)
                                .onTapGesture { answerQuestion(with: answers[index]) }
                                .allowsHitTesting(areAnswersTappable)
                                .opacity(fadeAmount[index])
                        }
                    }
                    HStack {
                        ForEach(3..<5, id: \.self) { index in
                            AnswerCloud(for: answers[index], color: unicornBlue)
                                .onTapGesture { answerQuestion(with: answers[index]) }
                                .allowsHitTesting(areAnswersTappable)
                                .opacity(fadeAmount[index])
                        }
                    }
                }
                
                Spacer()
                
                ZStack {
                    // Greedy - eats up space, leaves none for spacers!
                    GeometryReader { proxy in
                        let size = proxy.size
                        
                        Group {
                            Image("stars-trio")
                                .resizable()
                                .scaledToFit()
                                .containerRelativeFrame(.horizontal) { size, _ in size * 0.2 }
                                .offset(x: -(size.width * 0.35), y: -20 + floatAmount)
                            Image("stars-trio")
                                .resizable()
                                .scaledToFit()
                                .containerRelativeFrame(.horizontal) { size, _ in size * 0.2 }
                                .offset(x: (size.width * 0.35), y: 100 - floatAmount)
                        }
                        .onAppear() { floatAmount = -5 }
                        .onDisappear() { floatAmount = 0 }
                        .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: floatAmount)
                        .frame(width: size.width, height: size.height, alignment: .center)
                    }
                    
                    Image("unicorn-rainbow")
                        .resizable()
                        .scaledToFit()
                        .containerRelativeFrame(.horizontal) { size, _ in size * 0.75 }
                }
               
            } else {
                errorView()
            }
        }
    }
    
    @ViewBuilder
    func scoreView() -> some View {
        VStack {
            Spacer()
            
            Group {
                let score = multiplicationGame != nil ? multiplicationGame!.score : 0
                let message = score == 0 ? "Nice Try!" : (multiplicationGame?.numberOfQuestions == score ? "Perfect!" : "Great Job!")
                
                DropshadowText("\(message)", color: unicornBlue)
                    .foregroundStyle(.white)
                    .frame(height: 60)
                    .padding(.bottom)
                ZStack {
                    Image("cloud-gems")
                        .resizable()
                        .scaledToFit()
                        .containerRelativeFrame(.horizontal) { size, _ in size * 0.6 }
                    Text("\(score)")
                        .font(.custom("Papernotes", size: 50))
                        .foregroundStyle(unicornBlue)
                        .offset(y: -25)
                }
            }
            
            Spacer()
            
            Image("resting-unicorn")
                .resizable()
                .scaledToFit()
                .containerRelativeFrame(.horizontal) { size, _ in size * 0.75 }
                .offset(y: floatAmount)
                .onAppear() { floatAmount = -20 }
                .onDisappear() { floatAmount = 0 }
                .animation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true), value: floatAmount)
            
            Spacer()
            
            themedButton(action: restartGame, label: "Play Again?")
            
            Spacer()
        }
    }
    
    @ViewBuilder
    func errorView() -> some View {
        DropshadowText("Oh no, an error!", color: unicornBlue)
            .foregroundStyle(.white)
            .padding()
        
        themedButton(action: { multiplicationGame = nil
            gameState = .menu }, label: "Return to Menu")
    }
    
    @ViewBuilder
    func themedButton(action: @escaping () -> Void, label: String) -> some View {
        Button(action: action, label: {
            Text(label)
                .foregroundStyle(unicornBlue)
        })
        .padding(10)
        .background(.white)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.1), radius: 5)
        .padding(.top)
    }
    
    // MARK: - Gameplay
    private func startGame() {
        multiplicationGame = MultiplicationGame(numberOfQuestions: Int(questionCountOptions[questionCountSelection]), questionRange: 1...Int(questionsUpTo))
        
        gameState = .play
    }
    
    private func answerQuestion(with answer: Int) {
        if multiplicationGame == nil {
            restartGame()
            return
        }
        
        areAnswersTappable = false
        withAnimation {
            let possibleAnswers = multiplicationGame!.questions[0].possibleAnswers
            let correctAnswer = multiplicationGame!.questions[0].answer
            
            fadeAmount = [0.25, 0.25, 0.25, 0.25, 0.25]
            fadeAmount[possibleAnswers.firstIndex(of: correctAnswer)!] = 1.0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                fadeAmount = [1.0, 1.0, 1.0, 1.0, 1.0]
            }
            multiplicationGame!.guess(answer: answer)
            if multiplicationGame?.questions.count == 0 {
                gameState = .score
            }
            areAnswersTappable = true
        }
    }
    
    private func restartGame() {
        multiplicationGame = nil
        gameState = .menu
    }
}

#Preview {
    ContentView()
}
