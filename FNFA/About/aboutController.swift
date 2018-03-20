//
//  aboutController.swift
//  FNFA
//
//  Created by MINERVINI Robin on 14/03/2018.
//  Copyright © 2018 MINERVINI Robin. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class aboutController: UITableViewController, CLLocationManagerDelegate, MKMapViewDelegate {
   

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
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var linkRobin: UIButton!
    @IBOutlet weak var linkAlexandre: UIButton!
    @IBOutlet weak var linkElisa: UIButton!
    @IBOutlet weak var linkClementine: UIButton!
    @IBOutlet weak var linkCassandre: UIButton!
    @IBOutlet weak var textWithAsterisqueBefore: UILabel!
    @IBOutlet weak var textWithAsterisqueAfter: UILabel!
    
    let attributesUnderlinedButton : [NSAttributedStringKey: Any] = [NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Remove border botton on navigation bar
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        // Add background color for scroll bounce
        let bgView = UIView()
        bgView.backgroundColor = UIColor(named: "Green")
        self.tableView.backgroundView = bgView
        tableView.allowsSelection = false;
        containerIntro.layer.cornerRadius = 6
        containerIntro.layer.masksToBounds = true
        
        containerRestauration.layer.cornerRadius = 6
        containerRestauration.layer.masksToBounds = true
        
        containerGoToWebSite.layer.cornerRadius = 6
        containerGoToWebSite.layer.masksToBounds = true
        
        square.layer.cornerRadius = 6
        square2.layer.cornerRadius = 6
        square3.layer.cornerRadius = 6
        square4.layer.cornerRadius = 6
        square5.layer.cornerRadius = 6
        square6.layer.cornerRadius = 6
        square7.layer.cornerRadius = 6
        square8.layer.cornerRadius = 6
        
        //ASRERIX
        
        //Create Attachment
        let asterisqueBefore =  NSTextAttachment()
        asterisqueBefore.image = UIImage(named:"asterisque")
        //Set bound to reposition
        let asterisqueBeforeImageOffsetY:CGFloat = 2;
        asterisqueBefore.bounds = CGRect(x: 0, y: asterisqueBeforeImageOffsetY , width: 7, height: 7)
        //Create string with attachment
        let attachmentString = NSAttributedString(attachment: asterisqueBefore)
        //Initialize mutable string
        let asterisqueBeforeCompleteText = NSMutableAttributedString(string: "")
        //Add image to mutable string
        asterisqueBeforeCompleteText.append(attachmentString)
        //Add your text to mutable string
        let textAfterIcon = NSMutableAttributedString(string: " carnet de fidélité, tarif de groupe et carte abonné non acceptés")
        asterisqueBeforeCompleteText.append(textAfterIcon)
        textWithAsterisqueBefore.attributedText = asterisqueBeforeCompleteText;
        
        //Create Attachment
        let asterisqueAfter =  NSTextAttachment()
        asterisqueAfter.image = UIImage(named:"asterisque")
        //Set bound to reposition
        let asterisqueAfterImageOffsetY:CGFloat = 2;
        asterisqueAfter.bounds = CGRect(x: 0, y: asterisqueAfterImageOffsetY , width: 7, height: 7)
        //Create string with attachment
        let attachmentString2 = NSAttributedString(attachment: asterisqueAfter)
        //Initialize mutable string
        let asterisqueAfterCompleteText = NSMutableAttributedString(string: "")
        //Add image to mutable string
        asterisqueAfterCompleteText.append(attachmentString2)
        //Add your text to mutable string
        let textBeforeIcon = NSMutableAttributedString(string: "Ciné-concert ")
        asterisqueAfterCompleteText.insert(textBeforeIcon, at: 0)
        textWithAsterisqueAfter.attributedText = asterisqueAfterCompleteText;
        
        
        //MAP
        
    
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.layer.cornerRadius = 6
        locationManager.delegate = self
        
        let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15);
        let mapCenterView:CLLocationCoordinate2D = CLLocationCoordinate2DMake(48.117056, -1.678498)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(mapCenterView, span)
        mapView.setRegion(region, animated: true)
        
        addAnnotation(name: "TNB", latitute: 48.10796740000001, longitude: -1.6725616999999602)
        addAnnotation(name: "Arvor", latitute: 48.1159954, longitude: -1.6791138999999475)
        addAnnotation(name: "ESRA", latitute: 48.1288092, longitude: -1.6420402999999624)
        addAnnotation(name: "Grand Logis", latitute: 48.0231681, longitude: -1.7446339000000535)
        addAnnotation(name: "Esplanade Charles de Gaulles ", latitute: 48.1064896, longitude: -1.6767549999999574)
        
        let attributeStringRobin = NSMutableAttributedString(string: "http://robinminervini.fr", attributes: attributesUnderlinedButton)
        let attributeStringAlexandre = NSMutableAttributedString(string: "https://alexandremasse.fr", attributes: attributesUnderlinedButton)
        let attributeStringElisa = NSMutableAttributedString(string: "http://elisadubois.fr", attributes: attributesUnderlinedButton)
        let attributeStringClementine = NSMutableAttributedString(string: "http://clementinespinel.com", attributes: attributesUnderlinedButton)
        let attributeStringCassandre = NSMutableAttributedString(string: "http://cargocollective.com/cassandrely", attributes: attributesUnderlinedButton)
        
        linkRobin.setAttributedTitle(attributeStringRobin, for: .normal)
        linkAlexandre.setAttributedTitle(attributeStringAlexandre, for: .normal)
        linkElisa.setAttributedTitle(attributeStringElisa, for: .normal)
        linkClementine.setAttributedTitle(attributeStringClementine, for: .normal)
        linkCassandre.setAttributedTitle(attributeStringCassandre, for: .normal)
    }
    
    func addAnnotation(name:String!, latitute:Double!, longitude:Double!) -> Void {
        let annotation = MKPointAnnotation()
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitute, longitude)
        annotation.coordinate = location
        annotation.title = name
        return mapView.addAnnotation(annotation)
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
        return 1
    }
    
    @IBAction func goToSiteRobin(_ sender: Any) {
        if let url = URL(string: "http://www.robinminervini.fr") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    @IBAction func goToTheWebsite(_ sender: Any) {
        if let url = URL(string: "http://www.festival-film-animation.fr") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    @IBAction func goToSiteAlexandre(_ sender: Any) {
        if let url = URL(string: "https://alexandremasse.fr") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    @IBAction func goToSiteElisa(_ sender: Any) {
        if let url = URL(string: "http://www.elisadubois.fr") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    @IBAction func goToSiteClementine(_ sender: Any) {
        if let url = URL(string: "http://www.clementinespinel.com") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    @IBAction func goToSiteCassandre(_ sender: Any) {
        if let url = URL(string: "http://www.cargocollective.com/cassandrely") {
            UIApplication.shared.open(url, options: [:])
        }
    }
}
