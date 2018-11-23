//
//  EditExpensesViewController.swift
//  Un mes
//
//  Created by Nouman Mehmood on 16/11/2018.
//  Copyright © 2018 Nouman Mehmood. All rights reserved.
//

import UIKit
import CoreData

class EditExpensesViewController: UIViewController {
 
    var send_array_exp = [Expenses]() // Defined from the previous view controller
    var send_array_inc = [Income]() // Defined from the previous view controller
    
    // storyboard outlets
    @IBOutlet weak var expenseNameTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setFields()
    }
    
    // Pre load the text fields
    func setFields(){
        expenseNameTextField.text = send_array_exp.first!.name
        amountTextField.text = send_array_exp.first!.amount
    }
    
    // Save the changes to Core Data
    @IBAction func saveButtonTapped(_ button: UIButton) {
        
        let editedName = expenseNameTextField.text
        let editedAmount = amountTextField.text
        
        // Check if the values have not been changed then return to previous
        if (send_array_exp.first!.name == editedName) && (send_array_exp.first!.amount == editedAmount){
            navigationController?.popViewController(animated: true)
            return
        }
        
        // Check if either of the fields are empty before saving
        if (editedName!.isEmpty || editedAmount!.isEmpty) {
            let alert = UIAlertController(title: "Error", message: "None of the fields can be empty", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Return", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        // Update Core Data
        updateCoreData(expenseName: expenseNameTextField.text!, expenseAmount: amountTextField.text!)
    }
    
    // Function to update the data base with the new values
    func updateCoreData(expenseName: String, expenseAmount: String){

        let fetchRequest: NSFetchRequest<Expenses> = Expenses.fetchRequest()
        do {
            let result = try PersistenceService.context.fetch(fetchRequest)
            
            for object in result {
                if object.name == send_array_exp.first!.name {
                    object.setValue(expenseName, forKey: "name")
                    object.setValue(expenseAmount, forKey: "amount")
                }
            }
            
            do {
                try PersistenceService.context.save()
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                   self.navigationController?.popViewController(animated: true)
                })
            } catch  {
                print(error.localizedDescription)
            }
            
        } catch  {
            print(error.localizedDescription )
        }
    }
    
    
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
