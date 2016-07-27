//
//  GroceryListsTableViewController.swift
//  GroceryListDatabase
//
//  Created by Matt Milner on 7/24/16.
//  Copyright © 2016 Matt Milner. All rights reserved.
//

import UIKit
import CoreData

class GroceryListsTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var managedObjectContext: NSManagedObjectContext!
    var fetchedResultsController: NSFetchedResultsController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let fetchRequest = NSFetchRequest(entityName: "GroceryList")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        self.fetchedResultsController.delegate = self
        
        try! self.fetchedResultsController.performFetch()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let sections = self.fetchedResultsController.sections else{
            fatalError("Error fetching sections")
        }
        return sections[section].numberOfObjects;
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

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ListCell", forIndexPath: indexPath)
        
        guard let groceryList = self.fetchedResultsController.objectAtIndexPath(indexPath) as? GroceryList else {
            fatalError("Error retreiving list")
        }
        
        cell.textLabel?.text = groceryList.title

        // Configure the cell...

        return cell
    }

 
    @IBAction func addGroceryList(){
    
        let alertController = UIAlertController(title: "Add Grocery List", message: "Enter List Name", preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            
            // add list name to database here
            // to fix this error, make sure that the GroceryList class is linked within the database to the GroceryList class file and make sure that the relationships are set to the correct type (One to many, one to one)
            guard let groceryList = NSEntityDescription.insertNewObjectForEntityForName("GroceryList", inManagedObjectContext: self.managedObjectContext) as? GroceryList else {
                fatalError("GroceryList does not exist")
            }
            
            groceryList.title = alertController.textFields![0].text!
            
            try! self.managedObjectContext.save()
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
        }
        
        alertController.addTextFieldWithConfigurationHandler { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter List Name"
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        

    
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        guard let indexPath = self.tableView.indexPathForSelectedRow else{
            fatalError("Invalid IndexPath")
        }
        
        let groceryList = self.fetchedResultsController.objectAtIndexPath(indexPath) as! GroceryList
        
        guard let groceryItemsTableViewController = segue.destinationViewController as? GroceryItemsTableViewController else {
            fatalError("Destination Controller not found")
        }
        
        groceryItemsTableViewController.groceryList = groceryList
        groceryItemsTableViewController.managedObjectContext = self.managedObjectContext
        
        
        
        
    }
    

 
 
 

}
