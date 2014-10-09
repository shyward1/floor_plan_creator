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
    
    private init() { }
    
    enum FloorPlanLevel {
        case Basement
        case First
        case Second
        case Third
        case Fourth
        case Fifth
        case Garden
        case Attic
    }
    
    // a dictionary of Floors holding an array of rooms
    var floorplan = Dictionary<FloorPlanLevel, [Room]>();
    
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
    
    // adds a room to the floor for this floor plan
    func addRoom(aRoom: Room, level: FloorPlanLevel) {
        
        var roomsOnLevel = floorplan[level];
        
        if (roomsOnLevel == nil) {
            let a: [Room] = [aRoom];
            floorplan[level] = a;
        }
        else {
            roomsOnLevel?.append(aRoom);
        }
    }
    
    func countRooms(level: FloorPlanLevel) -> Int {
        var count = 0;
        
        if let roomsOnLevel = floorplan[level] {
            count = roomsOnLevel.count;
        }
        return count;
    }
    
    // returns the total number of rooms on all levels of this floor plan
    func countRooms() -> Int {
        ///TODO: count all floors
        return 0;
    }
    
    func clearRooms() {
        //rooms.removeAll(keepCapacity: false);
    }
    
}