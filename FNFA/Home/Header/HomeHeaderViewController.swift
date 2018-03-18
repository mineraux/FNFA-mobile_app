//
//  HomeHeaderViewController.swift
//  FNFA
//
//  Created by MASSE Alexandre on 12/03/2018.
//  Copyright © 2018 MINERVINI Robin. All rights reserved.
//

import UIKit

class HomeHeaderViewController: UIViewController {

    @IBOutlet var imageContainer: UIView!
    @IBOutlet weak var headerImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        headerImage.image = UIImage(named:"intro-logo")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
