//
//  ContentView.swift
//  BinDecHexSwiftUI
//
//  Created by Elias Hall on 7/28/20.
//  Copyright © 2020 Elias Hall. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State private var unitIndex = 0
    @State private var unitIndex2 = 0
    
    var unit = ["Bin", "Dec", "Hex"]

    var body: some View {
        HStack {
        VStack {
            Picker(selection: $unitIndex, label: Text("Unit").bold()) {
                ForEach(0..<unit.count) {
                    Text(self.unit[$0])
                }
                
            }.labelsHidden()
            Text("You selected: \(unit[unitIndex])")
        }
            VStack {
                Picker(selection: $unitIndex2, label: Text("Unit").bold()) {
                    ForEach(0..<unit.count) {
                        Text(self.unit[$0])
                    }
                    
                }.labelsHidden()
                Text("You selected: \(unit[unitIndex2])")
            }
    }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
