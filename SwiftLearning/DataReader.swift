// DataReader.swift
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

import Foundation

public class DataReader {
    
    private let fileName: String
    
    public init(fileName: String) {
        self.fileName = fileName
    }
    
    public func readTrainData() -> [Instance] {
        
        guard let frameworkBundle = NSBundle(
            identifier: "com.claytonminicus.SwiftLearning") else {
            return []
        }
        
        guard let path = frameworkBundle.pathForResource(
            fileName, ofType: "train") else {
            return []
        }

        do {
            let content = try String(
                contentsOfFile:path,
                encoding: NSUTF8StringEncoding
            )
            let contentArray = content.componentsSeparatedByString("\n")
            
            var instances = [Instance]()
            
            for instanceString in contentArray {
                let splitLine = instanceString.componentsSeparatedByString(" ")
                if splitLine.count == 1 {
                    continue
                }
                let label = Int(splitLine.first!)!
                let featureVector = FeatureVector()
                featureVector.preSortedData = true
                
                for i in 1..<splitLine.count {
                    let feature = splitLine[i]
                    if feature == "" {
                        continue
                    }
                    let keyAndValue = feature.componentsSeparatedByString(":")
                    let key = keyAndValue.first!
                    let value = keyAndValue.last!
                    featureVector.add(Int(key)!, value: Double(value)!)
                }
                let instance = Instance(
                    featureVector: featureVector,
                    label: label
                )
                instances.append(instance)
                
                print(Float(instances.count) / Float(contentArray.count) * 100)
            }
            
            return instances
            
        } catch _ as NSError {
            return []
        }
    }
    
    public func readTestData() -> [Instance] {
        guard let frameworkBundle = NSBundle(
            identifier: "com.claytonminicus.SwiftLearning") else {
            return []
        }
        
        guard let path = frameworkBundle.pathForResource(
            fileName, ofType: "test") else {
            return []
        }
        
        do {
            let content = try String(
                contentsOfFile:path,
                encoding: NSUTF8StringEncoding
            )
            let contentArray = content.componentsSeparatedByString("\n")
            
            var instances = [Instance]()
            
            for instanceString in contentArray {
                let splitLine = instanceString.componentsSeparatedByString(" ")
                if splitLine.count == 1 {
                    continue
                }
                let label = Int(splitLine.first!)!
                let featureVector = FeatureVector()
                featureVector.preSortedData = true
                
                for i in 1..<splitLine.count {
                    let feature = splitLine[i]
                    if feature == "" {
                        continue
                    }
                    let keyAndValue = feature.componentsSeparatedByString(":")
                    let key = keyAndValue.first!
                    let value = keyAndValue.last!
                    featureVector.add(Int(key)!, value: Double(value)!)
                }
                instances.append(Instance(featureVector: featureVector, label: label))
                print(Float(instances.count) / Float(contentArray.count) * 100)
            }
            
            return instances
            
        } catch _ as NSError {
            return []
        }
    }
    
}