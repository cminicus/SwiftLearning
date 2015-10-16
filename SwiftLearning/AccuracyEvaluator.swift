//
//  AccuracyEvaluator.swift
//  SwiftLearning
//
//  Created by Clayton Minicus on 10/15/15.
//  Copyright © 2015 Clayton Minicus. All rights reserved.
//

import Foundation

public class AccuracyEvaluator {
    
    public func evaluate(instances: [Instance], classifier: Classifier) -> Double {
        var correct = 0
        let total = instances.count
        
        for instance in instances {
            let prediction = classifier.predict(instance)
            if prediction == instance.label {
                correct++
            }
        }
        return Double(correct) / Double(total) * 100
    }
    
}