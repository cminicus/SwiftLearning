//
//  NeuralNetworkTests.swift
//  SwiftLearning
//
//  Created by Clayton Minicus on 10/26/15.
//  Copyright © 2015 Clayton Minicus. All rights reserved.
//

import XCTest
@testable import SwiftLearning

class NeuralNetworkTests: XCTestCase {
    
    func testThatNeuralNetworkOperatesCorrection() {
        let dataReader = DataReader(fileName: "mnist-full")
        let trainInstances = dataReader.readTrainData()
        let testInstances = dataReader.readTestData()
        
//        let train = MNISTDataReader.readTrainData()
        
        let network = NeuralNetworkClassifier(layers: [784, 30, 10])
        network.trainAndEvaluate(trainInstances, evaluation: testInstances)
    }
}
