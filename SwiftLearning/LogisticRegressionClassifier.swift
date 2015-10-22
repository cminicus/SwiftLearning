//
//  LogisticRegressionClassifier.swift
//  SwiftLearning
//
//  Created by Clayton Minicus on 10/16/15.
//  Copyright © 2015 Clayton Minicus. All rights reserved.
//

import Foundation

public class LogisticRegressionClassifier: Classifier {
    
    private var w: FeatureMap
    private var partialGradientSums: FeatureMap
    
    private let eta: Double
    private let iterations: Int
    
    init(eta: Double = 0.01, iterations: Int = 20) {
        self.eta = eta
        self.iterations = iterations
        self.w = FeatureMap()
        self.partialGradientSums = FeatureMap()
    }
    
    public func train(instances: [Instance]) {
        let total = Double(iterations) * Double(instances.count)
        var current = 0.0
        
        for _ in 0..<iterations {
            for instance in instances {
                let vector = instance.featureVector
                let label = instance.label
                
                let product = multiplyVectors(self.w, vector: vector)
                let gPositive = calculateLinkFunction(product)
                let gNegative = calculateLinkFunction(-product)
                
                let keys = vector.keyArray()
                for key in keys {
                    let x_i_j = vector.get(key)!
                    let gradient = Double(label) * gNegative * x_i_j +
                        Double(1 - label) * gPositive * -x_i_j
                    
                    var previousSum = partialGradientSums.get(key) == nil
                        ? 0 : partialGradientSums.get(key)!
                    
                    previousSum += (gradient * gradient)
                    partialGradientSums.put(key, value: previousSum)
                    
                    let n_i_j = self.eta / sqrt(1.0 + previousSum)
                    
                    let w_j = w.get(key) == nil ? 0 : w.get(key)!
                    w.put(key, value: w_j + n_i_j * gradient)
                }
                print(current / total * 100)
                current++
            }
        }
    }
    
    public func predict(instance: Instance) -> Int {
        let vector = instance.featureVector
        let sum = multiplyVectors(self.w, vector: vector)
        let prediction = calculateLinkFunction(sum)
        
        return prediction >= 0.5 ? 1 : 0
    }
    
    private func calculateLinkFunction(z: Double) -> Double {
        return 1.0 / (1 + exp(-z))
    }
    
    private func multiplyVectors(w: FeatureMap, vector: FeatureVector) -> Double {
        var sum = 0.0
        let keys = vector.keyArray()
        
        for key in keys {
            let value = vector.get(key)!
            let w_j = w.get(key) == nil ? 0 : w.get(key)!
            
            sum += (value * w_j)
        }
        return sum
    }
}