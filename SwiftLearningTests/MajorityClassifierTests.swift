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

    func testThatMajorityClassifierIsAccurate() {
//        self.measureBlock {
//            let majorityClassifier = MajorityClassifier()
//            majorityClassifier.train(self.trainInstances)
//        }
        
        let majorityClassifier = MajorityClassifier()
        majorityClassifier.train(self.trainInstances)
        
        let evaluator = AccuracyEvaluator()
        let correct = evaluator.evaluate(self.testInstances, classifier: majorityClassifier)
        
        XCTAssertTrue(correct > 0.5)
        
        self.measureBlock {
            let c = EvenOddClassifier()
            c.train(self.trainInstances)
        }
        // lol takes .293 seconds if adding -O (not zero) flag in build settings (other swift flags)
        
//        let c = EvenOddClassifier()
//        c.train(self.trainInstances) // takes about 43 seconds...
//        
//        let y = evaluator.evaluate(self.testInstances, classifier: c)
//        _ = 6
        
    }

}
