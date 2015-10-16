//
//  EvenOddClassifier.swift
//  SwiftLearning
//
//  Created by Clayton Minicus on 10/15/15.
//  Copyright © 2015 Clayton Minicus. All rights reserved.
//

import Foundation

public class EvenOddClassifier: Classifier {
    
    private var prediction: Int!
    
    public func train(instances: [Instance]) {
        var evenSum = 0.0
        var oddSum = 0.0
        
        let total = Double(instances.count)
        var current = 0.0
        
        for instance in instances {
            let vector = instance.featureVector
            let keys = vector.keyArray()
            for key in keys {
                let value = vector.get(key)!
                if key % 2 == 0 {
                    evenSum += value
                } else {
                    oddSum += value
                }
            }
            current++
            print(current / total)
        }
        
        self.prediction = evenSum >= oddSum ? 1 : 0
    }
    
    public func predict(instance: Instance) -> Int {
        return self.prediction
    }
    
}