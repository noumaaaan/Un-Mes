//
//  Expenses+CoreDataProperties.swift
//  Un mes
//
//  Created by Nouman Mehmood on 14/11/2018.
//  Copyright © 2018 Nouman Mehmood. All rights reserved.
//
//

import Foundation
import CoreData


extension Expenses {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expenses> {
        return NSFetchRequest<Expenses>(entityName: "Expenses")
    }

    @NSManaged public var name: String?
    @NSManaged public var amount: String?

}
