//
//  ContentView.swift
//  BetterRest
//
//  Created by Cyberwool on 4/12/24.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }
    
    // Challenge 3
    private var sleepTime: Date? {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60     // seconds
            let minute = (components.minute ?? 0) * 60      // seconds
            
            let prediction = try model.prediction(wake: Int64(hour + minute), estimatedSleep: sleepAmount, coffee: Int64(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
            
            return sleepTime
        } catch {
            // Something went wrong
            return nil
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                // Challenge 1
                Section("When do you want to wake up?") {
                    DatePicker("Enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .datePickerStyle(.wheel)
                }
                
                Section("How long do you want to sleep?") {
                    HStack {
                        Image(systemName: "clock")
                        Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                    }
                }
                 
                Section("How much coffee do you drink?") {
                    HStack {
                        Image(systemName: "mug")
                        // Challenge 2
                        Picker("^[\(coffeeAmount) cup](inflect: true)", selection: $coffeeAmount) {
                            ForEach(1...20, id: \.self) {
                                Text("^[\($0) cup](inflect: true)")
                            }
                        }
                    }
                }
                
                // Challenge 3
                Section("Your ideal bedtime is...") {
                    Text(sleepTime?.formatted(date: .omitted, time: .shortened) ?? "Unknown")
                        .font(.largeTitle)
                }
            }
            .navigationTitle("BetterRest")
        }
    }
}

#Preview {
    ContentView()
}
