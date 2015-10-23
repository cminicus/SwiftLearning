// LogisticRegressionClassifier.swift
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
    A learner based on the AdaGrad Stochastic Gradient Descent Algorithm
    using a logistic link function for predictions. Achieves a solution with 
    accuracy π in O(1/π^2)
*/
public class LogisticRegressionClassifier: Classifier {
    
    /// Internal sparse array of parameters for the primal objective
    private var w: FeatureMap
    /// Internal sparse array of historic partial gradient sums for each parameter in w
    private var partialGradientSums: FeatureMap
    
    /// The value used in calculations for the learning rate, defaults to 0.01
    private let eta: Double
    /// The number of iterations on which to train the classifier, defaults to 20
    private let iterations: Int
    
    /// Whether or not to shuffle data the data after each iteration
    public var shuffleData = false
    
    /**
    Initializes the classifier with optional eta and iterations parameters
    
    - parameter eta:        Value used in calculations for the learning rate, defaults to 0.01
    - parameter iterations: The number of iterations on which to train the classifier, defaults to 20
    
    - returns: A LogisticRegressionClassifier instance
    */
    init(eta: Double = 0.01, iterations: Int = 20) {
        self.eta = eta
        self.iterations = iterations
        self.w = FeatureMap()
        self.partialGradientSums = FeatureMap()
    }
    
    /**
    Trains the classifier by using the AdaGrad SGD algorithm. The algorithm uses
    a per feature learning rate calculated using the historical partial gradient
    sums for that feature. AdaGrad calculates the gradient for each instance and
    tunes it's parameters in a way that minimizes the gradient.
    
    - parameter instances: The instances used to train the classifier
    */
    public func train(var instances: [Instance]) {
        let total = Double(iterations) * Double(instances.count)
        var current = 0.0
        
        for _ in 0..<iterations {
            
            if shuffleData {
                instances = instances.shuffle()
            }
            
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
    
    /**
    Predicts the label of the given instance by calculating the inner product
    of the instance vector with the internal parameter vector and putting this 
    value through a logistic function to calculate the prediction.
    
    - parameter instance: The instance to predict
    
    - returns: The predicted label
    */
    public func predict(instance: Instance) -> Int {
        let vector = instance.featureVector
        let sum = multiplyVectors(self.w, vector: vector)
        let prediction = calculateLinkFunction(sum)
        
        return prediction >= 0.5 ? 1 : 0
    }
    
    /**
    Calculates the logistic link function
    
    - parameter z: The parameter of the link function
    
    - returns: The real valued result bounded by [0, 1]
    */
    private func calculateLinkFunction(z: Double) -> Double {
        return 1.0 / (1 + exp(-z))
    }
    
    /**
    Calculates the inner product of the parameter vector and a feature vector.
    Uses 0 as value for keys not present in the parameter vector
    
    - parameter w:      The parameter vector
    - parameter vector: The feature vector
    
    - returns: The inner product
    */
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