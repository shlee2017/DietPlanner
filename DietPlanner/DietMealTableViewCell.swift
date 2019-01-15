//
//  DietMealTableViewCell.swift
//  DietPlanner
//
//  Created by Sangheon Lee on 1/13/19.
//  Copyright © 2019 Ethan Lee. All rights reserved.
//

import UIKit

class DietMealTableViewCell: UITableViewCell {
    
    //MARKS: Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var carbLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    
    
    func setMealPlan(mealPlan: DietMeal){
        nameLabel.text = mealPlan.name
        proteinLabel.text = String(mealPlan.Protein)
        carbLabel.text = String(mealPlan.Carbs)
        fatLabel.text = String(mealPlan.Fat)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
