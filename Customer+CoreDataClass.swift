//
//  Customer+CoreDataClass.swift
//  CoreDataDo
//
//  Created by Софья Норина on 8.05.2023.
//
//

import Foundation
import CoreData


public class Customer: NSManagedObject {
    convenience init() {
        let entity = NSEntityDescription.entity(forEntityName: "Customer", in: CoreDataManager.instance.managedObjectContext)
        
        self.init(entity: entity!, insertInto: CoreDataManager.instance.managedObjectContext)
        
    }
    
    
}
