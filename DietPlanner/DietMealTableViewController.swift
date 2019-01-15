//
//  DietMealTableViewController.swift
//  DietPlanner
//
//  Created by Sangheon Lee on 1/13/19.
//  Copyright © 2019 Ethan Lee. All rights reserved.
//

import UIKit
import os.log

class DietMealTableViewController: UITableViewController {

    //MARKS: Properties
    var mealPlans = [DietMeal]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        if let savedMealPlans = loadMealPlans() {
            mealPlans += savedMealPlans
        }
        else {
            loadSampleMealPlans()
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return mealPlans.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "DietMealTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? DietMealTableViewCell else {
            fatalError("The dequeued cell is not an instance of DietMealTableViewCell.")
        }
        cell.setMealPlan(mealPlan: mealPlans[indexPath.row])
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            mealPlans.remove(at: indexPath.row)
            saveMealPlans()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "AddItem":
            os_log("Adding a new meal.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let dietDetailViewController = segue.destination as? ViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedDietCell = sender as? DietMealTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedDietCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedDiet = mealPlans[indexPath.row]
            dietDetailViewController.dietMeal = selectedDiet
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
    
    //MARK: Action
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ViewController, let diet = sourceViewController.dietMeal {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing meal.
                mealPlans[selectedIndexPath.row] = diet
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else{
                // Add a new meal plan.
                let newIndexPath = IndexPath(row: mealPlans.count, section: 0)
                
                mealPlans.append(diet)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
        
        saveMealPlans()
    }
    
    //MARK: Private
    private func loadSampleMealPlans() {
        let mealPlan1 = DietMeal(name: "Bulk", Protein: 120, Carbs: 250, Fat: 50)
        let mealPlan2 = DietMeal(name: "Lean Bulk", Protein: 160, Carbs: 150, Fat: 50)
        let mealPlan3 = DietMeal(name: "Mine", Protein: 160, Carbs: 120, Fat: 50)
        mealPlans.append(mealPlan1!)
        mealPlans.append(mealPlan2!)
        mealPlans.append(mealPlan3!)
    }
    
    private func saveMealPlans() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(mealPlans, toFile: DietMeal.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save meals...", log: OSLog.default, type: .error)
        }
    }
    private func loadMealPlans() -> [DietMeal]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: DietMeal.ArchiveURL.path) as? [DietMeal]
    }
}



/*
 // Override to support conditional editing of the table view.
 override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
 // Return false if you do not want the specified item to be editable.
 return true
 }
 */

/*
 
 */

/*
 // Override to support rearranging the table view.
 override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
 
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
 // Return false if you do not want the item to be re-orderable.
 return true
 }
 */
