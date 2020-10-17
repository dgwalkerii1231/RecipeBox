//
//  RecipeTableViewController.swift
//  RecipeBox
//
//  Created by Danny Walker on 10/16/20.
//

import UIKit
import CoreData
import Foundation

//Add delegates
class RecipeTableViewController: UITableViewController,UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate {
    
    //Add filter search vars
    var filteredTableData = [NSManagedObject]()
    var resultSearchController = UISearchController()
    var recipeArray = [NSManagedObject]()

    //Add UISearch func
    func updateSearchResults(for searchController: UISearchController)
    {
        filteredTableData.removeAll(keepingCapacity: false)
        //search for field in CoreData
        let searchPredicate = NSPredicate(format: "name CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (recipeArray as NSArray).filtered(using: searchPredicate)
        filteredTableData = array as! [NSManagedObject]
        
        self.tableView.reloadData()
    }

    //Add viewDidAppear (loads whenever view appears)
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loaddb()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loaddb()
    }

    //Add func loaddb to load database and refresh table
    func loaddb() {
        let managedContext = (UIApplication.shared.delegate
            as! AppDelegate).persistentContainer.viewContext
        
        //let fetchRequest = NSFetchRequest(entityName:"Contact")
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Recipe")
        
        do {
            let fetchedResults = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if let results = fetchedResults {
                recipeArray = results
                tableView.reloadData()
            }
            
            else {
                print("Could not fetch")
            }
            
        }
        
        catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription),\(error.userInfo)")
        }
    }

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add Search Delegates
        self.resultSearchController.delegate = self
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.delegate = self
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            controller.searchBar.delegate = self
            self.tableView.tableHeaderView = controller.searchBar
            return controller
        })()
    }

    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        //7) Change to return 1
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //8) Change to return contactArray.count
        if (self.resultSearchController.isActive) {
            return filteredTableData.count
        }
        
        else {
            return recipeArray.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Change below to load rows
        if (self.resultSearchController.isActive) {
            let cell =
                tableView.dequeueReusableCell(withIdentifier: "Cell")
                    as UITableViewCell?
            let person = filteredTableData[(indexPath as NSIndexPath).row]
            cell?.textLabel?.text = person.value(forKey: "name") as! String?
            cell?.detailTextLabel?.text = ">>"
            return cell!
            
        }
        else {
            let cell =
                tableView.dequeueReusableCell(withIdentifier: "Cell")
                    as UITableViewCell?
            let person = recipeArray[(indexPath as NSIndexPath).row]
            cell?.textLabel?.text = person.value(forKey: "name") as! String?
            cell?.detailTextLabel?.text = ">>"
            return cell!
        }
    }
    
    //Add func tableView to show row clicked
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\((indexPath as NSIndexPath).row)")
    }
 
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //Change to delete swiped row
        if editingStyle == .delete {
            let context = (UIApplication.shared.delegate
                as! AppDelegate).persistentContainer.viewContext
            
            if (self.resultSearchController.isActive) {
                context.delete(filteredTableData[(indexPath as NSIndexPath).row])
            }
            
            else {
                context.delete(recipeArray[(indexPath as NSIndexPath).row])
            }
            
            var error: NSError? = nil
            
            do {
                try context.save()
                loaddb()
            }
            catch let error1 as NSError {
                error = error1
                print("Unresolved error \(String(describing: error))")
                abort()
            }
        }

    }
    

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        //13) Uncomment & Change to go to proper record on proper Viewcontroller
        if segue.identifier == "UpdateRecipe" {
            if let destination = segue.destination as?
                ViewController {
                if (self.resultSearchController.isActive) {
                    if let SelectIndex = (tableView.indexPathForSelectedRow as NSIndexPath?)?.row {
                        let selectedDevice:NSManagedObject = filteredTableData[SelectIndex] as NSManagedObject
                        destination.recipedb = selectedDevice
                        resultSearchController.isActive = false
                    }
                }
                
                else {
                    if let SelectIndex = (tableView.indexPathForSelectedRow as NSIndexPath?)?.row {
                        let selectedDevice:NSManagedObject = recipeArray[SelectIndex] as NSManagedObject
                        destination.recipedb = selectedDevice
                    }
                }
            }
        }
    }
}
