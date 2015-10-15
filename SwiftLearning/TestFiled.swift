//
//  TestFiled.swift
//  SwiftLearning
//
//  Created by Clayton Minicus on 10/15/15.
//  Copyright © 2015 Clayton Minicus. All rights reserved.
//

import Foundation

public class WhatsUp {
    
    private var name: String!
    
    public init(name: String) {
        self.name = name
    }
    
    public func sayMyName() {
        print(self.name)
    }
    
}