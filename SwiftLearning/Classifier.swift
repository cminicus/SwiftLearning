//
//  Classifier.swift
//  SwiftLearning
//
//  Created by Clayton Minicus on 10/15/15.
//  Copyright © 2015 Clayton Minicus. All rights reserved.
//

import Foundation

protocol Classifier {
    func train(instances: [Instance])
    func predict(instance: Instance) -> Int
}
