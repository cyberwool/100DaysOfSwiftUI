//
//  ContentView.swift
//  Animations
//
//  Created by Cyberwool on 4/22/24.
//

import SwiftUI

struct ContentView: View {
//    @State private var animationAmount = 0.0
    @State private var dragAmount = CGSize.zero
    let letters = Array("Hello SwiftUI")
    @State private var enabled = false

    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<letters.count, id: \.self) { index in
                    Text(String(letters[index]))
                    .padding(5)
                    .font(.title)
                    .background(enabled ? .blue : .red)
                    .offset(dragAmount)
                    .animation(.linear.delay(Double(index) / 20), value: dragAmount)
            }
        }
        .gesture(
            DragGesture()
                .onChanged { amount in dragAmount = amount.translation }
                .onEnded { _ in
                    dragAmount = .zero
                    enabled.toggle()
                }
        )
        
//        LinearGradient(colors: [.pink, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
//            .frame(width: 200, height: 200)
//            .clipShape(.rect(cornerRadius: 20))
//            .offset(dragAmount)
//            .gesture(
//                DragGesture()
//                    .onChanged { amount in dragAmount = amount.translation }
//                    .onEnded { _ in
//                        withAnimation(.bouncy) {
//                            dragAmount = .zero
//                        }
//                    }
//            )
        
//        Button("Tap Me") {
//            withAnimation(.spring(duration: 1, bounce: 0.5)) {
//                animationAmount += 360
//            }
//        }
//        .padding(40)
//        .background(.red)
//        .foregroundColor(.white)
//        .clipShape(.circle)
//        .rotation3DEffect(.degrees(animationAmount), axis: (x: 0, y: 1, z: 0))
        
//        print(animationAmount)
//        
//        return VStack {
//            Stepper("Animation amount", value: $animationAmount.animation(.easeInOut(duration: 1).repeatCount(3, autoreverses: true)), in: 1...10)
//
//            Spacer()
//            
//            Button("Tap Me") {
//                animationAmount += 1
//            }
//            .padding(40)
//            .background(.red)
//            .foregroundStyle(.white)
//            .clipShape(.circle)
//            .scaleEffect(animationAmount)
//        }
        
//        Button("Tap Me") {
////            animationAmount += 1
//        }
//        .padding(50)
//        .background(.red)
//        .foregroundColor(.white)
//        .clipShape(.circle)
////        .scaleEffect(animationAmount)
////        .blur(radius: (animationAmount - 1) * 3)
//        .overlay(
//            Circle()
//                .stroke(.red)
//                .scaleEffect(animationAmount)
//                .opacity(2 - animationAmount)
//                .animation(
//                    .easeOut(duration: 1)
//                        .repeatForever(autoreverses: false),
//                    value: animationAmount
//                )
//        )
//        .onAppear {
//            animationAmount = 2
//        }
    }
}

#Preview {
    ContentView()
}
