//
//  ModelController.swift
//  FNFA
//
//  Created by MINERVINI Robin on 12/02/2018.
//  Copyright © 2018 MINERVINI Robin. All rights reserved.
//

import Foundation
import UIKit

class ModelController: NSObject {
    var categories = [NSMutableDictionary]()
    var events = [NSMutableDictionary]()
    var places = [NSMutableDictionary]()
    var transports = [NSMutableDictionary]()
    
    let timestamp4Avril = Date(timeIntervalSince1970: 1522836000), // 4 Avril 2018, 12:00
    timestamp5Avril = Date(timeIntervalSince1970: 1522922400), // 5 Avril 2018, 12:00
    timestamp6Avril = Date(timeIntervalSince1970: 1523008800), // 6 Avril 2018, 12:00
    timestamp7Avril = Date(timeIntervalSince1970: 1523095200), // 7 Avril 2018, 12:00
    timestamp8Avril = Date(timeIntervalSince1970: 1523181600)  // 8 Avril 2018, 12:00
    
    static func getDate(forString: String) -> Date {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withYear, .withMonth, .withDay, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
        formatter.timeZone = TimeZone(identifier: "Europe/Paris")
        return formatter.date(from: forString )!
    }
    
    func loadJSON() {
        if loadSavedJSON() == false {
            
            loadDefaultJSON()
            saveJSON()
        }
    }
    
    func saveJSON() {
        let folderPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        saveJSONTo(folderPath, which: events, fileName: "events")
        saveJSONTo(folderPath, which: categories, fileName: "categories")
        saveJSONTo(folderPath, which: transports, fileName: "transports")
    }
    
    func getEventsInFav() -> [NSMutableDictionary]{
        var favEvents = [NSMutableDictionary]()
        for event in events {
            if event["isFav"] as! Bool == true {
                favEvents.append(event)
            }
        }
        
        return favEvents
    }
    
    func removeOfFavs(eventId: Int, filteredEvents:[NSMutableDictionary]) {
        for event in events {
            if event["id"] as! Int == eventId {
                
                let isFav = !(event["isFav"] as! Bool)
                event["isFav"] = isFav
                
                saveJSON()
            }
        }
    }
    
    func getEventsByDate(events:[NSMutableDictionary], date: String) -> [NSMutableDictionary] {
        let filteredEvents = events.filter { $0["startingDateDayNumber"] as? String == date.lowercased()}
        return filteredEvents
    }
    
    // On sépare les removeOfFavs et addToFavs car dans
    // removeToFavs, pas besoin d'itérer sur tout les evenements (filteredEvents)
    // mais seulement sur les elements en favoris
    
    func addToFavs(filteredEvents:[NSMutableDictionary], eventId: Int, BtnAddToFav: UIButton) {
        for event in filteredEvents {
            if (event["id"] as! Int) == eventId {
                let isFav = !(event["isFav"] as! Bool)
                event["isFav"] = isFav
                saveJSON()
                if event["isFav"] as! Bool == true {
                    let image = UIImage(named: "heart_full")
                    BtnAddToFav.setImage(image, for: .normal)
                } else {
                    let image = UIImage(named: "heart_empty")
                    BtnAddToFav.setImage(image, for: .normal)
                }
                break
            }
        }
    }
    
    func addToFavWithId(eventId: Int) {
        for event in events {
            if (event["id"] as! Int) == eventId{
                let isFav = !(event["isFav"] as! Bool)
                event["isFav"] = isFav
                saveJSON()
                break
            }
        }
    }
    
