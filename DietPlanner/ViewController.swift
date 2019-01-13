//
//  ViewController.swift
//  DietPlanner
//
//  Created by Sangheon Lee on 1/9/19.
//  Copyright © 2019 Ethan Lee. All rights reserved.
//

import UIKit
import os.log

class ViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var proteinTextField: UITextField!
    @IBOutlet weak var carbTextField: UITextField!
    @IBOutlet weak var fatTextField: UITextField!
    @IBOutlet weak var outputTextField: UITextView!
    
    var dietMeal: DietMeal?

    override func viewDidLoad() {
        super.viewDidLoad()
       
        nameTextField.delegate = self
        
    }

    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        navigationItem.title = textField.text
    }

    @IBAction func calcButton(_ sender: UIButton) {
        if !(proteinTextField.text?.isEmpty)! && !(carbTextField.text?.isEmpty)! && !(fatTextField.text?.isEmpty)! {
            let name = nameTextField.text ?? ""
            let Protein: Double? = Double(proteinTextField.text!)
            let Carbs: Double? = Double(carbTextField.text!)
            let Fat: Double? = Double(fatTextField.text!)
            
            // Set the diet meal to be passed to DietMealTableViewController after the unwind segue.
            dietMeal = DietMeal(name: name, Protein: Protein!, Carbs: Carbs!, Fat: Fat!)
            dietMeal?.calc()
            let output = dietMeal!.getOutput()
            outputTextField.text = output
        }
        else {
            outputTextField.text = ""
        }
    }
    
}
