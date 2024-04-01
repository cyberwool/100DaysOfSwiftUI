//
//  ContentView.swift
//  UnitConverter
//
//  Created by Cyberwool on 3/31/24.
//

import SwiftUI

struct ContentView: View {
    @State private var inputNumber: Double = 0
    @State private var inputUnit: Dimension = UnitTemperature.celsius
    @State private var outputUnit: Dimension = UnitTemperature.fahrenheit
    @State private var conversionSelection = 0
    
    @FocusState private var inputIsFocused: Bool
    
    private let conversions = ["Temperature", "Length", "Time", "Volume"]
    private let units: [[Dimension]] = [
        [UnitTemperature.celsius, UnitTemperature.fahrenheit, UnitTemperature.kelvin],
        [UnitLength.meters, UnitLength.kilometers, UnitLength.feet, UnitLength.yards, UnitLength.miles],
        [UnitDuration.seconds, UnitDuration.minutes, UnitDuration.hours],
        [UnitVolume.milliliters, UnitVolume.liters, UnitVolume.cups, UnitVolume.pints, UnitVolume.gallons]
    ]
    
    var convertedOutput: String {
        let inputMeasurement = Measurement(value: inputNumber, unit: inputUnit)
        return inputMeasurement.converted(to: outputUnit).formatted()
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Conversion", selection: $conversionSelection) {
                        ForEach(conversions.indices, id: \.self) { index in
                            Text(conversions[index])
                        }
                    }
                    .onChange(of: conversionSelection) {
                        inputUnit = units[conversionSelection][0]
                        outputUnit = units[conversionSelection][1]
                    }
                }
                
                Section("Convert") {
                    TextField("Number to convert", value: $inputNumber, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($inputIsFocused)
                    Picker("Unit from", selection: $inputUnit) {
                        ForEach(units[conversionSelection], id: \.self) {
                            Text($0.symbol)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("To") {
                    Picker("Unit to", selection: $outputUnit) {
                        ForEach(units[conversionSelection], id: \.self) {
                            Text($0.symbol)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Result") {
                    Text(convertedOutput)
                }
            }
            .navigationTitle("Unit Converter")
            .toolbar {
                if inputIsFocused {
                    Button("Done") {
                        inputIsFocused = false
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
