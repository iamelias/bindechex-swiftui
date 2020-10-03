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
    @State private var result = "" //Result Text
    @State private var showAlert = false
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
            displayErrorMessage(message: ("Error", "Wrong format", "OK"))
            return false
        }
        for c in binary {
            if c != "0" && c != "1" {
                displayErrorMessage(message: ("Error", "Wrong format", "OK"))
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
                displayErrorMessage(message: ("Error", "Wrong format", "OK"))
                return false
            }
            return true //it is a valid int/decimal
        }
        else {
            displayErrorMessage(message: ("Error", "Wrong format", "OK"))
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
    func binToBin() {//********************
        var bin = getBinary()
        
        guard bin != "error" else{
            return
        }
        
        bin = padBinary(binary: bin)
        displayResult(converted: ("Binary", bin))
        
//        saveCore(bin)
//        displayResultView("Binary:",bin)
    }
    func binToDec() {//*******************
        let bin = getBinary()
        guard bin != "error" else{ return}
        
        if let dec = Int(textName, radix: 2) {
            let stringDec = "\(dec)"
            displayResult(converted: ("Decimal", stringDec))
//            saveCore(stringDec)
//            displayResultView("Decimal:",stringDec)
        }
    }
    func binToHex() {//**********************
        let bin = self.getBinary()
        guard bin != "error" else{
            return
        }
        let hex = String(Int(bin, radix: 2)!, radix: 16)//Convert Binary to Hex
        displayResult(converted: ("Hexadecimal", hex.uppercased()))
        //saveCore(hex.uppercased())
    }
    func decToDec() {//**********************
        let dec = getDecimal()
        guard dec != "error" else {
            return
        }
        displayResult(converted: ("Decimal", dec))

//        saveCore(dec)
//        displayResultView("Decimal:", dec)
    }
    func decToBin() {//*****************
        let retrievedDec = getDecimal()
        guard retrievedDec != "error" else {
            return
        }
        let bin = Int(retrievedDec)
        var binary = String(bin!, radix: 2) //converting from string to binary
        
        binary = padBinary(binary: binary) //padding to the left with 0 until num of binary digits = 8
        displayResult(converted: ("Binary", binary))

       // saveCore(binary)
        //displayResultView("Binary:",binary)
    }
    func decToHex() {//*******************
        let retrievedDec = getDecimal()
        guard retrievedDec != "error" else {
            return
        }
        let dec = Int(retrievedDec)
        let hex = String(dec!, radix: 16)
        displayResult(converted: ("Hexadecimal", hex.uppercased()))
//        saveCore(hex.uppercased())
    }
    func hexToHex() {//*****************
        let hex = checkHexadecimal()
        
        guard hex != "error" else{
            displayErrorMessage(message: ("Error", "Wrong format", "OK"))
            return
        }
        guard hex != "error2" else {
            displayErrorMessage(message: ("Error", "Wrong format", "OK"))
            return
        }
        displayResult(converted: ("Hexadecimal", hex.uppercased()))
//        saveCore(hex.uppercased())
        
    }
    func hexToBin() {//******************
        let hex = checkHexadecimal()
        guard hex != "error" else{
            displayErrorMessage(message: ("Error", "Wrong format", "OK"))
            return
        }
        guard hex != "error2" else {
            displayErrorMessage(message: ("Error", "Wrong format", "OK"))
            return
        }
        var bin = String(Int(hex, radix: 16)!, radix: 2)
        bin = padBinary(binary: bin)
        displayResult(converted: ("Binary", bin))
//        saveCore(bin)
//
    }
    
    func hexToDec() {
        let hex = checkHexadecimal()
        guard hex != "error" else{
            displayErrorMessage(message: ("Error", "Wrong format", "OK"))
            return
        }
        guard hex != "error2" else {
            displayErrorMessage(message: ("Error", "Wrong format", "OK"))
            return
        }
        let dec = Int(hex, radix: 16)!
        let stringDec = "\(dec)"
        displayResult(converted: ("Decimal", stringDec))
//        saveCore(stringDec)
    }
    
    // 0 = Bin, 1 = Hex, 2 = Hex
    func convertButtonTapped() {
        let checkBool: Bool = true
        switch checkBool {
        case unitIndex == 0 && unitIndex2 == 1: binToDec()
        case unitIndex == 0 && unitIndex2 == 2: binToHex()
        case unitIndex == 0 && unitIndex2 == 0: binToBin()
        case unitIndex == 1 && unitIndex2 == 0: decToBin()
        case unitIndex == 1 && unitIndex2 == 2: decToHex()
        case unitIndex == 1 && unitIndex2 == 1: decToDec()
        case unitIndex == 2 && unitIndex2 == 0: hexToBin()
        case unitIndex == 2 && unitIndex2 == 1: hexToDec()
        case unitIndex == 2 && unitIndex2 == 2: hexToHex()
        default: print("Error") //will never execute decault
        }
    }
    
    //Alert Methods
    
    func displayErrorMessage(message: (String, String, String)) {
        Alert(title: Text(message.0), message: Text(message.1), dismissButton: .default(Text(message.2)))
    }
    
    func displayResult(converted: (String, String)) {
        result = "\(converted.0): \(converted.1)"
    }
    
    
    func resetView() {
        textName = ""
        unitIndex = 1
        unitIndex2 = 1
    }
    
    
    //CoreData Methods
    func saveToCoreData() {
        
    }


    
  //************************************************************************
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
                        convertButtonTapped()
                    }) {
                        Text("Convert")
                            .foregroundColor(Color.black)
                            .fontWeight(.heavy)
                    }.buttonStyle(LongWidthButton())
                    Text("Result: ")
                    Text("\(result)")
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
