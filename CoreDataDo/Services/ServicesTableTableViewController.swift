//
//  ServicesTableTableViewController.swift
//  CoreDataDo
//
//  Created by Софья Норина on 15.05.2023.
//

import UIKit
import CoreData

class ServicesTableTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    
    
    var fetchedResultsController: NSFetchedResultsController = CoreDataManager.instance.fetchedResultsController(entityName: "Services", keyForSort: "name")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
    }
    
    @IBAction func addButton(_ sender: Any) {
        performSegue(withIdentifier: "servicesToService", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections{
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let service = fetchedResultsController.object(at: indexPath) as! Services
        let cell = UITableViewCell()
        cell.textLabel?.text = service.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let service = fetchedResultsController.object(at: indexPath as IndexPath) as? Services
        performSegue(withIdentifier: "servicesToService", sender: service)
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "servicesToService" {
            let controller = segue.destination as! ServiceViewController
            controller.service = sender as? Services
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
