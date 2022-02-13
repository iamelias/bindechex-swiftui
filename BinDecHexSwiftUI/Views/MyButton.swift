//
//  MyButton.swift
//  BinDecHexSwiftUI
//
//  Created by Elias Hall on 2/13/22.
//  Copyright © 2022 Elias Hall. All rights reserved.
//

import SwiftUI

struct MyButton: View {
    var title: String
    var action: () -> ()
    var body: some View {
        Text(title)
        Button(action: {
            action()
        }, label: {
            Text("Convert")
                .foregroundColor(Color.black)
                .fontWeight(.heavy)
        })
    }
}

//struct MyButton_Previews: PreviewProvider {
//    static var previews: some View {
//        MyButton()
//    }
//}
