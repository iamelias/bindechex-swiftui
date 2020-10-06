//
//  CoreDataManager.swift
//  BinDecHexSwiftUI
//
//  Created by Elias Hall on 10/4/20.
//  Copyright © 2020 Elias Hall. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager(moc: NSManagedObjectContext.current)
    
    var moc: NSManagedObjectContext
    
    private init(moc: NSManagedObjectContext) {
        self.moc = moc
    }
    
    func getAllSavedInput() -> [SavedInput] {
        
        var savedInput = [SavedInput]()
        let request: NSFetchRequest<SavedInput> = SavedInput.fetchRequest()
        
        do {
            savedInput = try self.moc.fetch(request)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return savedInput
    }
}
