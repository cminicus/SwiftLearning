//
//  DataReader.swift
//  SwiftLearning
//
//  Created by Clayton Minicus on 10/15/15.
//  Copyright © 2015 Clayton Minicus. All rights reserved.
//

import Foundation

public class DataReader {
    
    private let fileName: String
    
    public init(fileName: String) {
        self.fileName = fileName
    }
    
    public func readData() -> [Instance] {
        
        let path2 = NSBundle.mainBundle().pathForResource("speech_test", ofType: "txt")
        
        guard let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "txt") else {
            return []
        }

//        let content = String(
        
//        guard let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "txt") else {
//            return nil
//        }
        
        do {
            let content = try String(contentsOfFile:path, encoding: NSUTF8StringEncoding)
            
            let contentArray = content.componentsSeparatedByString("\n")
            
            print(contentArray)
            
//            return content.componentsSeparatedByString("\n")
        } catch _ as NSError {
            return []
        }
        
        
        return []
    }
    
}