//
//  String.swift
//  The Violet Sector
//
//  Created by João Santos on 21/08/2020.
//  Copyright © 2020 João Santos. All rights reserved.
//

extension String {
    static func ~=(_ left: String, _ right: String) -> Int {
        if left.isEmpty {
            return right.count
        }
        if right.isEmpty {
            return left.count
        }
        let left = [Character](left.uppercased())
        let right = [Character](right.uppercased())
        let leftLength = left.count
        let rightLength = right.count
        var matrix = Matrix(leftLength + 1, rightLength + 1)
        for x in 0...leftLength {
            matrix[x, 0] = x
        }
        for y in 0...rightLength {
            matrix[0, y] = y
        }
        for y in 1...rightLength {
            for x in 1...leftLength {
                matrix[x, y] = Swift.min(Swift.min(matrix[x - 1, y], matrix[x, y - 1]), matrix[x - 1, y - 1]) + (left[x - 1] != right[y - 1] ? 1 : 0)
            }
        }
        return matrix[leftLength, rightLength]
    }
}

fileprivate struct Matrix {
    var matrix: [Int]
    var sizeX: Int

    init(_ x: Int, _ y: Int) {
        matrix = [Int](repeating: 0, count: y * x)
        sizeX = x
    }

    subscript(_ x: Int, _ y: Int) -> Int{
        get {matrix[sizeX * y + x]}
        set {matrix[sizeX * y + x] = newValue}
    }
}
