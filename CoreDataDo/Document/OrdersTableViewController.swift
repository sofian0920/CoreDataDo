//
//  OrdersTableViewController.swift
//  CoreDataDo
//
//  Created by Софья Норина on 16.05.2023.
//

import UIKit
import CoreData

class OrdersTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var fetchedResultsController = CoreDataManager.instance.fetchedResultsController(entityName: "Order", keyForSort: "date")
    
    @IBAction func addButton(_ sender: Any) {
        performSegue(withIdentifier: "orderToOrder", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchedResultsController.delegate = self
        do{
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }

    }

    // MARK: - Table view data source



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         if let sections = fetchedResultsController.sections {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let order = fetchedResultsController.object(at: indexPath) as! Order
        let cell = UITableViewCell()
        configCell(cell: cell, order: order)
        return cell
    }
    
    func configCell(cell: UITableViewCell, order: Order) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        let nameOfCustomer = (order.customer == nil) ? "-- Unknown --" : (order.customer!.name!)
        cell.textLabel?.text = formatter.string(from: order.date!) + "\t" + nameOfCustomer
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
        performSegue(withIdentifier: "orderToOrder", sender: customer)
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "orderToOrder" {
            let controller = segue.destination as! OrdersViewController
            controller.order = sender as? Order
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
    

}
