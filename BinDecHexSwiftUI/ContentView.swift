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
        GeometryReader { geometry in
            VStack {
                Text("BinDecHex")
                Spacer()
        HStack {
        VStack {
            Text("You selected: \(self.unit[self.unitIndex])")
            Picker(selection: self.$unitIndex, label: Text("Unit").bold()) {
                ForEach(0..<self.unit.count) {
                    Text(self.unit[$0])
                }
                
                }.labelsHidden()
            }.labelsHidden().frame(maxWidth: geometry.size.width / 2)
            VStack {
                Text("You selected: \(self.unit[self.unitIndex2])")
                Picker(selection: self.$unitIndex2, label: Text("Unit").bold()) {
                    ForEach(0..<self.unit.count) {
                        Text(self.unit[$0])
                    }
                    
                    }.labelsHidden().frame(maxWidth: geometry.size.width / 2)
            }
        }
                Spacer()
            }
    }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
