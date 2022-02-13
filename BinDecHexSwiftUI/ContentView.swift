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
    @State private var errorMessage: (String, String, String) = ("", "", "") //Default
    @State private var savedInputs: [SavedInput] = [] //storing core fetched data
    var unit = ["Bin", "Dec", "Hex"]
    
    
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
    
    
    //Check Format Methods
    func padBinary(binary: String) -> String {
        var binary = binary
        
        while binary.count < 8 {
            binary = "0\(binary)"
        }
        return binary
    }
    
    
    func hapticError() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
    
    
    //Check Syntax Methods
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
        var bin = getBinary()
        
        guard bin != "error" else{
            return
        }
        
        bin = padBinary(binary: bin)
        
        saveToCoreData(data: "Binary: \(bin)", settings: (0,0))
    }
    
    
    func binToDec() {
        let bin = getBinary()
        guard bin != "error" else{ return}
        
        if let dec = Int(textName, radix: 2) {
            let stringDec = "\(dec)"
            saveToCoreData(data: "Decimal: \(stringDec)", settings: (0,1))
        }
    }
    
    
    func binToHex() {
        let bin = self.getBinary()
        guard bin != "error" else{
            return
        }
        let hex = String(Int(bin, radix: 2)!, radix: 16)//Convert Binary to Hex
        saveToCoreData(data: "Hexadecimal: \(hex.uppercased())", settings: (0,2))
    }
    
    
    func decToDec() {
        let dec = getDecimal()
        guard dec != "error" else {
            return
        }
        saveToCoreData(data: "Decimal: \(dec)", settings: (1,1))
    }
    
    
    func decToBin() {
        let retrievedDec = getDecimal()
        guard retrievedDec != "error" else {
            return
        }
        let bin = Int(retrievedDec)
        var binary = String(bin!, radix: 2) //converting from string to binary
        
        binary = padBinary(binary: binary) //padding to the left with 0 until num of binary digits = 8
        saveToCoreData(data: "Binary: \(binary)", settings: (1,0))
    }
    
    
    func decToHex() {
        let retrievedDec = getDecimal()
        guard retrievedDec != "error" else {
            return
        }
        let dec = Int(retrievedDec)
        let hex = String(dec!, radix: 16)
        saveToCoreData(data: "Hexadecimal: \(hex.uppercased())", settings: (1,2))
    }
    
    
    func hexToHex() {
        let hex = checkHexadecimal()
        
        guard hex != "error" else{
            updateErrorMessage(message: ("Input Error", "Can't convert because input is not in hexadecimal format.", "Ok"))
            return
        }
        guard hex != "error2" else {
            updateErrorMessage(message: ("Input Error", "Can't convert because input is not in hexadecimal format.", "Ok"))
            return
        }
        saveToCoreData(data: "Hexadecimal: \(hex.uppercased())", settings: (2,2))
    }
    
    
    func hexToBin() {
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
        saveToCoreData(data: "Binary: \(bin)", settings: (2,0))
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
        saveToCoreData(data: "Decimal: \(stringDec)", settings: (2,1))
    }
    
    
    //Alert Methods
    func updateErrorMessage(message: (String, String, String)) {
        errorMessage = (message.0, message.1, message.2)
        hapticError()
        showAlert = true
    }
    
    
    //CoreData Methods
    func fetchCoreInput() { // fetching saved data from core data
        savedInputs = CoreDataManager.shared.getAllSavedInput()
        setupView()
    }
    
    
    func saveToCoreData(data: String, settings: (Int, Int)? = nil) { //saving data to core data
        if !savedInputs.isEmpty {
            for i in 0..<savedInputs.count {
                managedObjectContext.delete(savedInputs[i]) //deleting current saved before new save
            }
            savedInputs.removeAll()
        }
        else {
            print("Core Data wasn't deleted")
        }
        let coreData = SavedInput(context: self.managedObjectContext)
        coreData.fieldText = textName
        coreData.inputPick = "\(settings?.0 ?? 1)"
        coreData.outputPick = "\(settings?.1 ?? 1)"
        coreData.resultPresent = true
        coreData.resultValue = data
        
        do {
            try self.managedObjectContext.save()
            savedInputs.append(coreData)
            //            setupView(data: data)
            setupView()
        } catch {
            print("Error with core data saving")
        }
    }
    
    
    // Views
    func defaultView() { //reseting view to default model
        unitIndex = 1
        unitIndex2 = 1
        textName = ""
        result = ""
        showResult = false
    }
    
    
    func resetView() {
        defaultView()
        saveToCoreData(data: "") //replacing saved coredata with blank core data
    }
    
    
    func setupView(data: String? = nil) { //setting up view
        guard !savedInputs.isEmpty else { //ensuring fetched data was recieved if not use default view
            defaultView()
            return
        }
        
        //using data of type SavedInput to set up view
        unitIndex = Int(savedInputs.last?.inputPick ?? "1") ?? 1 //picker 1
        unitIndex2 = Int(savedInputs.last?.outputPick ?? "1") ?? 1 //picker 2
        textName = savedInputs.last?.fieldText ?? ""
        result = savedInputs.last?.resultValue ?? ""
        showResult = (savedInputs.last?.resultPresent ?? false) && (savedInputs.count > 0 ? true : false)
    }
    
    
    //************************************************************************
    //UI Canvas
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
                            MyPicker(selectedUnit: self.$unitIndex, units: unit).frame(maxWidth: geometry.size.width/2).clipped()
                            MyPicker(selectedUnit: self.$unitIndex2, units: unit).frame(maxWidth: geometry.size.width/2).clipped()
                    }
                    Text("Enter Value").fontWeight(.heavy)
                    HStack {
                        MyTextField(textString: $textName)
                        Spacer()
                    }
                    
                    MyButton(title: "Convert", action: convertButtonTapped)
                    .buttonStyle(LongWidthButton())
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("\(errorMessage.0)"), message: Text("\(errorMessage.1)"), dismissButton: .default(Text("\(errorMessage.2)")))
                    }
                    Text("Result: ")
                    Text("\(result)")
                    Spacer()
                    
                }.background(Color(UIColor.secondarySystemBackground)).edgesIgnoringSafeArea(.all).navigationBarTitle(Text("BinDecHex"), displayMode: .inline).navigationBarItems(trailing: Button(action: {
                    resetView()
                }) {
                    Image(systemName: "arrow.clockwise")
                }.buttonStyle(RefreshButton())
                )
            }
        }.onAppear {
            UINavigationBar.appearance().backgroundColor = UIColor.secondarySystemBackground
            UINavigationBar.appearance().shadowImage = UIImage()
            defaultView()
            fetchCoreInput()
        }
    }
    
    struct LongWidthButton: ButtonStyle {
        
        func makeBody(configuration: Self.Configuration) -> some View {
            configuration.label
                .padding(.all)
                .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 10.0)
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
