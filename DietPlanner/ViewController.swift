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
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    var dietMeal: DietMeal?

    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Handle the text field’s user input through delegate callbacks.
        nameTextField.delegate = self
        
        if let dietMeal = dietMeal {
            navigationItem.title = dietMeal.name
            nameTextField.text = dietMeal.name
            proteinTextField.text = String(dietMeal.Protein)
            carbTextField.text = String(dietMeal.Carbs)
            fatTextField.text = String(dietMeal.Fat)
            outputTextField.text = dietMeal.output
        }
        
        // Enable the Save button only if the text field has a valid Meal name.
        updateSaveButtonState()
        
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    //MARK: Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = nameTextField.text ?? ""
        let Protein: Double? = Double(proteinTextField.text!)
        let Carbs: Double? = Double(carbTextField.text!)
        let Fat: Double? = Double(fatTextField.text!)
        
        // Set the meal to be passed to MealTableViewController after the unwind segue.
        dietMeal = DietMeal(name: name, Protein: Protein!, Carbs: Carbs!, Fat: Fat!)
        dietMeal?.calc()
    }
    

    //MARK: Action
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
            outputTextField.text = "Meal Plan:"
        }
    }
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        
    }
    
    //MARK: Private Methods
    
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
}
