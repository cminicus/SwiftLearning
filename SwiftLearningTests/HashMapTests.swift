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
    
    /** 
        Findings
    
        For putting unique numbers, hashMaps are significantly faster than featureMaps.
        However when putting numbers that repeat, unfortunately featureMaps are significantly
        faster than hashMaps so for our purposes in this library, hashMaps are not useful
        ** Cries **

    */
    
    func DISABLED_testHashMapGetSpeed() {
        let hashMap = HashMap<Int, Double>()
        
        for i in 0..<10000 {
            hashMap.put(i % 700, value: Double(i))
        }
        
        self.measureBlock {
            for i in 0..<10000 {
                hashMap.get(i % 700)
            }
        }
    }
    
    func DISABLED_testFeatureMapGetSpeed() {
        let hashMap = FeatureMap()
        
        for i in 0..<10000 {
            hashMap.put(i % 700, value: Double(i))
        }
        
        self.measureBlock {
            for i in 0..<10000 {
                hashMap.get(i % 700)
            }
        }
    }
    
    func DISABLED_testHashMapPutSpeed() {
        let hashMap = HashMap<Int, Double>()
        
        self.measureBlock {
            for i in 0..<10000 {
                hashMap.put(i % 700, value: Double(i))
            }
        }
    }
    
    func DISABLED_testFeatureMapPutSpeed() {
        let hashMap = FeatureMap()
        
        self.measureBlock {
            for i in 0..<10000 {
                hashMap.put(i % 700, value: Double(i))
            }
        }
    }

}
