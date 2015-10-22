// ClassifierAccuracyTests.swift
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
