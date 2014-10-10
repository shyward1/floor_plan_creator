//
//  FloorPlanDAO.swift
//  floor_creator
//
//  Created by Mark Reimer on 10/9/14.
//  Copyright (c) 2014 Shy Ward. All rights reserved.
//

import Foundation

/*
// for some odd reason this isn't working when called from floor_creatorTests
 public enum FloorLevel {
    case Basement
    case First
    case Second
    case Third
    case Fourth
    case Fifth
    case Garden
    case Attic
}
*/

public let FLOOR_BASEMENT: Int = -1;
public let FLOOR_GARDEN: Int = 0;
public let FLOOR_FIRST: Int = 1;
public let FLOOR_SECOND: Int = 2;
public let FLOOR_THIRD: Int = 3;
public let FLOOR_FOURTH: Int = 4;
public let FLOOR_FIFTH: Int = 5;
public let FLOOR_ATTIC: Int = 9;


// implements Singleton design pattern
public class FloorPlanDAO {
    
    private init() { }    
    
    // a dictionary of Floors holding an array of rooms
    var floorplan = Dictionary<Int, [Room]>();
    
    // call FloorPlanDAO.sharedInstance to get a handle to this class
    public class var sharedInstance: FloorPlanDAO {
        
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
    public func addRoom(aRoom: Room, level: Int) {
        var roomsOnLevel = floorplan[level];
        
        if (roomsOnLevel == nil) {
            let a: [Room] = [aRoom];
            floorplan[level] = a;
        }
        else {
            roomsOnLevel?.append(aRoom);
            floorplan[level] = roomsOnLevel;
        }
    }
    
    public func countRooms(level: Int) -> Int {
        var count = 0;
        
        if let roomsOnLevel = floorplan[level] {
            count = roomsOnLevel.count;
        }
        return count;
    }
    
    // returns the total number of rooms on all levels of this floor plan
    public func countRooms() -> Int {
        var count: Int = 0;
        
        for (level, rooms) in floorplan {
            count += rooms.count;
        }
        
        return count;
    }
    
    public func clearRooms() {
        floorplan.removeAll(keepCapacity: false);
    }
    
}