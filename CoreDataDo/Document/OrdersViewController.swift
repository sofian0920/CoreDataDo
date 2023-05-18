//
//  OrdersViewController.swift
//  CoreDataDo
//
//  Created by Софья Норина on 16.05.2023.
//

import UIKit

class OrdersViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var madeSwitch: UISwitch!
    @IBOutlet weak var paidSwitch: UISwitch!
    @IBOutlet weak var customerTextField: UITextField!
    
    var order: Order?

    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func saveButton(_ sender: Any) {
        if saveOrder() {
            dismiss(animated: true, completion: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

      
    }
    
    func saveOrder()-> Bool {
        return true
    }
  
}
