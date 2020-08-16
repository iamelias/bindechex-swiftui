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
        HStack {
        VStack {
            Picker(selection: self.$unitIndex, label: Text("Unit").bold()) {
                ForEach(0..<self.unit.count) {
                    Text(self.unit[$0])
                }
                
                }.labelsHidden()
            Text("You selected: \(self.unit[self.unitIndex])")
            }.labelsHidden().frame(maxWidth: geometry.size.width / 2)
            VStack {
                Picker(selection: self.$unitIndex2, label: Text("Unit").bold()) {
                    ForEach(0..<self.unit.count) {
                        Text(self.unit[$0])
                    }
                    
                    }.labelsHidden().frame(maxWidth: geometry.size.width / 2)
                Text("You selected: \(self.unit[self.unitIndex2])")
            }
        }
    }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
