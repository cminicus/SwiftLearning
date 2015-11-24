//
//  NeuralNetwork.swift
//  SwiftLearning
//
//  Created by Clayton Minicus on 10/26/15.
//  Copyright © 2015 Clayton Minicus. All rights reserved.
//

import Foundation
import Accelerate

// potentially create structs for the [[Double]] and [[[Double]]] constructs we often see

public class NeuralNetworkClassifier: Classifier {
    
    /// The number of layers in the network
    private var numberOfLayers: Int
    /// The array of layer sizes in the network
    private var layers: [Int]
    /// The biases for the neural network
    private var biases: [[Double]]
    /// The weights for the neural network
    private var weights: [Matrix<Double>]
    
    /// The number of iterations to train the network for
    private var iterations: Int
    /// The learning rate per feature
    private var eta: Double
    /// The mini batch size to train with
    private var batchSize: Int
    /// The regularization parameter
    private var lambda: Double
    
    public init(layers: [Int],
        iterations: Int = 30,
        batchSize: Int = 10,
        eta: Double = 0.1,
        lambda: Double = 5.0
    ) {
        self.numberOfLayers = layers.count
        self.layers = layers
        self.iterations = iterations
        self.eta = eta
        self.batchSize = batchSize
        self.lambda = lambda
        self.biases = [] // this is dumb, figure it out
        self.weights = []
        self.biases = initializeBiases(true)
        self.weights = initializeWeights(true)
    }
    
    private func initializeBiases(gaussian: Bool) -> [[Double]] {
        var biases: [[Double]] = []
        for (index, layer) in layers.enumerate() {
            // no bias for input layer
            if index == 0 {
                continue
            }
            if gaussian {
                biases.append(randNormals(0.0, 1.0, layer))
            } else {
                biases.append(Array(count: layer, repeatedValue: 0.0))
            }
        }
        return biases
    }
    
    private func initializeWeights(gaussian: Bool) -> [Matrix<Double>] {
        var weights: [Matrix<Double>] = []
        for i in 0..<layers.count - 1 {
            let x = layers[i]
            let y = layers[i + 1]
            
            var matrix = [[Double]]()
            for _ in 0..<y {
                if gaussian {
                    matrix.append(randNormals(0.0, 1.0 / sqrt(Double(x)), x))
                } else {
                    matrix.append(Array(count: x, repeatedValue: 0.0))
                }
            }
            weights.append(Matrix(matrix))
        }
        return weights
    }
    
    // trains with stochastic gradient descent
    public func train(var instances: [Instance]) {
        for _ in 0..<iterations {
            instances = instances.shuffle()
            
            var miniBatches = [[Instance]]()
            for i in 0..<(instances.count / batchSize) {
                let k = i * batchSize
                let slice = Array(instances[k..<(k + batchSize)])
                miniBatches.append(slice)
            }
            
            for miniBatch in miniBatches {
                updateMiniBatch(miniBatch, totalInstances: instances.count)
            }
            evaluate(instances)
        }
    }
    
    public func trainAndEvaluate(var instances: [Instance], evaluation: [Instance]) {
        for _ in 0..<iterations {
            instances = instances.shuffle()
            
            var miniBatches = [[Instance]]()
            for i in 0..<(instances.count / batchSize) {
                let k = i * batchSize
                let slice = Array(instances[k..<(k + batchSize)])
                miniBatches.append(slice)
            }
            
            for miniBatch in miniBatches {
                updateMiniBatch(miniBatch, totalInstances: instances.count)
            }
            evaluate(evaluation)
        }
    }
    
    private func updateMiniBatch(miniBatch: [Instance], totalInstances: Int) {
        // create 0.0 matrix in the same shape as self.biases
        var biasGradient = initializeBiases(false)
        
        // create 0.0 matrix in the same shape as self.weights
        var weightGradient = initializeWeights(false)
        
        // calculate gradient step for each instance in miniBatch
        for instance in miniBatch {
            let (deltaBiasGradient, deltaWeightGradient) = backPropogate(instance)
            
            // update bias gradients
            for b in 0..<biasGradient.count {
                biasGradient[b] = biasGradient[b] + deltaBiasGradient[b]
            }
            
            // update weight gradients
            for w in 0..<weightGradient.count {
                weightGradient[w] = weightGradient[w] + deltaWeightGradient[w]
            }
        }
        
        // update weights and biases
        let batchLearningRate = eta / Double(miniBatch.count)
        let weightRegulation = 1.0 - eta * (lambda / Double(totalInstances))
        
        for (index, gradient) in biasGradient.enumerate() {
            // b = b - eta/length * gradient
            biases[index] = biases[index] - (gradient * batchLearningRate)
        }
        
        for (index, gradient) in weightGradient.enumerate() {
            // w = w * regulation - eta/length * gradient
            weights[index] = (weightRegulation * weights[index]) - (batchLearningRate * gradient)
        }
    }
    
    private func backPropogate(instance: Instance) -> ([[Double]], [Matrix<Double>]) {
        
        var biasGradient = initializeBiases(false)
        var weightGradient = initializeWeights(false)
        
        var activation = instance.featureVector.valueArray()
        var activations = [activation]
        var zs = [[Double]]() // z vectors, layer by layer
        
        // forward pass
        for (bias, weight) in zip(biases, weights) {
            let z = dotProductAndAdd(activation, weight, bias)
            zs.append(z)
            activation = sigmoid(z)
            activations.append(activation)
        }
        
        // backwards pass
        var delta = cost(activations.last!, label: instance.label)
        biasGradient[biasGradient.count - 1] = delta
        weightGradient[weightGradient.count - 1] = delta ** activations[activations.count - 2]
        
        for i in 2..<numberOfLayers {
            let z = zs[zs.count - i]
            let sp = sigmoidPrime(z)
            
            let weight = weights[weights.count - i + 1]
            delta = (delta • weight′) * sp
            biasGradient[biasGradient.count - i] = delta
            
            let activation = activations[activations.count - i - 1]
            weightGradient[weightGradient.count - i] = delta ** activation
        }
        
        return (biasGradient, weightGradient)
    }
    
    public func predict(instance: Instance) -> Int {
        return 0
    }
    
    public func evaluate(instances: [Instance]) {
        var correct = 0
        let total = instances.count
        for instance in instances {
            let output = feedForward(instance.featureVector.valueArray())
            let predicition = convertArrayToLabel(output)
            if predicition == instance.label {
                correct++
            }
        }
        print(Double(correct) / Double(total) * 100)
    }
    
    private func cost(activations: [Double], label: Int) -> [Double] {
        let labelArray = convertLabelToArray(label)
        return activations - labelArray
    }
    
    private func convertLabelToArray(label: Int) -> [Double] {
        var labelArray = [Double](count: 10, repeatedValue: 0.0)
        labelArray[label] = 1.0
        return labelArray
    }
    
    private func convertArrayToLabel(array: [Double]) -> Int {
        return array.indexOf(array.maxElement()!)!
    }
    
    private func sigmoid(z: Double) -> Double {
        return 1.0 / (1.0 + exp(-z))
    }
    
    private func sigmoid(array: [Double]) -> [Double] {
        return array.map { sigmoid($0) }
    }
    
    private func sigmoidPrime(z: [Double]) -> [Double] {
        return sigmoid(z) * (1.0 - sigmoid(z))
    }
    
    private func feedForward(var a: [Double]) -> [Double] {
        for (bias, weight) in zip(biases, weights) {
            let operand = dotProductAndAdd(a, weight, bias)
            a = sigmoid(operand)
        }
        return a
    }
}