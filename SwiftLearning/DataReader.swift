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
        
        guard let frameworkBundle = NSBundle(identifier: "com.claytonminicus.SwiftLearning") else {
            return []
        }
        
        guard let path = frameworkBundle.pathForResource(fileName, ofType: "train") else {
            return []
        }

        do {
            let content = try String(contentsOfFile:path, encoding: NSUTF8StringEncoding)
            let contentArray = content.componentsSeparatedByString("\n")
            
            var instances = [Instance]()
            
            for instanceString in contentArray {
                let splitLine = instanceString.componentsSeparatedByString(" ")
//                splitLine.strin
                
                
                
                let label = Int(splitLine.first!)!
                let featureVector = FeatureVector()
                
                for i in 1..<splitLine.count {
                    let feature = splitLine[i]
                    let keyAndValue = feature.componentsSeparatedByString(":")
                    let key = keyAndValue.first!
                    let value = keyAndValue.last!
                    featureVector.append(Int(key)!, value: Double(value)!)
                }
                instances.append(Instance(featureVector: featureVector, label: label))
                print(Float(instances.count) / Float(contentArray.count))
            }
            
            return instances
            
        } catch _ as NSError {
            return []
        }
    }
    
}