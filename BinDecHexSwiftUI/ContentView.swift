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
        NavigationView {
        GeometryReader { geometry in
            VStack {
                Text("BinDecHex").bold()
                Spacer()
                HStack {
                    VStack {
                        Text("\(self.unit[self.unitIndex])")
                        Picker(selection: self.$unitIndex, label: Text("Unit").bold()) {
                            ForEach(0..<self.unit.count) {
                                Text(self.unit[$0])
                            }
                            
                        }.labelsHidden()
                    }.labelsHidden().frame(maxWidth: geometry.size.width / 2)
                    
                    VStack {
                        Text("\(self.unit[self.unitIndex2])")
                        Picker(selection: self.$unitIndex2, label: Text("Unit").bold()) {
                            ForEach(0..<self.unit.count) {
                                Text(self.unit[$0])
                            }
                            
                        }.pickerStyle(DefaultPickerStyle()).labelsHidden().frame(maxWidth: geometry.size.width / 2)
                    }
                }
                HStack {
                    TextField("0"/*@END_MENU_TOKEN@*/, text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant(""))
                        .padding(.horizontal)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Spacer()
                }
                Button(action: {
                    print("Convert button tapped")
                }) {
                    Text("Convert").foregroundColor(Color.black).fontWeight(.heavy).background(Image("YunselectedButton2"))
                    
                }
                Text("Result: ")
                Spacer()
            }.background(Color(UIColor.secondarySystemBackground)).edgesIgnoringSafeArea(.all).navigationBarTitle(Text("BinDecHex"), displayMode: .inline)
        }
        }.onAppear {
            UINavigationBar.appearance().backgroundColor = UIColor.secondarySystemBackground
            UINavigationBar.appearance().shadowImage = UIImage()
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().previewDevice("iPhone 11 Pro")
    }
}
