//
//  ViewController.swift
//  RecipeBox
//
//  Created by Danny Walker on 10/16/20.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var ingredient1: UITextField!
    @IBOutlet weak var ingredient2: UITextField!
    @IBOutlet weak var ingredient3: UITextField!
    @IBOutlet weak var instructions: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
       
    @IBAction func btnSave(_ sender: UIButton) {
    
        //1 Add Save Logic
        if (recipedb != nil) {
            recipedb.setValue(name.text, forKey: "name")
            recipedb.setValue(ingredient1.text, forKey: "ingredient1")
            recipedb.setValue(ingredient2.text, forKey: "ingredient2")
            recipedb.setValue(ingredient3.text, forKey: "ingredient3")
            recipedb.setValue(instructions.text, forKey: "instructions")
        }
        
        else {
            let entityDescription =
                NSEntityDescription.entity(forEntityName: "Recipe",in: managedObjectContext)
            let recipe = Recipe(entity: entityDescription!,
                                  insertInto: managedObjectContext)
            recipe.name = name.text!
            recipe.ingredient1 = ingredient1.text!
            recipe.ingredient2 = ingredient2.text!
            recipe.ingredient3 = ingredient3.text!
            recipe.instructions = instructions.text!
        }
        
        var error: NSError?
        do {
            try managedObjectContext.save()
        }
        
        catch let error1 as NSError {
            error = error1
        }
        
        if let err = error {
            //if error occurs
           // status.text = err.localizedFailureReason
        }
        
        else {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func btnEdit(_ sender: UIButton) {
    
        //Edit recipe
        name.isEnabled = true
        ingredient1.isEnabled = true
        ingredient2.isEnabled = true
        ingredient3.isEnabled = true
        instructions.isEnabled = true
        btnSave.isHidden = false
        btnEdit.isHidden = true
        name.becomeFirstResponder()
    }
    
    @IBAction func btnBack(_ sender: UIBarButtonItem) {
    
        //Dismiss ViewController
        self.dismiss(animated: true, completion: nil)
        //let detailVC = ContactTableViewController()
        //detailVC.modalPresentationStyle = .fullScreen
        //present(detailVC, animated: false)
    }
    
    //Add ManagedObject Data Context
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    //Add variable contactdb (used from UITableView
    var recipedb:NSManagedObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //Add logic to load db. If contactdb has content that means a row was tapped on UiTableView
        if (recipedb != nil) {
            name.text = recipedb.value(forKey: "name") as? String
            ingredient1.text = recipedb.value(forKey: "ingredient1") as? String
            ingredient2.text = recipedb.value(forKey: "ingredient2") as? String
            ingredient3.text = recipedb.value(forKey: "ingredient3") as? String
            instructions.text = recipedb.value(forKey: "instructions") as? String
            btnSave.setTitle("Update", for: UIControl.State())
            btnEdit.isHidden = false
            name.isEnabled = false
            ingredient1.isEnabled = false
            ingredient2.isEnabled = false
            ingredient3.isEnabled = false
            instructions.isEnabled = false
            btnSave.isHidden = true
        }
        
        else {
            btnEdit.isHidden = true
            name.isEnabled = true
            ingredient1.isEnabled = true
            ingredient2.isEnabled = true
            ingredient3.isEnabled = true
            instructions.isEnabled = true
        }
        
        name.becomeFirstResponder()
        // Do any additional setup after loading the view.
        //Looks for single or multiple taps
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.DismissKeyboard))
        //Adds tap gesture to view
        view.addGestureRecognizer(tap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //Add to hide keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches , with:event)
        if (touches.first as UITouch?) != nil {
            DismissKeyboard()
        }
    }

    //Add to hide keyboard
    @objc func DismissKeyboard(){
        //forces resign first responder and hides keyboard
        name.endEditing(true)
        ingredient1.endEditing(true)
        ingredient2.endEditing(true)
        ingredient3.endEditing(true)
        instructions.endEditing(true)
    }
    
    //Add to hide keyboard
    func textFieldShouldReturn(_ textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        return true;
    }       
}

