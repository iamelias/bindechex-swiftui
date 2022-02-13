//
//  MyPicker.swift
//  BinDecHexSwiftUI
//
//  Created by Elias Hall on 2/13/22.
//  Copyright © 2022 Elias Hall. All rights reserved.
//

import SwiftUI

struct MyPicker: View {
    @Binding var selectedUnit: Int
    var units: [String]
    
    var body: some View {
        Picker("", selection: $selectedUnit, content: {
            ForEach(0..<units.count) {
                Text(units[$0])
            }
        }).pickerStyle(.wheel).labelsHidden()
    }
}

//struct MyPicker_Previews: PreviewProvider {
//    static var previews: some View {
//        MyPicker(selectedUnit:)
//    }
//}
