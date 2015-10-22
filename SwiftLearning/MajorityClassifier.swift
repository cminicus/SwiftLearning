// MajorityClassifier.swift
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
    A weak learner that simply guess based on which label appears most often
*/
public class MajorityClassifier: Classifier {
    
    /// Internal prediction which is independent of input instance
    private var prediction: Int!
    
    /**
    Trains the classifier by adding total number of each label and setting the
    internal prediction to the label that appears most
    
    - parameter instances: The instances used to train the classifier
    */
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