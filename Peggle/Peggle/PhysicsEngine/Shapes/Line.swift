//
//  Line.swift
//  Peggle
//
//  Created by proglab on 17/2/24.
//

import Foundation

struct Line: Shape {
    var startPoint: CGPoint
    var endPoint: CGPoint
    var center: CGPoint {
        let centerX = (startPoint.x + endPoint.x) / 2
        let centerY = (startPoint.y + endPoint.y) / 2
        return CGPoint(x: centerX, y: centerY)
    }
    var length: Double {
        startPoint.distance(to: endPoint)
    }

    mutating func move(by vector: CGVector) {
        startPoint = startPoint.move(by: vector)
        endPoint = endPoint.move(by: vector)
    }

    mutating func setCenter(to newCenter: CGPoint) {
        let vector = newCenter - center
        self.move(by: vector)
    }

    func closestPointOnLine(to point: CGPoint) -> CGPoint {
        let vectorFromStartToPoint = point - startPoint
        let vectorFromStartToEnd = endPoint - startPoint
        let dotProduct = CGVector.dotProduct(vectorFromStartToPoint, vectorFromStartToEnd)
        let lineLengthSquared = pow(length, 2)

        var param: Double = -1
        if lineLengthSquared != 0 {
            param = dotProduct / lineLengthSquared
        }

        let closestPoint: CGPoint
        if param < 0 {
            closestPoint = startPoint
        } else if param > 1 {
            closestPoint = endPoint
        } else {
            let x = startPoint.x + param * vectorFromStartToEnd.dx
            let y = startPoint.y + param * vectorFromStartToEnd.dy
            closestPoint = CGPoint(x: x, y: y)
        }

        return closestPoint
    }

    func shortestDistanceToLine(from point: CGPoint) -> Double {
        let closestPoint = self.closestPointOnLine(to: point)
        return point.distance(to: closestPoint)
    }
}
