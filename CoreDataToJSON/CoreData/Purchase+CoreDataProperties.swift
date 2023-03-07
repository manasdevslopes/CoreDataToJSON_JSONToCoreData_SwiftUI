//
//  Purchase+CoreDataProperties.swift
//  CoreDataToJSON
//
//  Created by MANAS VIJAYWARGIYA on 07/03/23.
//
//

import Foundation
import CoreData


extension Purchase {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Purchase> {
        return NSFetchRequest<Purchase>(entityName: "Purchase")
    }

    @NSManaged public var amountSpent: Double
    @NSManaged public var dateOfPurchase: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var title: String?

}

extension Purchase : Identifiable {

}
