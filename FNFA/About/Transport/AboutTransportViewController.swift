//
//  AboutTransportViewController.swift
//  FNFA
//
//  Created by MASSE Alexandre on 16/03/2018.
//  Copyright © 2018 MINERVINI Robin. All rights reserved.
//

import UIKit

class AboutTransportViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var modelController: ModelController?
    var transports = [NSMutableDictionary]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        modelController = appDelegate.modelController
        
        transports = (modelController?.transports)!
        
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
        return transports.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let transportCell = collectionView.dequeueReusableCell(withReuseIdentifier: "transportCell", for: indexPath) as! AboutTransportCollectionViewCell
        
        let transportDict = transports[indexPath.row]
        
        //city
        transportCell.city.text = (transportDict["city"] as? String)?.uppercased()
        
        //icon
        transportCell.locationIcon.image = UIImage(named:"location")
        
        //place
        transportCell.place.text = transportDict["place"] as? String
        
        //address
        transportCell.address.text = transportDict["address"] as? String
        
        //phone
        transportCell.phone.text = transportDict["phone"] as? String
        
        //busStop
        transportCell.busStop.text = transportDict["busStop"] as? String
        
        //metroStop
        transportCell.metroStop.text = transportDict["metroStop"] as? String
        
        //TRansport Icon
        let iconArray = (transportDict["logos"] as! NSArray)
        let totalIcon = iconArray.count
        let outletIconArray = [
            transportCell.transportIcon1,
            transportCell.transportIcon2,
            transportCell.transportIcon3,
            transportCell.transportIcon4,
            transportCell.transportIcon5,
        ]
        for i in 0...(totalIcon - 1) {
            outletIconArray[i]?.image = UIImage(named:(iconArray[i] as? String)!)
        }
        
        transportCell.layer.cornerRadius = 6
        
        
        return transportCell
    }

}
