//
//  MajorityClassifier.swift
//  SwiftLearning
//
//  Created by Clayton Minicus on 10/15/15.
//  Copyright © 2015 Clayton Minicus. All rights reserved.
//

import Foundation

public class MajorityClassifier: Classifier {
    
    private var prediction: Int!
    
    public func train(instances: [Instance]) {
        var ones = 0
        var zeros = 0
        
        for instance in instances {
            let label = instance.label
            if label == 1 {
                ones++
            } else {
                zeros++
            }
        }
        
        self.prediction = zeros > ones ? 0 : 1
    }
    
    public func predict(instance: Instance) -> Int {
        return self.prediction
    }
}