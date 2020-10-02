//
//  ContentView.swift
//  BinDecHexSwiftUI
//
//  Created by Elias Hall on 7/28/20.
//  Copyright © 2020 Elias Hall. All rights reserved.
//

import SwiftUI



struct ContentView: View {
    
    @State private var unitIndex = 0 //first picker's unit
    @State private var unitIndex2 = 0 //secon picker's unit
    @State private var textName = "" //input TextField
    var unit = ["Bin", "Dec", "Hex"]

    //Check Format Methods
    func padBinary(binary: String) -> String {
        var binary = binary
        
        while binary.count < 8 {
            binary = "0\(binary)"
        }
        return binary
    }
    
    func hapticError() {
    }
    
    func checkBinary(binary: String) -> Bool {
        if binary == "" {
            //call alert
            return false
        }
        for c in binary {
            if c != "0" && c != "1" {
                //call alert
                return false
            }
        }
        return true
    }
    
    func checkDecimal(decimal: String) -> Bool {
        let checkNum = Int(decimal) //convert passed string to int, won't convert nonint
        if checkNum != nil { //if doesn't convert
            
            if checkNum! < 0 {
                //call error alert
                return false
            }
            
            guard checkNum! < 1000000000 else { //making an upperlimit to users capability
                //call error alert
                return false
            }
            return true //it is a valid int/decimal
        }
        else {
            //call error alert
            return false
        }
    }
    
    func checkHexadecimal() -> String {
        let hex = textName
        
        if hex == "" {
            return "error"
        }
        
        if hex.count > 7 {
            return "error2"
        }
        let checkHex = hex.map { $0.isHexDigit}
        
        for i in 0..<checkHex.count{
            if checkHex[i] == false {
                return "error"
            }
        }
        return hex
    }
    
    //Obtain/Handle Methods
    
    func getBinary() -> String {
        let bin = textName
        let checkSyntax = checkBinary(binary: bin)
        
        guard checkSyntax == true else {
            return "error"
        }
        return bin
    }
    
    func getDecimal() -> String {
        let dec = textName
        
        let checkSyntax = checkDecimal(decimal: dec)
        guard checkSyntax == true else {
            return "error"
        }
        return dec
        
    }
    
    func getHexadecimal() -> String {
        let hex = textName
        
        if hex == "" {
            return "error"
        }
        
        if hex.count > 7 {
            return "error2"
        }
        let checkHex = hex.map { $0.isHexDigit}
        
        for i in 0..<checkHex.count{
            if checkHex[i] == false {
                return "error"
            }
        }
        return hex
    }
    
    
    //Convert Methods
    func binToBin() {
        
    }
    func binToDec() {
        let dec = Int("Int", radix: 2)
    }
    func binToHex() {
        let bin = self.getBinary()
        guard bin != "error" else{
            return
        }
        let hex = String(Int(bin, radix: 2)!, radix: 16) //Convert Binary to Hex
        //saveCore(hex.uppercased())
        //displayResultView("Hexadecimal:",hex.uppercased())
    }
    func decToDec() {
        
    }
    func decToBin() {
        let retrievedDec = getDecimal()
        guard retrievedDec != "error" else {
            return
        }
        let bin = Int(retrievedDec)
        var binary = String(bin!, radix: 2) //converting from string to binary
        
        binary = padBinary(binary: binary) //padding to the left with 0 until num of binary digits = 8
        
       // saveCore(binary)
        //displayResultView("Binary:",binary)
    }
    func decToHex() {
        let retrievedDec = getDecimal()
        guard retrievedDec != "error" else {
            return
        }
        let dec = Int(retrievedDec)
        let hex = String(dec!, radix: 16)
//        saveCore(hex.uppercased())
//        displayResultView("Hexadecimal:",hex.uppercased())
    }
    func hexToHex() {
        
    }
    func hexToBin() {
        var bin = String(Int("F", radix: 16)!, radix: 2)
    }
    func hexToDec() {
        let hex = checkHexadecimal()
        guard hex != "error" else{
            //call error alert
            return
        }
        guard hex != "error2" else {
            //call error alert
            return
        }
        let dec = Int(hex, radix: 16)!
        let stringDec = "\(dec)"
//        saveCore(stringDec)
//        displayResultView("Decimal:",stringDec)
    }
    
    func padNumber() { //Creating an 8 bit digit for decimal
        
    }
    
    //Alert Methods
    
    func displayErrorMessage() {
        
    }
    
    
    //CoreData Methods
    func saveToCoreData() {
        
    }

    //Padding Method

    
    
    //UI
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    Text("BinDecHex").bold().fontWeight(.heavy)
                    Spacer()
                    HStack {
                        Spacer()
                        Text("\(self.unit[self.unitIndex])").fontWeight(.heavy)
                        Spacer()
                        Image(systemName: "arrow.right")
                        Spacer()
                        Text("\(self.unit[self.unitIndex2])").fontWeight(.heavy)
                        Spacer()
                    }
                    HStack {
                        VStack {
                            Picker(selection: self.$unitIndex, label: Text("Unit").bold()) {
                                ForEach(0..<self.unit.count) {
                                    Text(self.unit[$0])
                                }
                                
                            }.labelsHidden().pickerStyle(WheelPickerStyle())
                        }.labelsHidden().frame(maxWidth: geometry.size.width / 2)
                        
                        VStack {
                            
                            Picker(selection: self.$unitIndex2, label: Text("Unit").bold()) {
                                ForEach(0..<self.unit.count) {
                                    Text(self.unit[$0])
                                }
                                
                            }.pickerStyle(DefaultPickerStyle()).labelsHidden().frame(maxWidth: geometry.size.width / 2)
                        }
                    }
                    Text("Enter Value").fontWeight(.heavy)
                    HStack {
                        TextField("0", text: $textName)
                            .padding(.horizontal)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .modifier(Keyboard())
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
                }) {
                    Image(systemName: "arrow.clockwise")
                }.buttonStyle(RefreshButton())
                )
            }
        }.onAppear {
            UINavigationBar.appearance().backgroundColor = UIColor.secondarySystemBackground
            UINavigationBar.appearance().shadowImage = UIImage()
            
        }
    }
    


struct LongWidthButton: ButtonStyle {
    
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

struct RefreshButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .cornerRadius(10)
            .foregroundColor(configuration.isPressed ? Color.yellow : Color.green)
            .padding(.all)
            .background(configuration.isPressed ? Color.blue : Color.clear)
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().previewDevice("iPhone 11 Pro")
    }
}
}
