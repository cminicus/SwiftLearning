//
//  MNISTDataReader.swift
//  SwiftLearning
//
//  Created by Clayton Minicus on 11/21/15.
//  Copyright © 2015 Clayton Minicus. All rights reserved.
//

import Foundation

public class MNISTDataReader {
    
    private static let labelName = "labels"
    private static let imageName = "images"
    
    public static func readTrainData() -> [Instance] {
        
        guard let frameworkBundle = NSBundle(
            identifier: "com.claytonminicus.SwiftLearning") else {
                return []
        }
        
        guard let labelPath = frameworkBundle.pathForResource(
            labelName, ofType: "train") else {
                return []
        }
        
        guard let imagePath = frameworkBundle.pathForResource(
            imageName, ofType: "train") else {
                return []
        }
        
        let labelData = NSData(contentsOfFile: labelPath)!
        let imageData = NSData(contentsOfFile: imagePath)!

        var labelLocation = 8
        var imageLocation = 16
        
        let totalCount = 60000
        
        var instances = [Instance]()
        
        for _ in 0..<totalCount {
            
            var label: UInt8 = 0
            let labelRange = NSRange(location: labelLocation, length: 1)
            labelData.getBytes(&label, range: labelRange)
            labelLocation++
            
            let featureVector = FeatureVector()
            
            var array = [Double](count: 784, repeatedValue: 0.0)
            for i in 0..<(28 * 28) {
                var value: UInt8 = 0
                let imageRange = NSRange(location: imageLocation, length: 1)
                imageData.getBytes(&value, range: imageRange)
                imageLocation++
                
                array[i] = Double(value) / 255.0
            }
            
            featureVector.valueArray = array
            let instance = Instance(featureVector: featureVector, label: Int(label))
            instances.append(instance)
            print(Double(instances.count) / Double(totalCount) * 100)
        }
        
        return instances
    }
    
    public static func readTestData() -> [Instance] {
        guard let frameworkBundle = NSBundle(
            identifier: "com.claytonminicus.SwiftLearning") else {
                return []
        }
        
        guard let labelPath = frameworkBundle.pathForResource(
            labelName, ofType: "test") else {
                return []
        }
        
        guard let imagePath = frameworkBundle.pathForResource(
            imageName, ofType: "test") else {
                return []
        }
        
        let labelData = NSData(contentsOfFile: labelPath)!
        let imageData = NSData(contentsOfFile: imagePath)!
        
        var labelLocation = 8
        var imageLocation = 16
        
        let totalCount = 10000
        
        var instances = [Instance]()
        
        for _ in 0..<totalCount {
            
            var label: UInt8 = 0
            let labelRange = NSRange(location: labelLocation, length: 1)
            labelData.getBytes(&label, range: labelRange)
            labelLocation++
            
            let featureVector = FeatureVector()
            
            var array = [Double](count: 784, repeatedValue: 0.0)
            for i in 0..<(28 * 28) {
                var value: UInt8 = 0
                let imageRange = NSRange(location: imageLocation, length: 1)
                imageData.getBytes(&value, range: imageRange)
                imageLocation++
                
                array[i] = Double(value) / 255.0
            }
            
            featureVector.valueArray = array
            let instance = Instance(featureVector: featureVector, label: Int(label))
            instances.append(instance)
            print(Double(instances.count) / Double(totalCount) * 100)
        }
        
        return instances
    }
    
}
