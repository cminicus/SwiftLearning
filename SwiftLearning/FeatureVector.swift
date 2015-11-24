// FeatureVector.swift
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
    A sparse vector backed by a FeatureMap which contains all (key, value) pairs
    of the features used by the SwiftLearning algorithms
*/
public class FeatureVector {
    
    /// Internal FeatureMap to hold key, value pairs
    private var map: FeatureMap
    
    /// Option to turn off internal sorting, allowing faster add speeds
    public var preSortedData = false {
        didSet(value) {
            map.preSortedData = value
        }
    }
    
    /**
    Initializes the FeatureVector
    
    - returns: A FeatureVector instance
    */
    public init() {
        map = FeatureMap()
    }
    
    /**
    Adds a key and value tuple to the feature vector by either appending,
    or keeping the data sorted, based on the "preSortedData" boolean
    
    - parameter key:   The feature key
    - parameter value: The value for the particular feature
    */
    public func add(key: Int, value: Double) {
        map.add(key, value: value)
    }
    
    /**
    Gets the array of all keys in feature vector
    
    - returns: Array of sorted keys
    */
    public func keyArray() -> [Int] {
        return map.keyArray()
    }
    
    /**
    Gets the array of all values in feature vector
    
    - returns: Array of values sorted by corresponding key
    */
    public func valueArray() -> [Double] {
        return map.valueArray()
    }
    
    /**
    Gets a value for the given key from the feature vector
    
    - parameter key: They key for which to get the value
    
    - returns: The value if found, nil otherwise
    */
    public func get(key: Int) -> Double? {
        return map.get(key)
    }
    
    /**
    Updates the value for the given key or adds it if not present
    
    - parameter key:   The key for which to update
    - parameter value: The value to replace the old value with
    */
    public func put(key: Int, value: Double) {
         map.put(key, value: value)
    }
    
    /**
    Checks where the feature vector contains the given key
    
    - parameter key: The key to check the feature  vector for
    
    - returns: True if the key is found, false otherwise
    */
    public func containsKey(key: Int) -> Bool {
        return map.containsKey(key)
    }
}