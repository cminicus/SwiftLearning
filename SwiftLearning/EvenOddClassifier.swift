// EvenOddClassifier.swift
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
    A weak learner that guess based on which features (even or odd) have the
    greatest sum of values
*/
public class EvenOddClassifier: Classifier {
    
    /// Internal prediction which is independent of input instance
    private var prediction: Int!
    
    /**
    Trains the classifier by adding the values for even and odd feature keys
    and picking whichever sum is highest
    
    - parameter instances: The instances used to train the classifier
    */
    public func train(instances: [Instance]) {
        var evenSum = 0.0
        var oddSum = 0.0
        
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
        }
        
        self.prediction = evenSum >= oddSum ? 1 : 0
    }
    
    /**
    Predicts the label of the given instance by returning the most common
    label from the training data
    
    - parameter instance: The instance to predict
    
    - returns: The predicted label
    */
    public func predict(instance: Instance) -> Int {
        return self.prediction
    }
    
}