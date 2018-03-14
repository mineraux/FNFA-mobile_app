//
//  aboutController.swift
//  FNFA
//
//  Created by MINERVINI Robin on 14/03/2018.
//  Copyright © 2018 MINERVINI Robin. All rights reserved.
//

import UIKit

class aboutController: UITableViewController {

    @IBOutlet weak var containerIntro: UIView!
    @IBOutlet weak var containerRestauration: UIView!
    @IBOutlet weak var containerGoToWebSite: UIView!
    
    @IBOutlet weak var square: UIView!
    @IBOutlet weak var square2: UIView!
    @IBOutlet weak var square3: UIView!
    @IBOutlet weak var square4: UIView!
    @IBOutlet weak var square5: UIView!
    @IBOutlet weak var square6: UIView!
    @IBOutlet weak var square7: UIView!
    @IBOutlet weak var square8: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        containerIntro.layer.cornerRadius = 6
        containerIntro.layer.masksToBounds = true
        
        containerRestauration.layer.cornerRadius = 6
        containerRestauration.layer.masksToBounds = true
        
        containerGoToWebSite.layer.cornerRadius = 6
        containerGoToWebSite.layer.masksToBounds = true
        
        square.layer.cornerRadius = 4
        square2.layer.cornerRadius = 4
        square3.layer.cornerRadius = 4
        square4.layer.cornerRadius = 4
        square5.layer.cornerRadius = 4
        square6.layer.cornerRadius = 4
        square7.layer.cornerRadius = 4
        square8.layer.cornerRadius = 4
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
    @IBAction func goToWebSite(_ sender: Any) {
        if let url = URL(string: "https://www.afca.asso.fr/") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
}
