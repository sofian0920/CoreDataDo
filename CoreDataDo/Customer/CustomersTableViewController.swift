//
//  CustomersTableTableViewController.swift
//  CoreDataDo
//
//  Created by Софья Норина on 8.05.2023.
//

import UIKit
import CoreData

class CustomersTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    
    var fetchedResultsController: NSFetchedResultsController = CoreDataManager.instance.fetchedResultsController(entityName: "Customer", keyForSort: "name")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
    }
    @IBAction func addCustomer(_ sender: Any) {
        performSegue(withIdentifier: "customersToCustomer", sender: nil)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections{
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customer = fetchedResultsController.object(at: indexPath) as! Customer
        let cell = UITableViewCell()
        cell.textLabel?.text = customer.name
        
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCell.EditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .delete {
            let managedObject = fetchedResultsController.object(at: indexPath as IndexPath) as! NSManagedObject
            CoreDataManager.instance.managedObjectContext.delete(managedObject)
               CoreDataManager.instance.saveContext()
           }
       }
       
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let customer = fetchedResultsController.object(at: indexPath as IndexPath) as? Customer
        performSegue(withIdentifier: "customersToCustomer", sender: customer)
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "customersToCustomer" {
            let controller = segue.destination as! CustomerViewController
            controller.customer = sender as? Customer
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    private func controller(controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeObject anObject: AnyObject, atIndexPath indexPath: IndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
              
            }
        case .update:
            if let indexPath = indexPath {
                let customer = fetchedResultsController.object(at: indexPath as IndexPath) as! Customer
                let cell = tableView.cellForRow(at: indexPath as IndexPath)
                cell!.textLabel?.text = customer.name
            }
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
        
        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            tableView.endUpdates()
        }
    }
    
    override  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let managedObject = fetchedResultsController.object(at: indexPath) as! NSManagedObject
            CoreDataManager.instance.managedObjectContext.delete(managedObject)
            CoreDataManager.instance.saveContext()
        }
    }
}
