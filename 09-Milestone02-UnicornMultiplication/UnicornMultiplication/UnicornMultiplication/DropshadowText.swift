//
//  DropshadowText.swift
//  UnicornMultiplication
//
//  Created by Cyberwool on 6/15/24.
//

import SwiftUI

struct DropshadowText: View {
    private let text: String
    private let dropshadowColor: Color
    
    init(_ text: String, color: Color) {
        self.text = text
        self.dropshadowColor = color
    }
    
    var body: some View {
        ZStack {
            Text(text)
                .font(.custom("Papernotes", size: 100))
                .foregroundColor(dropshadowColor)
                .minimumScaleFactor(0.01)
                .lineLimit(1)
                .offset(x: 2, y: 2)
                .containerRelativeFrame(.horizontal) { size, _ in size * 0.9 }
            Text(text)
                .font(.custom("Papernotes", size: 100))
                .minimumScaleFactor(0.01)
                .lineLimit(1)
                .containerRelativeFrame(.horizontal) { size, _ in size * 0.9 }
        }
    }
}

#Preview {
    ZStack {
        Color(Color(red: 252/255, green: 221/255, blue: 226/255))
        DropshadowText("Hello, world!", color: Color(red: 141/255, green: 179/255, blue: 210/255))
            .foregroundColor(.white)
    }
}
