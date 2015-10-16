//
//  FeatureVectorTests.swift
//  SwiftLearning
//
//  Created by Clayton Minicus on 10/15/15.
//  Copyright © 2015 Clayton Minicus. All rights reserved.
//

import XCTest
@testable import SwiftLearning

class FeatureVectorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func DISABLED_testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testThatEmptyFeatureVectorGivesEmptyKeyArray() {
        // given, when
        let featureVector = FeatureVector()
        
        // then
        XCTAssertEqual(featureVector.keyArray(), [])
        
        
        
        let dataReader = DataReader(fileName: "speech_test.txt")
        dataReader.readData()
        
    }
    
    func testThatFeatureVectorRemainsSortedByKeys() {
        // given
        let featureVector = FeatureVector()
        
        // then
        featureVector.add(6, value: 90)
        featureVector.add(1, value: 90)
        featureVector.add(8, value: 90)
        featureVector.add(3, value: 90)
        featureVector.add(42, value: 90)
        featureVector.add(19, value: 90)
        
        // then
        XCTAssertEqual(featureVector.keyArray(), [1, 3, 6, 8, 19, 42])
    }
    
    func testThatFeatureVectorContainsProperKeys() {
        // given
        let featureVector = FeatureVector()
        
        // then
        featureVector.add(6, value: 90)
        featureVector.add(9, value: 90)
        
        // when
        XCTAssert(featureVector.containsKey(6))
        XCTAssert(featureVector.containsKey(9))
    }
    
    func testThatFeatureVectorDoesNotContainsKeys() {
        // given
        let featureVector = FeatureVector()
        
        // then
        featureVector.add(6, value: 90)
        
        // when
        XCTAssertFalse(featureVector.containsKey(9))
    }
    
    func testThatEmptyFeatureVectorDoesNotContainsKeys() {
        // given, then
        let featureVector = FeatureVector()
        
        // when
        XCTAssertFalse(featureVector.containsKey(9))
    }
    
    func testThatFeatureVectorProperlyGetsValues() {
        // given
        let featureVector = FeatureVector()
        
        // then
        featureVector.add(6, value: 90)
        featureVector.add(9, value: 89)
        
        // when
        XCTAssertEqual(featureVector.get(6), 90)
        XCTAssertEqual(featureVector.get(9), 89)
    }
    
    func testThatFeatureVectorReturnsNilForKeysNotFound() {
        // given
        let featureVector = FeatureVector()
        
        // then
        featureVector.add(6, value: 90)
        
        // when
        XCTAssertNil(featureVector.get(9))
    }
    
    
}
