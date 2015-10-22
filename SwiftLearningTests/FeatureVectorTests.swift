// FeatureVectorTests.swift
//
// Copyright (c) 2015 Clayton Minicus (http://claytonminicus.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import XCTest
@testable import SwiftLearning

class FeatureVectorTests: XCTestCase {
    
    let iterations = 1000
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testThatEmptyFeatureVectorGivesEmptyKeyArray() {
        // given, when
        let featureVector = FeatureVector()
        
        // then
        XCTAssertEqual(featureVector.keyArray(), [])
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
    
    func testThatFeatureVectorAddsFeatureWithPutIfNonExistent() {
        // given
        let featureVector = FeatureVector()
        
        // then
        featureVector.add(6, value: 90)
        
        featureVector.put(6, value: 89)
        featureVector.put(3, value: 89)
        featureVector.put(8, value: 89)
        featureVector.put(1, value: 89)
        
        // when
        XCTAssertEqual(featureVector.get(6), 89)
        XCTAssertEqual(featureVector.get(3), 89)
        XCTAssertEqual(featureVector.get(8), 89)
        XCTAssertEqual(featureVector.get(1), 89)
    }
    
    func testThatFeatureVectorUpdatesValuesCorrectly() {
        // given
        let featureVector = FeatureVector()
        
        // then
        featureVector.add(6, value: 90)
        featureVector.add(3, value: 90)
        featureVector.add(8, value: 90)
        featureVector.add(1, value: 90)
        
        featureVector.put(6, value: 89)
        featureVector.put(3, value: 89)
        featureVector.put(8, value: 89)
        featureVector.put(1, value: 89)
        
        // when
        XCTAssertEqual(featureVector.get(6), 89)
        XCTAssertEqual(featureVector.get(3), 89)
        XCTAssertEqual(featureVector.get(8), 89)
        XCTAssertEqual(featureVector.get(1), 89)
    }
    
    func testFeatureVectorAddSpeed() {
        
        // given
        let featureVector = FeatureVector()
        
        // then, when
        measureBlock {
            for i in 0..<self.iterations {
                featureVector.add(i, value: Double(i))
            }
        }
    }
    
    func testFeatureVectorGetSpeed() {
        
        // given
        let featureVector = FeatureVector()
        
        // then
        for i in 0..<iterations {
            featureVector.add(i, value: Double(i))
        }
        
        // when
        measureBlock {
            for i in 0..<self.iterations {
                featureVector.get(i)
            }
        }
    }
    
    func testFeatureVectorPutSpeed() {
        
        // given
        let featureVector = FeatureVector()
        
        // then
        for i in 0..<iterations {
            featureVector.add(i, value: Double(i))
        }
        
        // when
        measureBlock {
            for i in 0..<self.iterations {
                featureVector.put(i, value: Double(i))
            }
        }
    }
    
    func testFeatureVectorKeyArraySpeed() {
        
        // given
        let featureVector = FeatureVector()
        
        // then
        for i in 0..<iterations {
            featureVector.add(i, value: Double(i))
        }
        
        // when
        measureBlock {
            for _ in 0..<self.iterations {
                featureVector.keyArray()
            }
        }
    }
}
