//
//  ListTableViewController.swift
//  MedicalAlarm
//
//  Created by Crescenzo Garofalo on 27/11/17.
//  Copyright © 2017 Crescenzo Garofalo. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {

    
    var appDelegate : AppDelegate?
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        DatabaseManager.sharedInstance?.load()
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        self.appDelegate = appDelegate
        
        DatabaseManager.initInstance(appDelegate: appDelegate)
        
        DatabaseManager.sharedInstance?.listController = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToInserUser(sender: UIStoryboardSegue) {
    
        if let sourceViewController = sender.source as? DetailUserViewController {

            DatabaseManager.sharedInstance?.load()
            
            DatabaseManager.sharedInstance?.listController?.tableView.reloadData()

        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return DatabaseManager.sharedInstance!.users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let personCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PersonCellTableViewCell
      
        personCell.personNameLabel.text! = DatabaseManager.sharedInstance!.users[indexPath.row].getName()!
        let hasPhoto = DatabaseManager.sharedInstance!.users[indexPath.row].getHasPhoto()
        var filePath = ""
        filePath = DatabaseManager.sharedInstance!.users[indexPath.row].getPhoto()!
        if hasPhoto {
            personCell.personImage.image = FilesManager.sharedInstance.loadImage(imageName: filePath)
        } else {
            personCell.personImage.image = UIImage(named: filePath)
        }
        
        personCell.personImage.setRounded()
        
        return personCell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let user = DatabaseManager.sharedInstance!.users[indexPath.row]
            DatabaseManager.sharedInstance?.delete(userModel: user)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "detail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                // estraiamo dal segue il DetailViewController
                let controller = segue.destination as! DetailUserViewController
            
                
                // gli passiamo l'istanza della pizza presa dall'array in base all'indice della cella toccata
                // in pratica se tocca la margherita passiamo al dettaglio la margherita
                controller.user = DatabaseManager.sharedInstance?.users[(indexPath as NSIndexPath).row]
            }
        }
            
    }
    

}
