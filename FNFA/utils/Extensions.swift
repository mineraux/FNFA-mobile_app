//
//  Extensions.swift
//  FNFA
//
//  Created by MASSE Alexandre on 15/03/2018.
//  Copyright © 2018 MINERVINI Robin. All rights reserved.
//

import Foundation

extension Array where Element == NSMutableDictionary {
    
    enum SortDirection {
        case ascending, descending
    }
    
    enum EventSortProperty {
        case date, name, id
    }
    
    func findBy(date: Date) -> [NSMutableDictionary]? {
        return self.filter({ (event) -> Bool in
            return ModelController.getDate(forString: (event["startingDate"] as! String)).numberDay == date.numberDay
        })
    }
    
    func sorted(by: EventSortProperty, order: SortDirection = .ascending) -> [NSMutableDictionary]? {
        return self.sorted {
            switch by {
            case .date:
                return order == .ascending ?
                ModelController.getDate(forString: $0["startingDate"] as! String) < ModelController.getDate(forString: $1["startingDate"] as! String) :
               ModelController.getDate(forString: $0["startingDate"] as! String) > ModelController.getDate(forString: $1["startingDate"] as! String)
            case .name:
                return order == .ascending ? ($0["name"] as! String) <  ($1["name"] as! String) :  ($0["name"] as! String) >  ($1["name"] as! String)
            case .id:
                return order == .ascending ?  ($0["id"] as! Int) < ($1["id"] as! Int) : ($0["id"] as! Int) > ($1["id"] as! Int)
            }
        }
    }
    
    
}
