//
//  PegasosClassifier.swift
//  SwiftLearning
//
//  Created by Clayton Minicus on 10/20/15.
//  Copyright © 2015 Clayton Minicus. All rights reserved.
//

import Foundation

public class PegasosClassifier: Classifier {
    
    private var w: [Double]!
    private var lambda: Double
    private var iterations: Int
    private var t: Int
    
    public init(iterations: Int = 20, lambda: Double = 0.0001) {
        self.iterations = iterations
        self.lambda = lambda
        self.t = 1
    }
    
    public func train(instances: [Instance]) {
        initializeW(instances)
        
        let total = Double(iterations * instances.count)
        
        for _ in 0..<iterations {
            for instance in instances {
                var label = instance.label
                let vector = instance.featureVector
               
                
                if label == 0 {
                    label = -1
                }
                
                let product = Double(label) * innerProduct(
                    self.w,
                    vector: vector
                )
                for (key, value) in w.enumerate() {
                    var baseValue = (1.0 - 1.0 / Double(self.t)) * value
                    if product < 1 {
                        let x_i_t = vector.containsKey(key) ? vector.get(key)! : 0
                        baseValue += (1.0 / (lambda * Double(self.t))) * Double(label) * x_i_t
                    }
                    w[key] = baseValue
                }
                self.t++
                print(Double(self.t - 1) / total * 100)
            }
        }
    }
    
    public func predict(instance: Instance) -> Int {
        let vector = instance.featureVector
        let prediction = innerProduct(self.w, vector: vector)
        return prediction >= 0 ? 1 : 0
    }
    
    private func initializeW(instances: [Instance]) {
        var largestFeature = 0
        for instance in instances {
            let vector = instance.featureVector
            let keys = vector.keyArray()
            let lastFeature = keys.last!
            if lastFeature > largestFeature {
                largestFeature = lastFeature
            }
        }
        self.w = Array(count: largestFeature + 1, repeatedValue: 0.0)
    }
    
    private func innerProduct(w: [Double], vector: FeatureVector) -> Double {
        var sum = 0.0
        let wSize = w.count
        
        let keys = vector.keyArray()
        for key in keys {
            let value = vector.get(key)!
            if key < wSize {
                sum += (value * w[key])
            }
        }
        return sum
    }
    
    
}