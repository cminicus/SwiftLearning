//
//  InstanceTests.swift
//  SwiftLearning
//
//  Created by Clayton Minicus on 10/15/15.
//  Copyright © 2015 Clayton Minicus. All rights reserved.
//

import XCTest
@testable import SwiftLearning

class InstanceTests: XCTestCase {

    func testInstanceCreation() {
        // given, then
        let featureVector = FeatureVector()
        let instance = Instance(featureVector: featureVector, label: 1)
        
        // when
        XCTAssertEqual(instance.label, 1)
        XCTAssertNotNil(instance.featureVector)
    }

}
