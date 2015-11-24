//
//  Operators.swift
//  SwiftLearning
//
//  Created by Clayton Minicus on 11/22/15.
//  Copyright © 2015 Clayton Minicus. All rights reserved.
//

import Foundation
import Accelerate

// --------------------------- Vector Functions --------------------------------

// MARK: Dot Product

public func dot(x: [Float], y: [Float]) -> Float {
    precondition(x.count == y.count, "Vectors must have equal count")
    
    var result: Float = 0.0
    vDSP_dotpr(x, 1, y, 1, &result, vDSP_Length(x.count))
    
    return result
}


public func dot(x: [Double], y: [Double]) -> Double {
    precondition(x.count == y.count, "Vectors must have equal count")
    
    var result: Double = 0.0
    vDSP_dotprD(x, 1, y, 1, &result, vDSP_Length(x.count))
    
    return result
}

// MARK: Vector Scalar Multiplication

public func mul(x: [Float], var y: Float) -> [Float] {
    var results = [Float](count: x.count, repeatedValue: 0.0)
    vDSP_vsmul(x, 1, &y, &results, 1, vDSP_Length(x.count))
    
    return results
}

public func mul(x: [Double], var y: Double) -> [Double] {
    var results = [Double](count: x.count, repeatedValue: 0.0)
    vDSP_vsmulD(x, 1, &y, &results, 1, vDSP_Length(x.count))
    
    return results
}

// MARK: Vector Multiplication

public func mul(x: [Float], y: [Float]) -> [Float] {
    var results = [Float](count: x.count, repeatedValue: 0.0)
    vDSP_vmul(x, 1, y, 1, &results, 1, vDSP_Length(x.count))
    
    return results
}

public func mul(x: [Double], y: [Double]) -> [Double] {
    var results = [Double](count: x.count, repeatedValue: 0.0)
    vDSP_vmulD(x, 1, y, 1, &results, 1, vDSP_Length(x.count))
    
    return results
}

public func rowMulCol(x: [Double], y: [Double]) -> Matrix<Double> {
    let m = Int32(x.count)
    let n = Int32(y.count)
    
    var ret = Matrix(rows: x.count, columns: y.count, repeatedValue: 0.0)
    cblas_dger(CblasRowMajor, m, n, 1, x, 1, y, 1, &(ret.grid), n)
    
    return ret
}

// --------------------------- Vector Operators --------------------------------

// row vector times column vector
infix operator ** {}
func ** (lhs: [Double], rhs: [Double]) -> Matrix<Double> {
    return rowMulCol(lhs, y: rhs)
}

func + (lhs: [Float], rhs: [Float]) -> [Float] {
    return add(lhs, y: rhs)
}

func + (lhs: [Double], rhs: [Double]) -> [Double] {
    return add(lhs, y: rhs)
}

func - (lhs: [Float], rhs: [Float]) -> [Float] {
    return add(lhs, y: neg(rhs))
}

func - (lhs: [Double], rhs: [Double]) -> [Double] {
    return add(lhs, y: neg(rhs))
}

func - (lhs: Double, rhs: [Double]) -> [Double] {
    return add([Double](count: rhs.count, repeatedValue: lhs), y: neg(rhs))
}

func - (lhs: Float, rhs: [Float]) -> [Float] {
    return add([Float](count: rhs.count, repeatedValue: lhs), y: neg(rhs))
}

func * (lhs: [Float], rhs: [Float]) -> [Float] {
    return mul(lhs, y: rhs)
}

func * (lhs: [Double], rhs: [Double]) -> [Double] {
    return mul(lhs, y: rhs)
}

func * (lhs: [Float], rhs: Float) -> [Float] {
    return mul(lhs, y: [Float](count: lhs.count, repeatedValue: rhs))
}

func * (lhs: [Double], rhs: Double) -> [Double] {
    return mul(lhs, y: [Double](count: lhs.count, repeatedValue: rhs))
}

infix operator • {}
func • (lhs: [Double], rhs: [Double]) -> Double {
    return dot(lhs, y: rhs)
}

func • (lhs: [Float], rhs: [Float]) -> Float {
    return dot(lhs, y: rhs)
}

// ---------------------------- Matrix Functions -------------------------------

// MARK: Matrix Add

