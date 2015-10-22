// FeatureMap.swift
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

import Foundation

/**
    The data structure which backs all FeatureVectors. A FeatureMap is a sparse
    array, only containing key and value pairs as they are added
*/
internal class FeatureMap {
    
    /// Internal "hash map" to hold key, value pairs
    private var map: [(Int, Double)]
    
    /// Internal list of keys for quick access
    private var keys: [Int]
    
    /// True if FeatureMap should sort on it's own, false if the data is pre sorted
    var preSortedData = false
    
    /**
    Initializes the FeatureMap
    
    - returns: A FeatureMap instance
    */
    init() {
        map  = [(Int, Double)]()
        keys = [Int]()
    }
    
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
    Adds a key and value tuple to the internal hash map by either appending, if
    preSortedData is true, or by keeping the hash map sorted itself
    
    - parameter key:   The feature key
    - parameter value: The value of the particular feature
    */
    func add(key: Int, value: Double) {
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
    func keyArray() -> [Int] {
        return keys
    }
    
    /**
    Gets a value for the given key from the FeatureMap
    
    - parameter key: They key for which to get the value
    
    - returns: The value if found, nil otherwise
    */
    func get(key: Int) -> Double? {
        for (mapKey, value) in map {
            if key == mapKey {
                return value
            }
        }
        return nil
    }
    
    /**
    Updates the value for the given key or adds it if not present
    
    - parameter key:   The key for which to update
    - parameter value: The value to replace the old value with
    */
    func put(key: Int, value: Double) {
        var i = 0
        for (mapKey, _) in map {
            if key == mapKey {
                map[i] = (key, value)
                keys[i] = key
                return
            }
            i++
        }
        add(key, value: value)
    }
    
    /**
    Checks where the FeatureMap contains the given key
    
    - parameter key: The key to check the FeatureMap for
    
    - returns: True if the key is found, false otherwise
    */
    func containsKey(key: Int) -> Bool {
        for (mapKey, _) in map {
            if key == mapKey {
                return true
            }
        }
        return false
    }
}