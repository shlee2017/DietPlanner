//
//  DietMeal.swift
//  DietMealPlannerApp
//
//  Created by Sangheon Lee on 1/5/19.
//  Copyright © 2019 Ethan Lee. All rights reserved.
//

import UIKit
import os.log

class DietMeal: NSObject {
    //MARK: Properties
    
    var name: String = "Diet Plan"
    var output: String = "Meal Plan:\n"
    var food: [String] = ["Chicken Breast", "Brown Rice", "Brocoli", "Avocado", "Eggs", "Salmon", "Banana"]
    var Protein: Double
    var Carbs: Double
    var Fat: Double
    var matrix: [[Double]] = [
        //breast Brice  broc   avo   egg   sal  bana
        [120,  111,    34,   234,   78,   177, 105, 0,0,0,0,0,     0],
        [26,   2.6,    2.8,  2.9,     6,   17, 1.3, 1,0,0,0,0,   160],
        [0,    23,      7,    12,   0.6,    0, 27,  0,1,0,0,0,   120],
        [1,    0.9,    0.4,   21,     5,   11, 0.4, 0,0,1,0,0,    50],
        [1,    0.2,    0.1,  3.1,   1.6,  2.6, 0.1, 0,0,0,1,0, 16.67],
        [0,    0.6,    0.1, 16.7,   2.7,  6.5, 0.1, 0,0,0,0,1, 33.33]
    ]
    
    
    //MARK: Init
    init?(name: String, Protein: Double, Carbs: Double, Fat: Double) {
        // None of the macros can be negative
        guard (Protein >= 0) && (Carbs >= 0) && (Fat >= 0) else {
            return nil
        }
        
        if Protein < 0 || Carbs < 0 || Fat < 0 {
            return nil
        }
        
        self.name = name
        self.Protein = Protein
        self.Carbs = Carbs
        self.Fat = Fat
        let length = matrix[0].count
        matrix[1][length - 1] = Protein
        matrix[2][length - 1] = Carbs
        matrix[3][length - 1] = Fat
        matrix[4][length - 1] = Fat / 3.0
        matrix[5][length - 1] = Fat * 2 / 3
    }
    
    func isOptimal() -> Bool {
        //checks the if there are any coefficients that are greater than 0
        //to see if the matrix needs to be further optimized or not
        for item in matrix[0] {
            if item > 0.0 {
                return false
            }
        }
        return true
    }
    
    func rowReduce(row: Int, col: Int) {
        var coEff: Double = matrix[row][col]
        for i in 0..<matrix[row].count {
            matrix[row][i] /= coEff
        }
        for i in 0..<matrix.count {
            if(i != row) {
                coEff = matrix[i][col]
                for k in 0..<matrix[row].count {
                    matrix[i][k] -= coEff * matrix[row][k]
                }
            }
        }
    }
    
    func findPivot() {
        var col: Int = 0
        for i in 1..<matrix[0].count {
            if matrix[0][i] > matrix[0][col] {
                col = i
            }
        }
        var row: Int = 1
        var min: Double = abs(matrix[row].last! / matrix[row][col])
        for i in 2..<matrix.count {
            if matrix[i][col] > 0.0 {
                if(abs(matrix[i].last! / matrix[i][col]) < min){
                    row = i
                    min = abs(matrix[i].last! / matrix[i][col])
                }
            }
        }
        rowReduce(row: row, col: col)
    }
    
    func calc() {
        while(!isOptimal()){
            findPivot()
        }
        mealPlan()
    }
    
    func mealPlan(){
        for i in 1..<matrix.count {
            for k in 0..<matrix[i].count - matrix.count {
                if matrix[i][k] == 1.0 && matrix[i].last! >= 0.01 {
                    output += "\(Double(round(matrix[i].last!*1000)/1000)) serving size of \(food[k])\n"
                    break
                }
            }
        }
    }
    
    func getOutput() -> String {
        return output
    }
}
