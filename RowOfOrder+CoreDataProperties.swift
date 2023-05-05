//
//  RowOfOrder+CoreDataProperties.swift
//  CoreDataDo
//
//  Created by Софья Норина on 5.05.2023.
//
//

import Foundation
import CoreData


extension RowOfOrder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RowOfOrder> {
        return NSFetchRequest<RowOfOrder>(entityName: "RowOfOrder")
    }

    @NSManaged public var sum: Float
    @NSManaged public var order: Order?
    @NSManaged public var service: Services?

}

extension RowOfOrder : Identifiable {

}
