//
//  FloorPlanDAO.swift
//  floor_creator
//
//  Created by Mark Reimer on 10/9/14.
//  Copyright (c) 2014 Shy Ward. All rights reserved.
//

import Foundation


// implements Singleton design pattern
class FloorPlanDAO {
    
    // an array of Room objects
    var rooms: [Room] = [];
    
    // call FloorPlanDAO.sharedInstance to get a handle to this class
    class var sharedInstance: FloorPlanDAO {
        
    struct Static {
        static var instance: FloorPlanDAO?
        static var token: dispatch_once_t = 0;
        }
        
        dispatch_once(&Static.token) {
            Static.instance = FloorPlanDAO();
        }
        
        return Static.instance!
    }
    
    
    // adds a room to this floor plan
    func addRoom(aRoom: Room) {
        rooms.append(aRoom);
    }
    
    func numberRooms() -> Int {
        return rooms.count;
    }
    
    func clearRooms() {
        rooms.removeAll(keepCapacity: false);
    }
    
}