public func add(x: Matrix<Float>, y: Matrix<Float>) -> Matrix<Float> {
    precondition(x.rows == y.rows && x.columns == y.columns, "Matrix dimensions not compatible with addition")
    
    var results = y
    cblas_saxpy(Int32(x.grid.count), 1, x.grid, 1, &(results.grid), 1)
    
    return results
}

public func add(x: Matrix<Double>, y: Matrix<Double>) -> Matrix<Double> {
    precondition(x.rows == y.rows && x.columns == y.columns, "Matrix dimensions not compatible with addition")
    
    var results = y
    cblas_daxpy(Int32(x.grid.count), 1, x.grid, 1, &(results.grid), 1)
    
    return results
}

// MARK: Matrix Transpose

public func transpose(x: Matrix<Float>) -> Matrix<Float> {
    var results = Matrix<Float>(rows: x.columns, columns: x.rows, repeatedValue: 0.0)
    vDSP_mtrans(x.grid, 1, &(results.grid), 1, vDSP_Length(results.rows), vDSP_Length(results.columns))
    
    return results
}

public func transpose(x: Matrix<Double>) -> Matrix<Double> {
    var results = Matrix<Double>(rows: x.columns, columns: x.rows, repeatedValue: 0.0)
    vDSP_mtransD(x.grid, 1, &(results.grid), 1, vDSP_Length(results.rows), vDSP_Length(results.columns))
    
    return results
}

// MARK: Matrix Scalar Multiplication

public func mul(alpha: Float, x: Matrix<Float>) -> Matrix<Float> {
    var results = x
    cblas_sscal(Int32(x.grid.count), alpha, &(results.grid), 1)
    
    return results
}

public func mul(alpha: Double, x: Matrix<Double>) -> Matrix<Double> {
    var results = x
    cblas_dscal(Int32(x.grid.count), alpha, &(results.grid), 1)
    
    return results
}

// MARK: Matrix Vector Dot Product

public func dot(array: [Double], _ matrix: Matrix<Double>) -> [Double] {
    let bias = [Double](count: matrix.rows, repeatedValue: 0.0)
    return dotProductAndAdd(array, matrix, bias)
}

public func dotProductAndAdd(array: [Double], _ matrix: Matrix<Double>, _ bias: [Double]) -> [Double] {
    let m = Int32(matrix.rows)
    let n = Int32(matrix.columns)
    var ret = [Double](bias)
    
    cblas_dgemv(CblasRowMajor, CblasNoTrans, m, n, 1, matrix.grid, n, array, 1, 1, &ret, 1)
    return ret
}

// ---------------------------- Matrix Operators -------------------------------

public func + (lhs: Matrix<Float>, rhs: Matrix<Float>) -> Matrix<Float> {
    return add(lhs, y: rhs)
}

public func + (lhs: Matrix<Double>, rhs: Matrix<Double>) -> Matrix<Double> {
    assert(lhs.rows == rhs.rows && lhs.columns == rhs.columns)
    var matrix = Matrix(rows: lhs.rows, columns: lhs.columns, repeatedValue: 0.0)
    for i in 0..<lhs.rows {
        for j in 0..<lhs.columns {
            matrix[i,j] = lhs[i,j] + rhs[i,j]
        }
    }
    return matrix
    
//    return add(lhs, y: rhs)
}

public func - (lhs: Matrix<Double>, rhs: Matrix<Double>) -> Matrix<Double> {
    var matrix = Matrix(rows: lhs.rows, columns: lhs.columns, repeatedValue: 0.0)
    for i in 0..<lhs.rows {
        for j in 0..<lhs.columns {
            matrix[i,j] = lhs[i,j] - rhs[i,j]
        }
    }
    return matrix
    //    return add(lhs, y: rhs)
}

public func * (lhs: Float, rhs: Matrix<Float>) -> Matrix<Float> {
    return mul(lhs, x: rhs)
}

public func * (lhs: Double, rhs: Matrix<Double>) -> Matrix<Double> {
    return mul(lhs, x: rhs)
}

func • (lhs: [Double], rhs: Matrix<Double>) -> [Double] {
    return dot(lhs, rhs)
}

postfix operator ′ {}
public postfix func ′ (value: Matrix<Float>) -> Matrix<Float> {
    return transpose(value)
}

public postfix func ′ (value: Matrix<Double>) -> Matrix<Double> {
    return transpose(value)
}
