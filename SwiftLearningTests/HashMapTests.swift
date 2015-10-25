//
//  HashMapTests.swift
//  SwiftLearning
//
//  Created by Clayton Minicus on 10/25/15.
//  Copyright © 2015 Clayton Minicus. All rights reserved.
//

import XCTest
@testable import SwiftLearning

class HashMapTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testThatHashMapProperlyAddsEntries() {
        let hashMap = HashMap<Int, Double>()
        
        for i in 0..<10000 {
            hashMap.put(i, value: Double(i))
        }
        
        self.measureBlock {
            for i in 0..<10000 {
                hashMap.get(i)
            }
        }
    }
    
    func testThatFeatureMapProperlyAddsEntries() {
        let hashMap = FeatureMap()
        
        for i in 0..<10000 {
            hashMap.put(i, value: Double(i))
        }
        
        self.measureBlock {
            for i in 0..<10000 {
                hashMap.get(i)
            }
        }
    }
    
    func testThatHashMapProperlyPutsEntries() {
        let hashMap = HashMap<Int, Double>()
        
        self.measureBlock {
            for i in 0..<10000 {
                hashMap.put(i, value: Double(i))
            }
        }
        
        for i in 0..<10000 {
            XCTAssertEqual(hashMap.get(i), Double(i))
        }
        
    }
    
    func testThatFeatureMapProperlyPutEntries() {
        let hashMap = FeatureMap()
        
        self.measureBlock {
            for i in 0..<10000 {
                hashMap.put(i, value: Double(i))
            }
        }
        
        for i in 0..<10000 {
            XCTAssertEqual(hashMap.get(i), Double(i))
        }
        
    }

}
