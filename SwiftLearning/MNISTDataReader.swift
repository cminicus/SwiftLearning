//
//  MNISTDataReader.swift
//  SwiftLearning
//
//  Created by Clayton Minicus on 11/21/15.
//  Copyright © 2015 Clayton Minicus. All rights reserved.
//

import Foundation

public class MNISTDataReader {
    
    private static let trainLabelName = "train-labels"
    private static let trainImageName = "train-images"
    private static let testLabelName = "test-labels"
    private static let testImageName = "test-images"
    
    public static func readTrainData() -> [Instance] {
        
        guard let frameworkBundle = NSBundle(
            identifier: "com.claytonminicus.SwiftLearning") else {
                return []
        }
        
        guard let labelPath = frameworkBundle.pathForResource(
            trainLabelName, ofType: "train") else {
                return []
        }
        
        guard let imagePath = frameworkBundle.pathForResource(
            trainImageName, ofType: "train") else {
                return []
        }
        
        do {
            let labelContent = try String(
                contentsOfFile:labelPath,
                encoding: NSUTF8StringEncoding
            )
            
            let imageContent = try String(
                contentsOfFile:imagePath,
                encoding: NSUTF8StringEncoding
            )
            
            let labelArray = labelContent.componentsSeparatedByString("\n")
            let imageArray = imageContent.componentsSeparatedByString("\n")
            
            var instances = [Instance]()
            
            for (labelString, imageString) in zip(labelArray, imageArray) {
                let splitLine = imageString.componentsSeparatedByString(" ")
                if splitLine.count == 1 {
                    continue
                }
                let label = Int(labelString)!
                let featureVector = FeatureVector()
                featureVector.preSortedData = true
                
                for i in 1..<splitLine.count {
                    let feature = splitLine[i]
                    if feature == "" {
                        continue
                    }
                    
                    featureVector.add(i - 1, value: Double(feature)! / 255.0)
                }
                let instance = Instance(
                    featureVector: featureVector,
                    label: label
                )
                instances.append(instance)
                
                print(Float(instances.count) / Float(labelArray.count) * 100)
            }
            
            return instances
            
        } catch let e as NSError {
            print(e)
            return []
        }
    }
    
//    public func readTestData() -> [Instance] {
//        guard let frameworkBundle = NSBundle(
//            identifier: "com.claytonminicus.SwiftLearning") else {
//                return []
//        }
//        
//        guard let path = frameworkBundle.pathForResource(
//            fileName, ofType: "test") else {
//                return []
//        }
//        
//        do {
//            let content = try String(
//                contentsOfFile:path,
//                encoding: NSUTF8StringEncoding
//            )
//            let contentArray = content.componentsSeparatedByString("\n")
//            
//            var instances = [Instance]()
//            
//            for instanceString in contentArray {
//                let splitLine = instanceString.componentsSeparatedByString(" ")
//                if splitLine.count == 1 {
//                    continue
//                }
//                let label = Int(splitLine.first!)!
//                let featureVector = FeatureVector()
//                featureVector.preSortedData = true
//                
//                for i in 1..<splitLine.count {
//                    let feature = splitLine[i]
//                    if feature == "" {
//                        continue
//                    }
//                    let keyAndValue = feature.componentsSeparatedByString(":")
//                    let key = keyAndValue.first!
//                    let value = keyAndValue.last!
//                    if fileName == "mnist" {
//                        featureVector.add(Int(key)!, value: Double(value)! / 255.0)
//                    } else {
//                        featureVector.add(Int(key)!, value: Double(value)!)
//                    }
//                    
//                }
//                instances.append(Instance(featureVector: featureVector, label: label))
//                print(Float(instances.count) / Float(contentArray.count) * 100)
//            }
//            
//            return instances
//            
//        } catch _ as NSError {
//            return []
//        }
//    }
    
}
