//
//  MealViewController.swift
//  FoodTracker
//
//  Created by zxx_iMac on 2018/3/29.
//  Copyright © 2018年 zxx_mbp. All rights reserved.
//

import UIKit
import os.log

class MealViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    //MARK:Properties
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    /*
     This value is either passed by `MealTableViewController` in `prepare(for: sender:)`
     or constructed as part of adding a new meal
     */
    var meal:Meal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // handle the text field's user input throught delegate callbacks
        self.nameTextField.delegate = self;
        
        // Set up views while editing an existing meal
        if let meal = meal {
            photoImageView.image = meal.image
            nameTextField.text = meal.name
            ratingControl.rating = meal.rating
            title = meal.name
        }
        
        // Enable save button only when the name textfield has a valid meal name
        updateSaveButtonState()
    }
    //MARK:UITextfieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //Disable the save button while editing
         self.saveButton.isEnabled = false
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //hide the keysbord
        self.nameTextField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    //MARK:Navigation
    //This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        //Configuration the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log:OSLog.default,type:.debug)
            return
        }
        
        if 2 > 1, 3 < 5 {
            print("test if statment conditions patern")
        }
        
        let name = nameTextField.text ?? ""
        let image = photoImageView.image
        let rating = ratingControl.rating
        
        // Set the meal to be passed the MealTableViewController after the unwind segue.
        meal = Meal.init(name: name, rating: rating, image: image)
    }
    
    //MARK:Actions

    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal of push presentation), this view controller needs to be dismissed in two different way
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            
            dismiss(animated: true, completion: nil)
        }else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        }else {
            fatalError("The MealViewController is not inside in a NavigationController ")
        }
    }
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        // dismiss the keyboard
        self.nameTextField.resignFirstResponder()
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self;
        present(imagePickerController, animated: true, completion: nil)
    }

    //MARK:UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("expected a dictionary containing an image,but was provided the info:\(info)")
        }
        self.photoImageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }

    //MARK:Private methods
    func updateSaveButtonState() {
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
}

