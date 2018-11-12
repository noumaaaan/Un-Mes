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
    
    var expensesNameArray:[String] = []
    var amountArray:[String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        // Save Core Data
//        let newExpense = NSEntityDescription.insertNewObject(forEntityName: "Expenses", into: context)
//
//        newExpense.setValue("Gym", forKey: "name")
//        newExpense.setValue("35", forKey: "amount")
//
//        do {
//            try context.save()
//            print("SAVED")
//        } catch  {
//
//        }
        
        // Retrieve Core Data
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Expenses")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            
            if results.count > 0 {
                for result in results as! [NSManagedObject]{
                    if let name = result.value(forKey: "name") as? String {
                        expensesNameArray.append(name)
                    }
                    if let amount = result.value(forKey: "amount") as? String {
                        amountArray.append(amount)
                    }
                    
                    print(expensesNameArray)
                    print(amountArray)
                    
                }
            }
        } catch {
            
        }
        
    }
    
}

