//
//  Keyboard.swift
//  BinDecHexSwiftUI
//
//  Created by Elias Hall on 9/27/20.
//  Copyright © 2020 Elias Hall. All rights reserved.
//

import Foundation
import SwiftUI

struct Keyboard : ViewModifier {
    //The code below moves the view up
    @State var offset : CGFloat = 0
    
    func body(content: Content) -> some View {
        content.padding(.bottom, offset).onAppear {
            //Showing Keyboard
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) {(notification) in
                let frameValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                self.offset = frameValue.height
            }
            //Hiding Keyboard
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) {(notification) in
                self.offset = 0 //when return is tapped, offset returns to 0
            }
        }
        
    }
    
    
    
}
