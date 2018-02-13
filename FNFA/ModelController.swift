//
//  ModelController.swift
//  FNFA
//
//  Created by MINERVINI Robin on 12/02/2018.
//  Copyright © 2018 MINERVINI Robin. All rights reserved.
//

import Foundation

class ModelController: NSObject {
    var categories = [NSMutableDictionary]()
    var events = [NSMutableDictionary]()
    var places = [NSMutableDictionary]()
    
    func loadJSON() {
        
        if loadSavedJSON() == false {
            
            loadDefaultJSON()
            saveJSON()
        }
    }
    
    func saveJSON() {
        let folderPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        saveJSONTo(folderPath, which: events, fileName: "events")
    }
    
    // private
    func loadDefaultJSON() {
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
    }
    
    func loadSavedJSON() -> Bool {
        
        let folderPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        do {
            let filePath = folderPath + "/events.json"
            let url = URL.init(fileURLWithPath: filePath)
            let data = try Data.init(contentsOf: url)
            events = try JSONSerialization.jsonObject(with: data as Data, options: [.mutableContainers]) as! [NSMutableDictionary]
        }
        catch {
            print("loadSavedJSON: error")
            return false
        }
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
}
