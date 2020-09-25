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
    @State private var didTapConvert = false
    @State private var didTapYShadow: CGFloat = 2.0
    @State private var didNotTapYShadow: CGFloat = -2.0
    @State private var refreshIconColor: Color = .green
    @State private var buttonIsSelected: Bool = false
    @State private var Label = "Hello"
    
    var unit = ["Bin", "Dec", "Hex"]
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    Text("BinDecHex").bold().fontWeight(.heavy)
                    Spacer()
                    HStack {
                        VStack {
                            Text("\(self.unit[self.unitIndex])").fontWeight(.heavy)
                            Picker(selection: self.$unitIndex, label: Text("Unit").bold()) {
                                ForEach(0..<self.unit.count) {
                                    Text(self.unit[$0])
                                }
                                
                            }.labelsHidden().pickerStyle(WheelPickerStyle())
                        }.labelsHidden().frame(maxWidth: geometry.size.width / 2)
                        
                        VStack {
                            Text("\(self.unit[self.unitIndex2])").fontWeight(.heavy)
                            Picker(selection: self.$unitIndex2, label: Text("Unit").bold()) {
                                ForEach(0..<self.unit.count) {
                                    Text(self.unit[$0])
                                }
                                
                            }.pickerStyle(DefaultPickerStyle()).labelsHidden().frame(maxWidth: geometry.size.width / 2)
                        }
                    }
                    Text("Enter Value").fontWeight(.heavy)
                    HStack {
                        TextField("0"/*@END_MENU_TOKEN@*/, text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant(""))
                            .padding(.horizontal)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Spacer()
                    }
                    Button(action: {
                    }) {
                        Text("Convert")
                            .foregroundColor(Color.black)
                            .fontWeight(.heavy)
                    }.buttonStyle(LongWidthButton())
                    Text("Result: ")
                    Spacer()
                    
                }.background(Color(UIColor.secondarySystemBackground)).edgesIgnoringSafeArea(.all).navigationBarTitle(Text("BinDecHex"), displayMode: .inline).navigationBarItems(trailing: Button(action: {
                    print("Refreshed tapped")
                    refreshIconColor = .blue
                    
                }) {
                    Image(systemName: "arrow.clockwise")
                        .foregroundColor(refreshIconColor)
                }
                )
            }
        }.onAppear {
            UINavigationBar.appearance().backgroundColor = UIColor.secondarySystemBackground
            UINavigationBar.appearance().shadowImage = UIImage()
            
        }
    }
}

struct LongWidthButton: ButtonStyle {

    @State private var buttonColor: Color = Color.yellow
    @State private var shadowFormat: CGFloat = 2.0
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(.all)
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding(.all)
            .background(configuration.isPressed ? Color.blue : Color.yellow)
            .cornerRadius(10.0)
            .padding()
            .shadow(color: .black, radius: 1.0, x: 0.0, y: configuration.isPressed ? -2.0 : 2.0)
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().previewDevice("iPhone 11 Pro")
    }
}
