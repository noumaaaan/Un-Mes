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
 
    var send_array = [Expenses]() // Defined from the previous view controller
    
    // storyboard outlets
    @IBOutlet weak var expenseNameTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        print(send_array)
        
    }
    
}
