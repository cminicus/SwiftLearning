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
    
    private var numberOfLayers: Int
    private var layers: [Int]
    /// The biases for the neural network
    private var biases: [[Double]]
    /// The weights for the neural network
    private var weights: [[[Double]]]
    // each index in w is a matrix
    // for example w[1] connects the second and third layers
    // the jth and kth index in w[1] is the weight for 
    // kth neuron in the second layer and the jth neuron in the third layer
    
    private var iterations: Int
    private var eta: Double
    private var batchSize: Int
    
    public init(iterations: Int = 20, eta: Double = 0.01, batchSize: Int = 10, layers: [Int]) {
        self.numberOfLayers = layers.count
        self.layers = layers
        self.iterations = iterations
        self.eta = eta
        self.batchSize = batchSize
        self.biases = []
        self.weights = []
        
        initializeBiases()
        initializeWeights()
    }
    
    private func initializeBiases() {
        for (index, layer) in layers.enumerate() {
            // no bias for input layer
            if index == 0 {
                continue
            }
            self.biases.append(randNormals(0.0, 1.0, layer))
        }
    }
    
    private func initializeWeights() {
        // there is one less matrix in w than there are layers
        // each matrix connects two layers
        for i in 0..<layers.count - 1 {
            let x = layers[i]
            let y = layers[i + 1]
            
            var matrix = [[Double]]()
            for _ in 0..<y {
                matrix.append(randNormals(0.0, 1.0, x))
            }
            self.weights.append(matrix)
        }
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
                updateMiniBatch(miniBatch)
            }
        }
    }
    
    private func updateMiniBatch(miniBatch: [Instance]) {
        // create 0.0 matrix in the same shape as self.biases
        var biasGradient = [[Double]]()
        for (index, layer) in layers.enumerate() {
            if index == 0 {
                continue
            }
            biasGradient.append(Array(count: layer, repeatedValue: 0.0))
        }
        
        // create 0.0 matrix in the same shape as self.weights
        var weightGradient = [[[Double]]]()
        for i in 0..<layers.count - 1 {
            let x = layers[i]
            let y = layers[i + 1]
            
            var matrix = [[Double]]()
            for _ in 0..<y {
                matrix.append(Array(count: x, repeatedValue: 0.0))
//                matrix.append([Double](count: x, repeatedValue: 0.0))
            }
            weightGradient.append(matrix)
        }
        
        // calculate gradient step for each instance in miniBatch
        for instance in miniBatch {
            let (deltaBiasGradient, deltaWeightGradient) = backPropogate(instance)
            biasGradient += deltaBiasGradient
            weightGradient += deltaWeightGradient
        }
        
        // update weights and biases
        // use vsp/accelerate here for subtraction and division and such
    }
    
    private func backPropogate(instance: Instance) -> ([[Double]], [[[Double]]]) {
        
        
        return ([[]], [[[]]])
    }
    
    public func predict(instance: Instance) -> Int {
        return 0
    }
    
    private func sigmoid(z: Double) -> Double {
        return 1.0 / (1.0 + exp(-z))
    }
    
    // this is predict?
    // nope, predict is taking this array of activations and 
    // turning them into 1 output
    // although we will take activations and turn it into an instance,
    // then use the instance's feature vector as the activations
    private func feedForward(var activations: [Double]) -> [Double] {
        for i in 0..<layers.count - 1 {
            let bias = biases[i]
            let weight = weights[i]
            
            // MARK: - THIS MAY BE MATRIX MULTIPLICATION
            // activations should resize as it goes through this
            // to be the size of the previous layer's node count
            
            // Matrix multplication of activations and weight and weight plus bias
            // np.dot(a,w) does matrix multiplication for matrices
            
            // Actually oh wait, yeah that's what I'm doing
            // here innerProduct and bias should be the same length (assert?)
            // the only thing is that we have to reinitialize the size of activations
            // each time we do the inner Product to it's correct size
            
            // However, this all will be faster with the accelerate framework
            // vDSP_etc
            let innerProduct = dotProduct(activations, matrix: weight)
            
            var addedBias = [Double]()
            for (index, b) in bias.enumerate() {
                addedBias.append(b + innerProduct[index])
            }
            
            for (index, value) in addedBias.enumerate() {
                activations[index] = sigmoid(value)
            }
        }
        return activations
    }
    
    private func dotProduct(array: [Double], matrix: [[Double]]) -> [Double] {
        var returnVector = [Double]()
        for column in matrix {
            var sum = 0.0
            for (index, value) in column.enumerate() {
                sum += (value * array[index])
            }
            returnVector.append(sum)
        }
        return returnVector
    }
}