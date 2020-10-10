//
//  ContentView.swift
//  BinDecHexSwiftUI
//
//  Created by Elias Hall on 7/28/20.
//  Copyright © 2020 Elias Hall. All rights reserved.
//

import Foundation
import SwiftUI
import CoreData



struct ContentView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: SavedInput.entity(), sortDescriptors: [
                    NSSortDescriptor(keyPath: \SavedInput.fieldText, ascending: true)]
    ) var savedData: FetchedResults<SavedInput> //saved data holds the persisted data

    @State private var unitIndex: Int = 1 //first picker's unit
    @State private var unitIndex2: Int = 1 //secon picker's unit
    @State private var textName = "" //input TextField
    @State private var result = "" //Result Text
    @State private var showResult = false
    @State private var showAlert = false
    @State private var errorMessage: (String, String, String) = ("Error", "Error", "Error")
    var unit = ["Bin", "Dec", "Hex"]
    var unit2 = ["Bin", "Dec", "Hex"]
    var saveUnit1: Int = 1
    var saveUnit2: Int = 1
    @State private var savedInputs: [SavedInput] = []
    
        func fetchCoreInput() { // When view appears
        print("Called fetchCoreInput")
            
       savedInputs = CoreDataManager.shared.getAllSavedInput()
        setupView()
            
    }
    

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
            updateErrorMessage(message: ("Input Error", "Can't convert because input is not in binary format.", "Ok"))
            return false
        }
        for c in binary {
            if c != "0" && c != "1" {
                updateErrorMessage(message: ("Input Error", "Can't convert because input is not in binary format.", "Ok"))
                return false
            }
        }
        return true
    }
    
    func checkDecimal(decimal: String) -> Bool {
        let checkNum = Int(decimal) //convert passed string to int, won't convert nonint
        if checkNum != nil { //if doesn't convert
            
            if checkNum! < 0 {
                updateErrorMessage(message: ("Input Error", "Input cannot be negative", "Ok"))
                return false
            }
            
            guard checkNum! < 1000000000 else { //making an upperlimit to users capability
                updateErrorMessage(message: ("Input Error", "Input is past upper limit", "Ok"))
                return false
            }
            return true //it is a valid int/decimal
        }
        else {
            updateErrorMessage(message: ("Input Error", "Can't convert because input is not in decimal format. Input can't be negative.", "Ok"))
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
        displayResult(converted: ("Binary", bin), settings: (0,0))
        
        saveToCoreData(data: bin, settings: (0,0))
    }
    func binToDec() {//*******************
        let bin = getBinary()
        guard bin != "error" else{ return}
        
        if let dec = Int(textName, radix: 2) {
            let stringDec = "\(dec)"
            displayResult(converted: ("Decimal", stringDec), settings: (0,1))
            saveToCoreData(data: stringDec, settings: (0,1))
        }
    }
    func binToHex() {//**********************
        let bin = self.getBinary()
        guard bin != "error" else{
            return
        }
        let hex = String(Int(bin, radix: 2)!, radix: 16)//Convert Binary to Hex
        displayResult(converted: ("Hexadecimal", hex.uppercased()), settings: (0,2))
        saveToCoreData(data: hex.uppercased(), settings: (0,2))
    }
    func decToDec() {//**********************
        let dec = getDecimal()
        guard dec != "error" else {
            return
        }
        displayResult(converted: ("Decimal", dec), settings: (1,1))

        saveToCoreData(data: dec, settings: (1,1))
    }
    func decToBin() {//*****************
        let retrievedDec = getDecimal()
        guard retrievedDec != "error" else {
            return
        }
        let bin = Int(retrievedDec)
        var binary = String(bin!, radix: 2) //converting from string to binary
        
        binary = padBinary(binary: binary) //padding to the left with 0 until num of binary digits = 8
        displayResult(converted: ("Binary", binary), settings: (1,0))

        saveToCoreData(data: binary, settings: (1,0))
    }
    func decToHex() {//*******************
        let retrievedDec = getDecimal()
        guard retrievedDec != "error" else {
            return
        }
        let dec = Int(retrievedDec)
        let hex = String(dec!, radix: 16)
        displayResult(converted: ("Hexadecimal", hex.uppercased()), settings: (1,2))
        saveToCoreData(data: hex.uppercased(), settings: (1,2))
    }
    func hexToHex() {//*****************
        let hex = checkHexadecimal()
        
        guard hex != "error" else{
            updateErrorMessage(message: ("Input Error", "Can't convert because input is not in hexadecimal format.", "Ok"))
            return
        }
        guard hex != "error2" else {
            updateErrorMessage(message: ("Input Error", "Can't convert because input is not in hexadecimal format.", "Ok"))
            return
        }
        displayResult(converted: ("Hexadecimal", hex.uppercased()), settings: (2,2))
        saveToCoreData(data: hex.uppercased(), settings: (2,2))
        
    }
    func hexToBin() {//******************
        let hex = checkHexadecimal()
        guard hex != "error" else{
            updateErrorMessage(message: ("Input Error", "Can't convert because input is not in hexadecimal format.", "Ok"))
            return
        }
        guard hex != "error2" else {
            updateErrorMessage(message: ("Input Error", "Input is past upper limit", "Ok"))
            return
        }
        var bin = String(Int(hex, radix: 16)!, radix: 2)
        bin = padBinary(binary: bin)
        displayResult(converted: ("Binary", bin), settings: (2,0))
        saveToCoreData(data: bin, settings: (2,0))
    }
    
    func hexToDec() {
        let hex = checkHexadecimal()
        guard hex != "error" else{
            updateErrorMessage(message: ("Input Error", "Can't convert because input is not in hexadecimal format.", "Ok"))
            return
        }
        guard hex != "error2" else {
            updateErrorMessage(message: ("Input Error", "Input is past upper limit.", "Ok"))
            return
        }
        let dec = Int(hex, radix: 16)!
        let stringDec = "\(dec)"
        displayResult(converted: ("Decimal", stringDec), settings: (2,1))
        
        saveToCoreData(data: stringDec, settings: (2,1))
        
    }
    
    // 0 = Bin, 1 = Dec, 2 = Hex
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
        default: print("Error") //will never execute default
        }
    }
    
    //Alert Methods
    
    func updateErrorMessage(message: (String, String, String)) {
        errorMessage = (message.0, message.1, message.2)
        showAlert = true
    }
    
    func displayResult(converted: (String, String), settings: (Int, Int)? = nil) {
        if settings != nil {
            unitIndex = settings!.0
            unitIndex2 = settings!.1
        }
        result = "\(converted.0): \(converted.1)"
    }
    
    func resetView() {
        textName = ""
        unitIndex = 1
        unitIndex2 = 1
        result = ""
        showAlert = false
        
        errorMessage = ("Error", "Error", "Error")
        //managedObjectContext.delete(savedInputs[0])
        saveToCoreData(data: "")
    }
    
    
    //CoreData Methods
    func saveToCoreData(data: String, settings: (Int, Int)? = nil) {
        print("made it to SaveCore Data method")
        if !savedInputs.isEmpty {
            print("***************************")
            print(savedInputs[0])
            print(savedInputs.count)
            print("***************************")
            
            for i in 0..<savedInputs.count {
                managedObjectContext.delete(savedInputs[i]) //deleting current saved before new save
            }
            savedInputs.removeAll()
        }
        else {
            print("Testing delete didn't happen")
        }
        let coreData = SavedInput(context: self.managedObjectContext)
        coreData.fieldText = textName
//        coreData.inputPick = "1"
//        coreData.outputPick = "2"
        coreData.inputPick = "\(settings?.0 ?? 1)"
        coreData.outputPick = "\(settings?.1 ?? 1)"
        coreData.resultPresent = true
        coreData.resultValue = data
        
        do {
            print("core saving")
            try self.managedObjectContext.save()
            savedInputs.append(coreData)
            setupView(setting: (settings?.0 ?? 1, settings?.1 ?? 1))
        } catch {
            print("Error with core data retrieval")
        }
//        savedInputs[0] = coreData
                
    }
    
    func defaultView() {
        print("default View called")
        unitIndex = 1
        unitIndex2 = 1
        textName = ""
        result = ""
        showResult = false
        
    }
    
    func setupView(setting: (Int, Int)? = nil) { //Error maybe here
        guard !savedInputs.isEmpty else {
            print("savedInputs is empty")
            defaultView()
            return
        }
        print("Made it to setupView Method")
        unitIndex = Int(savedInputs.last!.inputPick!)!
        unitIndex2 = Int(savedInputs.last!.outputPick!)!
        textName = savedInputs.last!.fieldText!
        result = savedInputs.last!.resultValue!
        showResult = savedInputs.last!.resultPresent
        
        if savedInputs.count > 0 {
            showResult = true
        }
        else {
            showResult = false
        }
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
                            
                            Picker(selection: self.$unitIndex2, label: Text("Unit2").bold()) {
                                ForEach(0..<self.unit2.count) {
                                    Text(self.unit2[$0])
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
                    }
                    .buttonStyle(LongWidthButton())
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("\(errorMessage.0)"), message: Text("\(errorMessage.1)"), dismissButton: .default(Text("\(errorMessage.2)")))
                    }
                    Text("Result: ")
                    Text("\(result)")
                    Spacer()
                    
                }.background(Color(UIColor.secondarySystemBackground)).edgesIgnoringSafeArea(.all).navigationBarTitle(Text("BinDecHex"), displayMode: .inline).navigationBarItems(trailing: Button(action: {
                    print("Refreshed tapped")
                    resetView()
                }) {
                    Image(systemName: "arrow.clockwise")
                }.buttonStyle(RefreshButton())
                )
            }
        }.onAppear {
            UINavigationBar.appearance().backgroundColor = UIColor.secondarySystemBackground
            UINavigationBar.appearance().shadowImage = UIImage()
            print("OnAppear")
            unitIndex = saveUnit1
            unitIndex2 = saveUnit2
            defaultView()
            fetchCoreInput()
            
            
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
