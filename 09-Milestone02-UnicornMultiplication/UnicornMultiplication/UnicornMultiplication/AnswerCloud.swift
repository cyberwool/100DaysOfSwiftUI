//
//  AnswerCloud.swift
//  UnicornMultiplication
//
//  Created by Cyberwool on 6/15/24.
//

import SwiftUI

struct AnswerCloud: View {
    private let answer: Int
    private let color: Color
    
    init(for answer: Int, color: Color) {
        self.answer = answer
        self.color = color
    }
    
    var body: some View {
        ZStack {
            Image("cloud-\(Int.random(in: 1...3))")
                .resizable()
                .scaledToFit()
                .containerRelativeFrame(.horizontal) { size, _ in size * 0.3 }
            Text("\(answer)")
                .font(.custom("Papernotes", size: 28))
                .foregroundStyle(color)
        }
    }
}

#Preview {
    ZStack {
        Color(Color(red: 252/255, green: 221/255, blue: 226/255))
        AnswerCloud(for: 42, color: Color(red: 141/255, green: 179/255, blue: 210/255))
    }
    
}
