//
//  GroceryItemsTableViewController.swift
//  GroceryListDatabase
//
//  Created by Matt Milner on 7/25/16.
//  Copyright © 2016 Matt Milner. All rights reserved.
//

import UIKit
import CoreData

class GroceryItemsTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var managedObjectContext: NSManagedObjectContext!
    var groceryList: GroceryList!
    var groceryItems = [GroceryItem]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.groceryItems = self.groceryList.groceryItems.allObjects as! [GroceryItem]
        
        self.title = self.groceryList.valueForKey("title") as! String

    }
    
    
    @IBAction func addGroceryItem(){
        
        
        let alertController = UIAlertController(title: "Add Grocery Item", message: "Enter Item Name", preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            
            let groceryItem = NSEntityDescription.insertNewObjectForEntityForName("GroceryItem", inManagedObjectContext: self.managedObjectContext)
            
            groceryItem.setValue(alertController.textFields![0].text!, forKey: "title")
            
            let groceryItems = self.groceryList.mutableSetValueForKey("groceryItems")
            
            groceryItems.addObject(groceryItem)
            
            try! self.managedObjectContext.save()
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
        }
        
        alertController.addTextFieldWithConfigurationHandler { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Item Name"
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch(type) {
            
        case .Insert:
            self.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
            break
        case .Delete:
            break
        case .Update:
            break
        case .Move:
            break
            
        }
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.groceryItems.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath)

        
        let groceryItem = self.groceryItems[indexPath.row]
        
        cell.textLabel?.text = groceryItem.title

        return cell
    }
    

   }
