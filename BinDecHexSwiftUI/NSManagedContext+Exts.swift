//
//  NSManagedContext+Exts.swift
//  BinDecHexSwiftUI
//
//  Created by Elias Hall on 10/4/20.
//  Copyright © 2020 Elias Hall. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension NSManagedObjectContext {
    
    static var current: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext //returning the current context of Core Data
    }
    
    
    
}
