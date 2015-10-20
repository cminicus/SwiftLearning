//
//  MajorityClassifierTests.swift
//  SwiftLearning
//
//  Created by Clayton Minicus on 10/15/15.
//  Copyright © 2015 Clayton Minicus. All rights reserved.
//

import XCTest
@testable import SwiftLearning

class MajorityClassifierTests: ClassifierBaseTest {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testThatClassifiersAreAccurate() {
        // ------------------------- Majority ----------------------------------
        let majorityClassifier = MajorityClassifier()
        majorityClassifier.train(self.trainInstances)
        
        let evaluator = AccuracyEvaluator()
        let majorityTrainAccuracy = evaluator.evaluate(
            self.trainInstances,
            classifier: majorityClassifier
        )
        print("Majority Classifier - Train: \(majorityTrainAccuracy)")
        // weird bug with this if using DBL_EPSILON
        XCTAssertEqualWithAccuracy(majorityTrainAccuracy, 50.75, accuracy: 0.01)
        
        
        let majorityTestAccuracy = evaluator.evaluate(
            self.testInstances,
            classifier: majorityClassifier
        )
        print("Majority Classifier - Test: \(majorityTestAccuracy)")
        XCTAssertEqualWithAccuracy(majorityTestAccuracy, 51.0, accuracy: DBL_EPSILON)
        
        
        // ------------------------- Even-Odd ----------------------------------
        let evenOddClassifier = EvenOddClassifier()
        evenOddClassifier.train(self.trainInstances)
        let evenOddTrainAccuracy = evaluator.evaluate(
            self.trainInstances,
            classifier: evenOddClassifier
        )
        print("Even-Odd Classifier - Train: \(evenOddTrainAccuracy)")
        XCTAssertEqualWithAccuracy(evenOddTrainAccuracy, 49.25, accuracy: DBL_EPSILON)
        
        let evenOddTestAccuracy = evaluator.evaluate(
            self.testInstances,
            classifier: evenOddClassifier
        )
        print("Even-Odd Classifier - Test: \(evenOddTestAccuracy)")
        XCTAssertEqualWithAccuracy(evenOddTestAccuracy, 49.0, accuracy: DBL_EPSILON)
        
        
        // --------------------- Logistic Regression ---------------------------
        let logisticRegressionClassifier = LogisticRegressionClassifier()
        logisticRegressionClassifier.train(self.trainInstances)
        let logisticTrainAccuracy = evaluator.evaluate(
            self.trainInstances,
            classifier: logisticRegressionClassifier
        )
        print("Logistic Regression Classifier - Train: \(logisticTrainAccuracy)")
        XCTAssertEqualWithAccuracy(logisticTrainAccuracy, 96.5, accuracy: DBL_EPSILON)
        
        let logisticTestAccuracy = evaluator.evaluate(
            self.testInstances,
            classifier: logisticRegressionClassifier
        )
        print("Logistic Regression Classifier - Test: \(logisticTestAccuracy)")
        XCTAssertEqualWithAccuracy(logisticTestAccuracy, 88.0, accuracy: DBL_EPSILON)
        
        
        // -------------------------- Pegasos ----------------------------------
        let pegasosRegressionClassifier = PegasosClassifier()
        pegasosRegressionClassifier.train(self.trainInstances)
        let pegasosTrainAccuracy = evaluator.evaluate(
            self.trainInstances,
            classifier: pegasosRegressionClassifier
        )
        print("Pegasos Classifier - Train: \(pegasosTrainAccuracy)")
        XCTAssertEqualWithAccuracy(pegasosTrainAccuracy, 100.0, accuracy: DBL_EPSILON)
        
        let pegasosTestAccuracy = evaluator.evaluate(
            self.testInstances,
            classifier: pegasosRegressionClassifier
        )
        print("Pegasos Classifier - Test: \(pegasosTestAccuracy)")
        XCTAssertEqualWithAccuracy(pegasosTestAccuracy, 88.0, accuracy: DBL_EPSILON)
    }

}