    // private
    func loadDefaultJSON() {
        
        print("load default Json")
        
        if let URL = Bundle.main.url(forResource: "categories", withExtension: "json")  {
            do {
                let data = try Data.init(contentsOf: URL)
                categories = try JSONSerialization.jsonObject(with: data as Data, options: [.mutableContainers]) as! [NSMutableDictionary]
            }
            catch {
                print(error)
            }
        }
        if let URL = Bundle.main.url(forResource: "events", withExtension: "json")  {
            do {
                let data = try Data.init(contentsOf: URL)
                events = try JSONSerialization.jsonObject(with: data as Data, options: [.mutableContainers]) as! [NSMutableDictionary]
            }
            catch {
                print(error)
            }
        }
        if let URL = Bundle.main.url(forResource: "places", withExtension: "json")  {
            do {
                let data = try Data.init(contentsOf: URL)
                places = try JSONSerialization.jsonObject(with: data as Data, options: [.mutableContainers]) as! [NSMutableDictionary]
            }
            catch {
                print(error)
            }
        }
        if let URL = Bundle.main.url(forResource: "transports", withExtension: "json")  {
            do {
                let data = try Data.init(contentsOf: URL)
                transports = try JSONSerialization.jsonObject(with: data as Data, options: [.mutableContainers]) as! [NSMutableDictionary]
            }
            catch {
                print(error)
            }
        }
        
        setEventCategory()
        setEventPlaces()
        setStartingDateDayNumber()
        
    }
    
    func loadSavedJSON() -> Bool {
        
        let folderPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        do {
            let filePath = folderPath + "/events.json"
            print(filePath)
            let url = URL.init(fileURLWithPath: filePath)
            let data = try Data.init(contentsOf: url)
            events = try JSONSerialization.jsonObject(with: data as Data, options: [.mutableContainers]) as! [NSMutableDictionary]
        }
        catch {
            print("loadSavedJSON events: error")
            return false
        }
        
        if let URL = Bundle.main.url(forResource: "places", withExtension: "json")  {
            do {
                let data = try Data.init(contentsOf: URL)
                places = try JSONSerialization.jsonObject(with: data as Data, options: [.mutableContainers]) as! [NSMutableDictionary]
            }
            catch {
                print(error)
            }
        }
        
        if let URL = Bundle.main.url(forResource: "categories", withExtension: "json")  {
            do {
                let data = try Data.init(contentsOf: URL)
                categories = try JSONSerialization.jsonObject(with: data as Data, options: [.mutableContainers]) as! [NSMutableDictionary]
            }
            catch {
                print(error)
            }
        }
        
        if let URL = Bundle.main.url(forResource: "transports", withExtension: "json")  {
            do {
                let data = try Data.init(contentsOf: URL)
                transports = try JSONSerialization.jsonObject(with: data as Data, options: [.mutableContainers]) as! [NSMutableDictionary]
            }
            catch {
                print(error)
            }
        }
        
        setEventCategory()
        setEventPlaces()
        setStartingDateDayNumber()
        
        return true
    }
    
    func saveJSONTo(_ path: String, which: [NSMutableDictionary], fileName: String)   {
        let filePath = path + "/" + fileName + ".json"
        let url = URL.init(fileURLWithPath: filePath)
        
        do {
            let data = try JSONSerialization.data(withJSONObject: which, options: [])
            try data.write(to: url)
        }
        catch {
            print(error)
        }
    }
    
    func setEventCategory() {
        for category in categories {
            for event in events {
                if category["id"] as! Int == event["categoryId"] as! Int {
                    event["category"] = category["name"]
                }
            }
        }
    }
    
    func setEventPlaces(){
        for event in events {
            
            let eventPlacesIds = event["placeIds"] as! [Int]
            var eventPlaces  = event["place"] as! [String]
            
            if eventPlaces.count == 0 {
                for place in places {
                    for id in eventPlacesIds {
                        if(place["id"] as! Int == id) {
                            let placeName = place["name"] as! String
                            eventPlaces.append(placeName)
                        }
                    }
                }
            }

            event["place"] = eventPlaces
        }
    }
    
    func setStartingDateDayNumber() {
        for event in events {
            let formatter = ISO8601DateFormatter()
            formatter.timeZone = TimeZone(identifier: "Europe/Paris")
            let dateIso = event["startingDate"]!
            let test = dateIso as! String
            if let date = formatter.date(from: test) {
                event["startingDateDayNumber"]! = date.nameNumberDate
                if (event["id"] as! Int) == 29 {
                }
            }
        }
    }
}
