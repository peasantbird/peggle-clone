//
//  Shape.swift
//  Peggle
//
//  Created by proglab on 16/2/24.
//

import Foundation

protocol Shape {
    var center: CGPoint { get }
    mutating func move(by vector: CGVector)
    mutating func setCenter(to newCenter: CGPoint)
}
