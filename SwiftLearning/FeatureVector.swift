//
//  FeatureVector.swift
//  SwiftLearning
//
//  Created by Clayton Minicus on 10/15/15.
//  Copyright © 2015 Clayton Minicus. All rights reserved.
//

import Foundation


public class FeatureVector {
    
    /// Internal "hash map" to hold key, value pairs
    private var map = [(Int, Double)]()
    
    private var keys = [Int]()
    
    public var preSortedData = false
    
    /**
    Empty init
    
    - returns: A FeatureVector instance
    */
    public init() {}
    
    /**
    Adds a key and value tuple to the internal hash map while remaining
    sorted by the keys
    
    - parameter key:   The feature key
    - parameter value: The value for the particular feature
    */
    private func addSorted(key: Int, value: Double) {
        // keep internal map sorted by key
        for (currentIndex, (currentKey, _)) in map.enumerate() {
            if currentKey > key {
                map.insert((key, value), atIndex: currentIndex)
                keys.insert(key, atIndex: currentIndex)
                return
            }
        }
        map.append((key, value))
        keys.append(key)
    }
    
    /**
    Adds a key and value tuple to the feature vector by either appending,
    or keeping the data sorted, based on the "preSortedData" boolean
    
    - parameter key:   The feature key
    - parameter value: The value for the particular feature
    */
    public func add(key: Int, value: Double) {
        if preSortedData {
            map.append((key, value))
            keys.append(key)
        } else {
            addSorted(key, value: value)
        }
    }
    
    /**
    Gets the array of all keys in feature vector
    
    - returns: Array of sorted keys
    */
    public func keyArray() -> [Int] {
        return self.keys
    }
    
    /**
    Gets a value for the given key from the feature vector
    
    - parameter key: They key for which to get the value
    
    - returns: The value if found, nil otherwise
    */
    public func get(key: Int) -> Double? {
        for (mapKey, value) in map {
            if key == mapKey {
                return value
            }
        }
        return nil
    }
    
    /**
    Checks where the feature vector contains the given key
    
    - parameter key: The key to check the feature  vector for
    
    - returns: True if the key is found, false otherwise
    */
    public func containsKey(key: Int) -> Bool {
        for (mapKey, _) in map {
            if key == mapKey {
                return true
            }
        }
        return false
    }
}