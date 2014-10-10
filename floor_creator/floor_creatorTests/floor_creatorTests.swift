//
//  floor_creatorTests.swift
//  floor_creatorTests
//
//  Created by Shy Ward on 10/1/14.
//  Copyright (c) 2014 Shy Ward. All rights reserved.
//

import UIKit
import XCTest
import floor_creator

class floor_creatorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    // MARK: - FloorPlanDAO Tests
    
    func testAddRoom() {
        var room: Room = Room(width: CGFloat(235.0), depth: CGFloat(125.1), name: "test room");
        FloorPlanDAO.sharedInstance.addRoom(room, level: 1);
        
        let count =  FloorPlanDAO.sharedInstance.countRooms(1);
        XCTAssert(count == 1, "testAddRoom");
    }
    
    func testAddRoomToBasement() {
        var room: Room = Room(width: CGFloat(235.0), depth: CGFloat(125.1), name: "basement");
        FloorPlanDAO.sharedInstance.addRoom(room, level: -1);
        
        let count =  FloorPlanDAO.sharedInstance.countRooms(-1);
        XCTAssert(count == 1, "testAddRoomToBasement");
    }
    
    func testCountRoomsAllFloors() {
        FloorPlanDAO.sharedInstance.clearRooms();
        for (var i: Int = 0; i<10; i++) {
            FloorPlanDAO.sharedInstance.addRoom(Room(width: CGFloat(10.0), depth: CGFloat(10.0), name: "room name"), level: 1);
            FloorPlanDAO.sharedInstance.addRoom(Room(width: CGFloat(10.0), depth: CGFloat(10.0), name: "room name"), level: 0);
            FloorPlanDAO.sharedInstance.addRoom(Room(width: CGFloat(10.0), depth: CGFloat(10.0), name: "room name"), level: -1);
            FloorPlanDAO.sharedInstance.addRoom(Room(width: CGFloat(10.0), depth: CGFloat(10.0), name: "room name"), level: 2);
            FloorPlanDAO.sharedInstance.addRoom(Room(width: CGFloat(10.0), depth: CGFloat(10.0), name: "room name"), level: 3);
            FloorPlanDAO.sharedInstance.addRoom(Room(width: CGFloat(10.0), depth: CGFloat(10.0), name: "room name"), level: 4);
            FloorPlanDAO.sharedInstance.addRoom(Room(width: CGFloat(10.0), depth: CGFloat(10.0), name: "room name"), level: 5);
            FloorPlanDAO.sharedInstance.addRoom(Room(width: CGFloat(10.0), depth: CGFloat(10.0), name: "room name"), level: 9);
        }
        
        let count =  FloorPlanDAO.sharedInstance.countRooms();
        XCTAssert(count == 80, "testCountRoomsAllFloors");
    }
    
    func testRemoveAllElements() {
        for (var i: Int = 0; i<10; i++) {
            FloorPlanDAO.sharedInstance.addRoom(Room(width: CGFloat(10.0), depth: CGFloat(10.0), name: "room name"), level: 1);
            FloorPlanDAO.sharedInstance.addRoom(Room(width: CGFloat(10.0), depth: CGFloat(10.0), name: "room name"), level: 0);
            FloorPlanDAO.sharedInstance.addRoom(Room(width: CGFloat(10.0), depth: CGFloat(10.0), name: "room name"), level: -1);
            FloorPlanDAO.sharedInstance.addRoom(Room(width: CGFloat(10.0), depth: CGFloat(10.0), name: "room name"), level: 2);
            FloorPlanDAO.sharedInstance.addRoom(Room(width: CGFloat(10.0), depth: CGFloat(10.0), name: "room name"), level: 3);
            FloorPlanDAO.sharedInstance.addRoom(Room(width: CGFloat(10.0), depth: CGFloat(10.0), name: "room name"), level: 4);
            FloorPlanDAO.sharedInstance.addRoom(Room(width: CGFloat(10.0), depth: CGFloat(10.0), name: "room name"), level: 5);
            FloorPlanDAO.sharedInstance.addRoom(Room(width: CGFloat(10.0), depth: CGFloat(10.0), name: "room name"), level: 9);
        }
        
        let beforeCount =  FloorPlanDAO.sharedInstance.countRooms();
        FloorPlanDAO.sharedInstance.clearRooms();
        let afterCount =  FloorPlanDAO.sharedInstance.countRooms();
        
        XCTAssert( (beforeCount > afterCount && afterCount == 0 ), "testRemoveAllElements");
    }
    
    func testRemoveAllElementsNoElementsExist() {
        FloorPlanDAO.sharedInstance.clearRooms();
        let count =  FloorPlanDAO.sharedInstance.countRooms();
        XCTAssert(count == 0, "testRemoveAllElementsNoElementsExist");
    }
    
    func testCountNoElementsExist() {
        FloorPlanDAO.sharedInstance.clearRooms();
        XCTAssert(FloorPlanDAO.sharedInstance.countRooms() == 0, "testCountNoElementsExist");
    }
    
    func testCountFloorRoomsNoElementsExist() {
        FloorPlanDAO.sharedInstance.clearRooms();
        XCTAssert(FloorPlanDAO.sharedInstance.countRooms(3) == 0, "testCountFloorRoomsNoElementsExist");
    }
    
    func testCountRoomsNoRoomsExist() {
        FloorPlanDAO.sharedInstance.clearRooms();
        let count = FloorPlanDAO.sharedInstance.countRooms(8);
        XCTAssert(count == 0, "testCountRoomsNoRoomsExist");
    }
    
}
