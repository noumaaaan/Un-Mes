//
//  ViewController.swift
//  Un mes
//
//  Created by Nouman Mehmood on 09/11/2018.
//  Copyright © 2018 Nouman Mehmood. All rights reserved.
//

import UIKit
import CoreData
import PopupDialog

class ExpensesViewController: UIViewController {
    
    // MARK: - Define Variables
    var expenses_array = [Expenses]()
    var send_array_exp = [Expenses]()
    var send_array_inc = [Income]()
    var income_array = [Income]()
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var expensesTotalLabel: UILabel!
    @IBOutlet weak var incomeTotalLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
   
    // MARK: - Actions
    @IBAction func addButtonTapped() {
        
        let popup = PopupDialog(title: "ADD NEW", message: "Choose whether you're adding an income or expense")
        let incomeButton = DefaultButton(title: "Income"){
            let alert = UIAlertController(title: "Add Income", message: nil, preferredStyle: .alert)
            alert.addTextField{ (textField) in
                textField.placeholder = "Name"
            }
            alert.addTextField{ (textField) in
                textField.placeholder = "Amount"
                textField.keyboardType = .decimalPad
            }
            
            alert.addAction(UIAlertAction(title: "Add", style: .default){ (_) in
                let name = alert.textFields!.first!.text!
                let amount = alert.textFields!.last!.text!
                
                let income = Income(context: PersistenceService.context)
                income.name = name
                income.amount = amount
                PersistenceService.saveContext()
                
                self.income_array.append(income)
                self.setTotalLabels(income: self.getTotalIncome(), expenses: self.getTotalExpenses(), difference: self.getTrueTotal())
                self.tableView.reloadData()
            })
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .default){ (_) in
                return
            })
            self.present(alert, animated: true, completion: nil)
        }
        
        let expenseButton = DefaultButton(title: "Expense"){
            let alert = UIAlertController(title: "Add Expense", message: nil, preferredStyle: .alert)
            alert.addTextField{ (textField) in
                textField.placeholder = "Name"
            }
            alert.addTextField{ (textField) in
                textField.placeholder = "Amount"
                textField.keyboardType = .decimalPad
            }
            
            alert.addAction(UIAlertAction(title: "Add", style: .default){ (_) in
                let name = alert.textFields!.first!.text!
                let amount = alert.textFields!.last!.text!
                
                let expense = Expenses(context: PersistenceService.context)
                expense.name = name
                expense.amount = amount
                PersistenceService.saveContext()
                
                self.expenses_array.append(expense)
                self.setTotalLabels(income: self.getTotalIncome(), expenses: self.getTotalExpenses(), difference: self.getTrueTotal())
                self.tableView.reloadData()
            })
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .default){ (_) in
                return
            })
            self.present(alert, animated: true, completion: nil)
        }
        
        let cancelButton = CancelButton(title: "CANCEL") {
            return
        }
        
        popup.addButtons([incomeButton, expenseButton, cancelButton])
        self.present(popup, animated: true, completion: nil)

    }

    // MARK: - View did load / appear
    override func viewDidLoad(){
        super.viewDidLoad()
        retrieveIncome()
        retrieveExpenses()
        setTotalLabels(income: getTotalIncome(), expenses: getTotalExpenses(), difference: getTrueTotal())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        retrieveIncome()
        retrieveExpenses()
        setTotalLabels(income: getTotalIncome(), expenses: getTotalExpenses(), difference: getTrueTotal())
    }

    // Send the data to the next view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "editValue") {
            let secondViewController = segue.destination as! EditExpensesViewController
            
            if send_array_inc.isEmpty {
                secondViewController.send_array_exp = send_array_exp
            } else if send_array_exp.isEmpty {
                secondViewController.send_array_inc = send_array_inc
            }
        }
    }
    
    // Retrieve expenses from Core Datas
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
    
    // Retrieve expenses from Core Datas
    func retrieveIncome(){
        let fetchRequest: NSFetchRequest<Income> = Income.fetchRequest()
        do {
            let incomes = try PersistenceService.context.fetch(fetchRequest)
            self.income_array = incomes
            self.tableView.reloadData()
            
        } catch  {
            print(error.localizedDescription )
        }
    }

    // Calculate the total for all the expenses
    func getTotalExpenses() -> String {
        
        var total = 0.0
        for result in expenses_array {
            if let cost = Double(result.amount!) {
                total += cost
            } else {
                print("Error, not a Double: \(result.amount!)")
            }
        }
        return String(total)
    }
    
    // Calculate the total for all the income
    func getTotalIncome() -> String {
        
        var total = 0.0
        for result in income_array {
            if let income = Double(result.amount!) {
                total += income
            } else {
                print("Error, not a Double: \(result.amount!)")
            }
        }
        return String(total)
    }
    
    // Calculate the difference in totals between the expenses and income
    func getTrueTotal() -> String {
        let income = Double(getTotalIncome())
        let expenses = Double(getTotalExpenses())
        return String(income! - expenses!)
    }
    
    // Set total labels
    func setTotalLabels(income: String, expenses: String, difference: String){
        incomeTotalLabel.text = "Total Income: " + income
        expensesTotalLabel.text = "Total Expenses: " + expenses
        totalLabel.text = "Total: " + difference
    }
    
    // Set individual total label
    func setLabel(number: Int, value: String){
        switch number {
        case 1:
            incomeTotalLabel.text = "Total Income: " + value
        case 2:
            expensesTotalLabel.text = "Total Expenses: " + value
        case 3:
            totalLabel.text = "Total: " + value
        default:
            totalLabel.text = "Total: " + value
        }
    }
}

