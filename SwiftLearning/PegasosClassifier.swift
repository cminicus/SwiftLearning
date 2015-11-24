// PegasosClassifier.swift
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
    A learner using the "Primal Estimated sub-GrAdient SOlver for SVM" or
    Pegasos. This implementation is non-sparse and therefore the maximum size of
    the feature vectors must be known in advance. The learner enforces a margin 
    of 1 and achieves a solution with accuracy π in O(1/π)
*/
public class PegasosClassifier: Classifier {
    
    /// Internal non-sparse array of parameters
    private var w: [Double]!
    /// The regularization parameter for the learning step 
    private var lambda: Double
    /// The number of iterations to train the data on
    private var iterations: Int
    /// The global time step used in calculating the update step
    private var t: Int
    
    /// Whether or not to shuffle data before each iteration
    public var shuffleData = false
    
    /**
    Initializes the classifier with optional lambda and iterations parameters
    
    - parameter lambda:     Value used in calculations for the learning rate, defaults to 0.01
    - parameter iterations: The number of iterations on which to train the classifier, defaults to 20
    
    - returns: A PegasosClassifier instance
    */
    public init(lambda: Double = 0.0001, iterations: Int = 20) {
        self.iterations = iterations
        self.lambda = lambda
        self.t = 1
    }
    
    /**
    Trains the classifier using a non-sparse implementation. Every parameter
    is updated even if the particular feature does not include that key. The
    learning step for each parameter is based off of the global time step and
    the regularization parameter. Inner product predictions are penalized for
    being less than 1, which enforces a margin in space of 1.
    
    
    - parameter instances: The instances used to train the classifier
    */
    public func train(var instances: [Instance]) {
        // initialize parameter vector to proper size
        initializeW(instances)
        
        let total = Double(iterations * instances.count)
        
        for _ in 0..<iterations {
            // shuffle data if needed
            if shuffleData {
                instances = instances.shuffle()
            }
            
            for instance in instances {
                var label = instance.label
                let vector = instance.featureVector
               
                // SVMs are {-1, 1} - need to convert 0 to -1
                if label == 0 {
                    label = -1
                }
                
                // calculate inner product
                let product = Double(label) * innerProduct(
                    self.w,
                    vector: vector
                )
                // update every value in w every time
                for (key, value) in w.enumerate() {
                    // update that happens regardless
                    var baseValue = (1.0 - 1.0 / Double(self.t)) * value
                    // update that only happens when inner product is wrong or
                    // within the margin of 1
                    if product < 1 {
                        let x_i_t = vector.containsKey(key) ? vector.get(key)! : 0
                        baseValue += (1.0 / (lambda * Double(self.t))) * Double(label) * x_i_t
                    }
                    // set new parameter
                    w[key] = baseValue
                }
                // increment global time step
                self.t++
                print(Double(self.t - 1) / total * 100)
            }
        }
    }
    
    /**
    Predicts the label of the given instance by calculating the inner product
    of the instance vector with the internal parameter vector and determining
    which direction the prediction is in space, either positive or negative.
    
    - parameter instance: The instance to predict
    
    - returns: The predicted label
    */
    public func predict(instance: Instance) -> Int {
        let vector = instance.featureVector
        let prediction = innerProduct(self.w, vector: vector)
        return prediction >= 0 ? 1 : 0
    }
    
    /**
    Initializes the size of the w vector since this is non-spare implementation
    
    - parameter instances: The array of instances to find the maximum value of
    */
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
    
    /**
    Calculates the inner product of the parameter vector and a feature vector.
    Uses 0 as value for keys not present in the feature vector
    
    - parameter w:      The parameter vector
    - parameter vector: The feature vector
    
    - returns: The inner product
    */
    private func innerProduct(w: [Double], vector: FeatureVector) -> Double {
        var sum = 0.0
        let wSize = w.count
        // potentially use surge here? Filter the the vector or w so that 
        // they only contain the values in each other (so if the vector does
        // have key 2, then don't include that in w, and use the surge dot product
        // function. Might be quicker??
        
        let keys = vector.keyArray()
        for key in keys {
            let value = vector.get(key)!
            if key < wSize {
                sum += (value * w[key])
            }
        }
        return sum
        
        // jury is still out here
//        var vectorValues = [Double]()
//        for (index, _) in w.enumerate() {
//            let value = vector.get(index)
//            if value == nil {
//                vectorValues.append(0.0)
//            } else {
//                vectorValues.append(value!)
//            }
//        }
//        
//        return dot(w, y: vectorValues)
    }
}
