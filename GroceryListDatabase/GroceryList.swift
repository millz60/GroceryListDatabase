//
//  GroceryList.swift
//  GroceryListDatabase
//
//  Created by Matt Milner on 7/24/16.
//  Copyright © 2016 Matt Milner. All rights reserved.
//

import UIKit
import CoreData

class GroceryList: NSManagedObject {

    @NSManaged var title: String!
    @NSManaged var groceryItems : NSSet!
}
