//
//  HashMap.swift
//  SwiftLearning
//
//  Created by Clayton Minicus on 10/25/15.
//  Copyright © 2015 Clayton Minicus. All rights reserved.
//

import Foundation

// keys must be comparable and hashable
private struct Entry<K: protocol<Comparable, Hashable>, V: Hashable> {
    var key: K
    var value: V
    var hash: Int
    
    func hashCode() -> Int {
        return key.hashValue ^ value.hashValue
    }
}

public class HashMap<K: protocol<Comparable, Hashable>, V: Hashable> {
    
    private var buckets: [[Entry<K,V>]]
    // at loadFactor * capacity, we resize
    private var loadFactor: Double
    // current size of the map
    private var size: Int
    // the next value at which to resize
    private var threshold: Int = 1
    // maximum capacity of the map
    private var maxCapacity = 1 << 30
    // when to treeify the bins
    private var treeifyThreshold = 8
    // set of all keys in hash map
    private var keySet: Set<K>
    
    public init(initialCapacity: Int = 1 << 4, loadFactor: Double = 0.75) {
        self.buckets = Array(count: initialCapacity, repeatedValue: [])
        self.loadFactor = loadFactor
        self.size = 0
        self.keySet = Set<K>()
        self.threshold = tableSizeFor(initialCapacity)
    }
    
    // ------------------------------- Get -------------------------------------
    
    public func get(key: K) -> V? {
        let entry = getEntry(hash(key), key: key)
        return entry == nil ? nil : entry!.value
    }
    
    private func getEntry(hash: Int, key: K) -> Entry<K,V>? {
        let index = (buckets.count - 1) & hash
        
        if buckets[index].isEmpty {
            return nil
        }
        
        for entry in buckets[index] {
            if key == entry.key {
                return entry
            }
        }
        return nil
    }
    
    // ----------------------------- Contains ----------------------------------
    
    public func containsKey(key: K) -> Bool {
        return getEntry(hash(key), key: key) != nil
    }
    
    // ------------------------------- Put -------------------------------------
    
    public func put(key: K, value: V) {
        putValue(hash(key), key: key, value: value)
    }
    
    private func putValue(hash: Int, key: K, value: V) {
        let index = (buckets.count - 1) & hash
        // hash % last?
        if buckets[index].isEmpty {
            buckets[index] = [Entry(key: key, value: value, hash: hash)]
        } else {
            for (currentIndex, entry) in buckets[index].enumerate() {
                if key == entry.key {
                    buckets[index][currentIndex].value = value
                    return
                }
            }
            buckets[index].append(Entry(key: key, value: value, hash: hash))
        }
        keySet.insert(key)
        
        if ++size > threshold {
            resize()
        }
    }
    
    public func keys() -> Set<K> {
        return keySet
    }
    
    // ------------------------------ Resize -----------------------------------
    
    private func resize() {
        let oldBuckets = buckets
        let oldCapacity = oldBuckets.count
        
        let newCapacity = threshold
        threshold = threshold << 1
        var newBuckets: [[Entry<K,V>]] = Array(count: newCapacity, repeatedValue: [])
        
        for i in 0..<oldCapacity {
            // make sure bucket isn't empty
            if oldBuckets[i].isEmpty {
                continue
            }
            // rehash all entries
            for entry in oldBuckets[i] {
                newBuckets[entry.hash & (newCapacity - 1)].append(entry)
            }
        }
        self.buckets = newBuckets
    }
    
    private func hash(key: K) -> Int {
        let h = key.hashValue
        return h ^ (h >> 16)
    }
    
    private func tableSizeFor(capacity: Int) -> Int {
        var size = capacity - 1
        size |= size >> 1
        size |= size >> 2
        size |= size >> 4
        size |= size >> 8
        size |= size >> 16
        return size < 0 ? 1 : size >= maxCapacity ? maxCapacity : size + 1
    }
    
}