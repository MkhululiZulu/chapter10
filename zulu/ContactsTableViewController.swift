//
//  ContactsTableViewController.swift
//  zulu
//
//  Created by MkhululiZulu on 11/27/17.
//  Copyright © 2017 MkhululiZulu. All rights reserved.
//

import UIKit
import CoreData


class ContactsTableViewController: UITableViewController{
    let contacts = ["Jim", "John", "Dana", "Rosie", "Justin", "Jeremy",
                   "Sarah", "Matt", "Joe", "Donald", "Jeff"]
    
    var contacts:[NSManagedObject] = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    

    override func viewDidLoad() {
                super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        //loadDataFromDatabase()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func viewWillAppear(_ animated: Bool){
    loadDataFromDatabase()
    tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadDataFromDatabase()
    {
        // Read settings to enable sorting 
        let settings = UserDefaults.standard
        let sortField = settings.string(forKey: Constants.kSortField)
        let sortAscending = settings.bool(forKey: Constants.kSortDirectionAscending)
        // set up Core data Context 
        
        let context = appDelegate.persistentContainer.viewContext
        // set up Request
        let request = NSFetchRequest<NSManagedObject>(entityName: "Contact")
        // specify sorting 
        let sortDescriptor = NSSortDescriptor(key: sortField, ascending: sortAscending)
        let sortDescriptorArray = [sortDescriptor ]
        // to sort by multiple fields, add more descriptors to the array 
        request.sortDescriptors = sortDescriptorArray
        //Execute request 
        
        do{
            contacts = try context.fetch(request)
        }
        catch let error as NSError{
        print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return contacts.count
    }

    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = contacts [indexPath.row] as? Contact
        cell.textLabel?.text = contacts?.contactName
        cell.detailText?.text = contacts?.city
        
        cell.accessoryType = UITableViewCellAccessoryType.detailDisclosureButton
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
        // delete the row from the data source 
            let contact = contacts[indexPath] as? Contact
            let context = appDelegate.persistentContainer.viewContext
            context.delete(contact)
            
            do{
                try context.save()
            }
            catch {fatalError("Error saving context: \(error)")
        }
        loadDataFromDatabase()
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    else if editingStyle == .insert{
    //create a new instance of thr appropriate class, insert it into the arry 
    // and add a new row to the table
    }
    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectContact = contacts [indexPath.row] as? Contact
        let name = selectContact!.contactName!
        let actionHandler = { (action:UIAlertAction!) -> Void in
            self.performSegue(withIdentifier: "EditContact", sender: tableView.cellForRow(at: indexPath))
    }
        let alertController = UIAlertController(title: "Contact selected ", message: "Selected row: \(indexPath.row) (\(name)", preferredStyle: .alert)
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let actionDetails = UIAlertAction(title: "Show Details", style: .default, handler: actionHandler
        )
        
        alertController.addAction(actionCancel)
        alertController.addAction(actionDetails)
        present(alertController, animated: true, completion:  nil)
    }
    
    func prepare (for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditContact"{
        let contactController = segue.destination as? ContactsViewController
            let selectedRow = self.tableView.indexPath(for: sender as! UITableViewCell)?.row
        let selectedContact = contacts[selectedRow!] as! Contact
        contactController?.currentContact  = selectedContact
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
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
