//
//  AboutTransportViewController.swift
//  FNFA
//
//  Created by MASSE Alexandre on 16/03/2018.
//  Copyright © 2018 MINERVINI Robin. All rights reserved.
//

import UIKit

class AboutTransportViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
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
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let transportCell = collectionView.dequeueReusableCell(withReuseIdentifier: "transportCell", for: indexPath) as! AboutTransportCollectionViewCell
        
        // transportCell.labelTest.text = "yolo"
        
        
        return transportCell
    }

}
