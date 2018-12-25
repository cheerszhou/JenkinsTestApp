//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by zxx_mbp on 2018/4/1.
//  Copyright © 2018年 zxx_mbp. All rights reserved.
//

import UIKit
import os.log


class MealTableViewController: UITableViewController {
    
    //MARK:Properties
    var meals:[Meal] = [Meal]()

    override func viewDidLoad() {
        super.viewDidLoad()
        //Use the edit button item provided by the table view controller
        navigationItem.leftBarButtonItem = editButtonItem
        
        //Load any saved meals, otherwise load sample data
        if let meals = loadMeals() {
            self.meals += meals
        }else {
            //Load smaple meals
            loadSampleMealData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return meals.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "MealTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MealTableViewCell else {
            fatalError("The dequeue cell is not a instance of MealTableViewCell.")
        }

        // fetches the appropriate meal for the data source layout
        let meal = meals[indexPath.row]
        
        cell.photoImageView.image = meal.image
        cell.nameLabel.text = meal.name
        cell.ratingControl.rating = meal.rating

        return cell
    }
 

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
 

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            meals.remove(at: indexPath.row)
            //Save the meals
            saveMeals()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch segue.identifier ?? "" {
        case "AddItem":
            os_log("Adding a new meal", log: OSLog.default, type: .debug)
        case "ShowDetail":
            guard let mealDetailController = segue.destination as? MealViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedMealCell = sender as? MealTableViewCell else {
                fatalError("Unexpected sender:\(String(describing: sender))")
            }
            guard let indexPath = tableView.indexPath(for: selectedMealCell),indexPath.row < meals.count else {
                fatalError("The selected cell is not being displayed by the table")
            }
            let selectedMeal = meals[indexPath.row]
            mealDetailController.meal = selectedMeal
            
        default:
            fatalError("Unexpected segue identifier;\(String(describing: segue.identifier))")
        }
    }
    
    
    //MARK:Actions
    @IBAction func unwindToMealList(sender:UIStoryboardSegue) {
        if let sourceViewController = sender.source as? MealViewController, let meal = sourceViewController.meal {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing meal
                meals[selectedIndexPath.row] = meal
                self.tableView.reloadRows(at: [selectedIndexPath], with: UITableViewRowAnimation.none)
            }else {
                
                // Add a new meal
                let newIndexPath = IndexPath(row: meals.count, section: 0)
                
                meals.append(meal)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            //save the meals
            saveMeals()
        }
    }
    
    //MARK:Private method
    private func loadSampleMealData() {
        // Load Images
        let mealImage1 = UIImage(named: "Meal1")
        let mealImage2 = UIImage(named: "Meal2")
        let mealImage3 = UIImage(named: "Meal3")
        
        guard let meal1 = Meal.init(name: "Caprese Salad", rating: 4, image: mealImage1)else {
            fatalError("Unable to intantiate meal1")
        }
        
        guard let meal2 = Meal.init(name: "Chicken and Potatoes", rating: 5, image: mealImage2)else {
            fatalError("Unable to intantiate meal2")
        }
        
        guard let meal3 = Meal.init(name: "Pasta with Meatballs", rating: 3, image: mealImage3)else {
            fatalError("Unable to intentiate meal3")
        }   
        
        meals += [meal1,meal2,meal3];
    }
    
    private func saveMeals() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: Meal.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
        }else {
            os_log("Meals save failed", log: OSLog.default, type: .error)
        }
    }
    
    private func loadMeals() -> [Meal]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Meal.ArchiveURL.path) as? [Meal]
    }

}
