//
//  ViewController.swift
//  Un mes
//
//  Created by Nouman Mehmood on 09/11/2018.
//  Copyright © 2018 Nouman Mehmood. All rights reserved.
//

import UIKit
import CoreData

class ExpensesViewController: UIViewController {
    
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var expenses_array = [Expenses]()
    var send_array = [Expenses]()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        retrieveExpenses()
        getTotalExpenses()
    }
    
    // Add a new expense
    @IBAction func addButtonTapped() {
        let alert = UIAlertController(title: "Add Expense", message: nil, preferredStyle: .alert)
        alert.addTextField{ (textField) in
            textField.placeholder = "Name"
        }
        alert.addTextField{ (textField) in
            textField.placeholder = "Amount"
            textField.keyboardType = .decimalPad
        }
        
        // Add button
        alert.addAction(UIAlertAction(title: "Add", style: .default){ (_) in
            let name = alert.textFields!.first!.text!
            let amount = alert.textFields!.last!.text!
            
            let expense = Expenses(context: PersistenceService.context)
            expense.name = name
            expense.amount = amount
            PersistenceService.saveContext()
            
            self.expenses_array.append(expense)
            self.getTotalExpenses()
            self.tableView.reloadData()
        })
        // Cancel button
        alert.addAction(UIAlertAction(title: "Cancel", style: .default){ (_) in
            return
        })
        present(alert, animated: true, completion: nil)
    }
    
    // Function to retrieve all expenses from Core Data
    func retrieveExpenses(){
        let fetchRequest: NSFetchRequest<Expenses> = Expenses.fetchRequest()
        do {
            let expenses = try PersistenceService.context.fetch(fetchRequest)
            self.expenses_array = expenses
            self.tableView.reloadData()
            
        } catch  {
            print(error.localizedDescription )
        }
    }
    // Calculate the total for all the expenses
    func getTotalExpenses(){
        
        var total = 0.0
        for result in expenses_array {
            if let cost = Double(result.amount!) {
                total += cost
            } else {
                print("Error, not a Double: \(result.amount!)")
            }
        }
        totalLabel.text = "Total: " + String(total)
    }

    // Send the data to the next view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "editExpense") {
            let secondViewController = segue.destination as! EditExpensesViewController
            secondViewController.send_array = send_array
        }
    }

}

extension ExpensesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses_array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.textLabel?.text = expenses_array[indexPath.row].name
        cell.detailTextLabel?.text = expenses_array[indexPath.row].amount
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            
            let fetchRequest: NSFetchRequest<Expenses> = Expenses.fetchRequest()
            do {
                let result = try PersistenceService.context.fetch(fetchRequest)
    
                // Delete from Core Data and remove from the arrays then save
                if result.contains(expenses_array[indexPath.row]){
                    PersistenceService.context.delete(expenses_array[indexPath.row])
                    expenses_array = expenses_array.filter { $0 != expenses_array[indexPath.row] }
                    PersistenceService.saveContext()
                    self.getTotalExpenses()
                    self.tableView.reloadData()
                }
            
            } catch  {
                print(error.localizedDescription )
            }
        }
    }
    
    // Navigate to the view controllers dependant upon what table in cell has been selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        send_array = [self.expenses_array[indexPath.row]]
        self.performSegue(withIdentifier: "editExpense", sender: self)
    }
    
}

