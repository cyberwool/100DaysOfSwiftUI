//
//  Game.swift
//  RockPaperScissors
//
//  Created by Cyberwool on 4/11/24.
//

import Foundation

struct Game {
    private var roundsInGame: Int
    
    private(set) var computerMove: Move = Move.allCases.randomElement()!
    private(set) var tryToWin: Bool = true
    var score: Int {
        // I don't like negative scores
        max(gameScore, 0)
    }
    private var gameScore = 0
    private var roundsLeft: Int
    var gameOver: Bool {
        return roundsLeft < 1
    }
    
    init(rounds: Int) {
        roundsInGame = rounds
        roundsLeft = rounds
    }
    

    mutating func resetGame() {
        computerMove = Move.allCases.randomElement()!
        tryToWin = true
        gameScore = 0
        roundsLeft = roundsInGame
    }
    
    // Plays the round and returns true/false for win status
    mutating func playRound(with playerMove: Move) -> Bool {
        // True if both true or both false
        let playerWins = (tryToWin == playerMove.winsAgainst(computerMove))
        gameScore += playerWins ? 1 : -1
        roundsLeft -= 1
        
        return playerWins
    }
    
    mutating func setUpNextRound() {
        if (!gameOver) {
            computerMove = Move.allCases.randomElement()!
            tryToWin.toggle()
        }
    }
}

enum Move: CustomStringConvertible, CaseIterable {
    case rock, paper, scissors, lizard, spock
    
    var description: String {
        switch self {
        case .rock: return "rock"
        case .paper: return "paper"
        case .scissors: return "scissors"
        case .lizard: return "lizard"
        case .spock: return "Spock"
        }
    }
}
extension Move {
    private var winsAgainst: [Move] {
        switch self {
        case .rock: return [.scissors, .lizard]
        case .paper: return [.rock, .spock]
        case .scissors: return [.paper, .lizard]
        case .lizard: return [.paper, .spock]
        case .spock: return [.scissors, .rock]
        }
    }
    
    func winsAgainst(_ opponent: Move) -> Bool {
        return self.winsAgainst.contains(opponent)
    }
}
