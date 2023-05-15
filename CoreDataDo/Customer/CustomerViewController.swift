//
//  CustomerViewController.swift
//  CoreDataDo
//
//  Created by Софья Норина on 8.05.2023.
//

import UIKit

class CustomerViewController: UIViewController {
    var customer: Customer?
    @IBAction func saveButton(_ sender: Any) {
        if saveCustomer() {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func canselButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var infoTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let customer = customer {
            nameTextField.text = customer.name
            infoTextField.text = customer.info
        }
        }
    func saveCustomer() -> Bool {
        if nameTextField.text!.isEmpty {
            let alert = UIAlertController(title: "Validation erro", message: "Input the name of the Customer", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        
        if customer == nil {
            customer = Customer()
        }
        
        if let customer = customer {
            customer.name = nameTextField.text
            customer.info = infoTextField.text
            CoreDataManager.instance.saveContext()
        }
        return true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
