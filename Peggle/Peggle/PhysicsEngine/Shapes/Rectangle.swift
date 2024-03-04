//
//  Rectangle.swift
//  Peggle
//
//  Created by proglab on 3/3/24.
//

import Foundation

struct Rectangle: Shape {
    var center: CGPoint
    var width: Double
    var height: Double

    mutating func move(by vector: CGVector) {
        center = center.move(by: vector)
    }

    mutating func setCenter(to newCenter: CGPoint) {
        center = newCenter
    }
}
