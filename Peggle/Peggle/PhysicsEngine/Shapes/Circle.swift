//
//  Circle.swift
//  Peggle
//
//  Created by proglab on 16/2/24.
//

import Foundation

struct Circle: Shape {
    var center: CGPoint
    var radius: Double

    mutating func move(by vector: CGVector) {
        center = center.move(by: vector)
    }

    mutating func setCenter(to newCenter: CGPoint) {
        center = newCenter
    }
}
