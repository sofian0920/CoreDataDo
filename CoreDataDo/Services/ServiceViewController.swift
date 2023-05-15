//
//  ServiceViewController.swift
//  CoreDataDo
//
//  Created by Софья Норина on 15.05.2023.
//

import UIKit

class ServiceViewController: UIViewController {

    @IBOutlet weak var infoTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let service = service {
            nameTextField.text = service.name
            infoTextField.text = service.info
        }
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        if saveService() {
            dismiss(animated: true, completion: nil)
        }
    }
    var service: Services?
    func saveService() -> Bool{
        
        if nameTextField.text!.isEmpty {
            let alert = UIAlertController(title: "Validation error", message: "Input the name of the Service!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        
        if service == nil {
            service = Services()
            
        }
        if let service = service {
            service.name = nameTextField.text
            service.info = infoTextField.text
            CoreDataManager.instance.saveContext()
        }
        return true
    }
}
