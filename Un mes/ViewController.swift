//
//  ViewController.swift
//  Un mes
//
//  Created by Nouman Mehmood on 09/11/2018.
//  Copyright © 2018 Nouman Mehmood. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    // Initialise the outlets on storyboard
    @IBOutlet weak var tableView: UITableView!
    
    //  Create dictionary to store core data
    var expensesDict : [(String, String)] = [];
    
    // View did load
    override func viewDidLoad(){
        self.retrieveCoreData()
    }
    
    @IBAction func addButtonTapped() {
        let alert = UIAlertController(title: "Add Expense", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Expense"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Amount"
            textField.keyboardType = .decimalPad
        }
        
        let action = UIAlertAction(title: "Add", style: .default) { (_) in
            let name = alert.textFields!.first!.text!
            let amount = "£" + alert.textFields!.last!.text!
            
            self.saveToCoreData(name: name, amount: amount)
            self.tableView.reloadData()
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
        
    // Function to save core data valeus
    func saveToCoreData(name: String, amount: String){
    
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newExpense = NSEntityDescription.insertNewObject(forEntityName: "Expenses", into: context)

        newExpense.setValue(name, forKey: "name")
        newExpense.setValue(amount, forKey: "amount")

        do {
            try context.save()
            expensesDict.append((name, amount));
            print("Successfully saved:")
            print("Expense name: " + name + " - Amount: " + amount)
            

        } catch  {
            print(error.localizedDescription)
        }
    }
    
    // Function to retrieve all core data values
    func retrieveCoreData(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Expenses")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            
            if results.count > 0 {
                
                for result in results as! [NSManagedObject]{
                    if let name = result.value(forKey: "name") as? String {
                        if let amount = result.value(forKey: "amount") as? String {
                            expensesDict.append((name, amount))
                        }
                    }
                }
                tableView.reloadData()
            }
        } catch {
            print(error.localizedDescription)
            
        }
        
    }

    
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expensesDict.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        
        let (key, value) = expensesDict[indexPath.row]
        cell.textLabel?.text = key
        cell.detailTextLabel?.text = value
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let theAlert = UIAlertController(title: "Delete record?", message: "Are you sure you would like to delete this deadline?", preferredStyle: UIAlertController.Style.alert)
            
            theAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                let (key, value) = self.expensesDict[indexPath.row]
                
                print((key, value))
                

            }))
                
                
            theAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                return
            }))
            
            present(theAlert, animated: true, completion: nil)
        }
    }

}

