//
//  FeatureMapTests.swift
//  SwiftLearning
//
//  Created by Clayton Minicus on 10/19/15.
//  Copyright © 2015 Clayton Minicus. All rights reserved.
//

import XCTest
@testable import SwiftLearning

class FeatureMapTests: XCTestCase {

    let iterations = 50
//    let iterations = 5000
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testFeatureMapAddSpeed() {
        
        let featureMap = FeatureMap()
        
        measureBlock {
            for i in 0..<self.iterations {
                featureMap.add(i, value: Double(i))
            }
        }
    }
    
    func testFeatureMapGetSpeed() {
        
        let featureMap = FeatureMap()
        
        for i in 0..<iterations {
            featureMap.add(i, value: Double(i))
        }
        
        measureBlock {
            for i in 0..<self.iterations {
                featureMap.get(i)
            }
        }
    }
    
    func testFeatureMapPutSpeed() {
        let featureMap = FeatureMap()
        
        for i in 0..<iterations {
            featureMap.add(i, value: Double(i))
        }
        
        measureBlock {
            for i in 0..<self.iterations {
                featureMap.put(i, value: Double(i))
            }
        }
    }
    
    func testFeatureMapPutWorks() {
        let featureMap = FeatureMap()
        
        for i in 0..<iterations {
            featureMap.add(i, value: Double(i))
        }
        
        for i in 0..<iterations {
            featureMap.put(i, value: Double(i * 2))
        }
        
        for i in 0..<iterations {
            XCTAssertEqual(featureMap.get(i)!, Double(i * 2))
        }
    }
    
    func testFeatureMapKeyArraySpeed() {
        let featureMap = FeatureMap()
        
        for i in 0..<iterations {
            featureMap.add(i, value: Double(i))
        }
        
        measureBlock {
            for _ in 0..<self.iterations {
                featureMap.keyArray()
            }
        }
    }

}