extension ExpensesViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: -  Table View Functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView( _ tableView : UITableView,  titleForHeaderInSection section: Int)->String? {
        var headername = "Header"
        
        if section == 0 {
            headername = "Income"
        } else if section == 1 {
            headername = "Expenses"
        }
        return headername
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowCount = 0
        if section == 0 {
            rowCount = income_array.count
        } else if section == 1 {
            rowCount = expenses_array.count
        }
        return rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
            cell.textLabel?.text = income_array[indexPath.row].name
            cell.detailTextLabel?.text = income_array[indexPath.row].amount
            return cell
        } else if indexPath.section == 1 {
            let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
            cell.textLabel?.text = expenses_array[indexPath.row].name
            cell.detailTextLabel?.text = expenses_array[indexPath.row].amount
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            
            if indexPath.section == 0 {
                let fetchRequest: NSFetchRequest<Income> = Income.fetchRequest()
                do {
                    let result = try PersistenceService.context.fetch(fetchRequest)
                    
                    // Delete from Core Data and remove from the arrays then save
                    if result.contains(income_array[indexPath.row]){
                        PersistenceService.context.delete(income_array[indexPath.row])
                        income_array = income_array.filter { $0 != income_array[indexPath.row] }
                        PersistenceService.saveContext()
                        self.setLabel(number: 1, value: getTotalIncome())
                        self.tableView.reloadData()
                    }
                } catch  {
                    print(error.localizedDescription )
                }
            } else if indexPath.section == 1 {
                let fetchRequest: NSFetchRequest<Expenses> = Expenses.fetchRequest()
                do {
                    let result = try PersistenceService.context.fetch(fetchRequest)
                    
                    // Delete from Core Data and remove from the arrays then save
                    if result.contains(expenses_array[indexPath.row]){
                        PersistenceService.context.delete(expenses_array[indexPath.row])
                        expenses_array = expenses_array.filter { $0 != expenses_array[indexPath.row] }
                        PersistenceService.saveContext()
                        self.setLabel(number: 2, value: getTotalExpenses())
                        self.tableView.reloadData()
                    }
                    
                } catch  {
                    print(error.localizedDescription )
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            send_array_inc = [self.income_array[indexPath.row]]
            self.performSegue(withIdentifier: "editValue", sender: self)
        } else if indexPath.section == 1 {
            send_array_exp = [self.expenses_array[indexPath.row]]
            self.performSegue(withIdentifier: "editValue", sender: self)
        }
    }
    
}

