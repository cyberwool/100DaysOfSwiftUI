//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by Cyberwool on 4/9/24.
//

import SwiftUI

struct BigBlue: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundColor(.blue)
    }
}
extension View {
    func bigBlue() -> some View {
        modifier(BigBlue())
    }
}

struct ContentView: View {
    var body: some View {
        Text("Big Blue Title")
            .bigBlue()
    }
}

#Preview {
    ContentView()
}
