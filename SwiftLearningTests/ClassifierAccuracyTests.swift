//
//  MajorityClassifierTests.swift
//  SwiftLearning
//
//  Created by Clayton Minicus on 10/15/15.
//  Copyright © 2015 Clayton Minicus. All rights reserved.
//

import XCTest
@testable import SwiftLearning

class ClassifierAccuracyTests: ClassifierBaseTest {

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
        
        let (majorityTrainAccuracy, majorityTestAccuracy) =
            trainAndEvaluateClassifier(majorityClassifier)
        
        // weird bug with this if using DBL_EPSILON
        XCTAssertEqualWithAccuracy(majorityTrainAccuracy, 50.75, accuracy: 0.01)
        XCTAssertEqualWithAccuracy(majorityTestAccuracy, 51.0, accuracy: DBL_EPSILON)
        
        
        // ------------------------- Even-Odd ----------------------------------
        let evenOddClassifier = EvenOddClassifier()

        let (evenOddTrainAccuracy, evenOddTestAccuracy) =
            trainAndEvaluateClassifier(evenOddClassifier)
        
        XCTAssertEqualWithAccuracy(evenOddTrainAccuracy, 49.25, accuracy: DBL_EPSILON)
        XCTAssertEqualWithAccuracy(evenOddTestAccuracy, 49.0, accuracy: DBL_EPSILON)
        
        
        // --------------------- Logistic Regression ---------------------------
        let logisticRegressionClassifier = LogisticRegressionClassifier()

        let (logisticTrainAccuracy, logisticTestAccuracy) =
            trainAndEvaluateClassifier(logisticRegressionClassifier)
        
        XCTAssertEqualWithAccuracy(logisticTrainAccuracy, 96.5, accuracy: DBL_EPSILON)
        XCTAssertEqualWithAccuracy(logisticTestAccuracy, 88.0, accuracy: DBL_EPSILON)
        
        
        // -------------------------- Pegasos ----------------------------------
        let pegasosRegressionClassifier = PegasosClassifier()
        
        let (pegasosTrainAccuracy, pegasosTestAccuracy) =
            trainAndEvaluateClassifier(pegasosRegressionClassifier)
        
        XCTAssertEqualWithAccuracy(pegasosTrainAccuracy, 100.0, accuracy: DBL_EPSILON)
        XCTAssertEqualWithAccuracy(pegasosTestAccuracy, 88.0, accuracy: DBL_EPSILON)
    }
    
    // Helper function to train and test each classifier
    func trainAndEvaluateClassifier(classifier: Classifier) -> (Double, Double) {
        classifier.train(self.trainInstances)
        let accuracyEvaluator = AccuracyEvaluator()
        
        let trainAccuracy = accuracyEvaluator.evaluate(
            self.trainInstances,
            classifier: classifier
        )
        
        let testAccuracy = accuracyEvaluator.evaluate(
            self.testInstances,
            classifier: classifier
        )
        return (trainAccuracy, testAccuracy)
    }
}
