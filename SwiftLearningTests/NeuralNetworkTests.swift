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
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitWorks() {
        let n = NeuralNetworkClassifier(layers: [784, 30, 10])
    }
    
}
