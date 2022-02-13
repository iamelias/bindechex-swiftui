//
//  MyTextField.swift
//  BinDecHexSwiftUI
//
//  Created by Elias Hall on 2/13/22.
//  Copyright © 2022 Elias Hall. All rights reserved.
//

import SwiftUI

struct MyTextField: View {
    @Binding var textString: String
    var body: some View {
        TextField("0", text: $textString).padding(.horizontal).textFieldStyle(RoundedBorderTextFieldStyle()).keyboardType(.default)
    }
}

//struct MyTextField_Previews: PreviewProvider {
//    static var previews: some View {
//        MyTextField()
//    }
//}
