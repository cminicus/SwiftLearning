//
//  Instance.swift
//  SwiftLearning
//
//  Created by Clayton Minicus on 10/15/15.
//  Copyright © 2015 Clayton Minicus. All rights reserved.
//

import Foundation

public class Instance {
    
    var featureVector: FeatureVector
    var label: Int
    
    public init(featureVector: FeatureVector, label: Int) {
        self.featureVector = featureVector
        self.label = label
    }
    
}