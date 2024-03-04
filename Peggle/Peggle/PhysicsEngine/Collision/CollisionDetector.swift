//
//  CollisionDetector.swift
//  Peggle
//
//  Created by proglab on 18/2/24.
//

import Foundation

class CollisionDetector {
    static func detectBetween(_ body1: PhysicsBody, _ body2: PhysicsBody) -> CollisionInfo {
        switch (body1.shape, body2.shape) {
        case is (Circle, Circle):
            return detectCircleCircleCollision(body1, body2)
        case is (Circle, Line):
            return detectLineCircleCollision(lineBody: body2, circleBody: body1)
        case is (Line, Circle):
            return detectLineCircleCollision(lineBody: body1, circleBody: body2)
        case is (Circle, Rectangle):
            return detectRectangleCircleCollision(rectangleBody: body2, circleBody: body1)
        case is (Rectangle, Circle):
            return detectRectangleCircleCollision(rectangleBody: body1, circleBody: body2)
        default:
            return .none
        }
    }

    private static func detectCircleCircleCollision(_ body1: PhysicsBody, _ body2: PhysicsBody) -> CollisionInfo {
        guard let circle1 = body1.shape as? Circle, let circle2 = body2.shape as? Circle else {
            fatalError("Circle-circle collision detection called when physics bodies are both not circles")
        }

        // Check if the circles overlap
        let distance = circle1.center.distance(to: circle2.center)
        let combinedRadius = circle1.radius + circle2.radius
        guard distance < combinedRadius else {
            return .none
        }

        body1.timesCollided += 1
        body2.timesCollided += 1

        let normal = (circle2.center - circle1.center).normalize()
        let penetration = combinedRadius - distance
        return CollisionInfo(body1: body1, body2: body2, normal: normal, penetration: penetration)
    }

    private static func detectLineCircleCollision(lineBody: PhysicsBody, circleBody: PhysicsBody) -> CollisionInfo {
        guard let line = lineBody.shape as? Line, let circle = circleBody.shape as? Circle else {
            fatalError(
                "Line-circle collision detection called when physics bodies are not a line and a circle in that order"
            )
        }

        // Check if the shapes overlap
        let distance = line.shortestDistanceToLine(from: circle.center)
        guard distance < circle.radius else {
            return .none
        }

        lineBody.timesCollided += 1
        circleBody.timesCollided += 1

        let closestPointOnLine = line.closestPointOnLine(to: circle.center)
        let normal = (circle.center - closestPointOnLine).normalize()
        let penetration = circle.radius - distance
        return CollisionInfo(body1: lineBody, body2: circleBody, normal: normal, penetration: penetration)
    }

    private static func detectRectangleCircleCollision(rectangleBody: PhysicsBody, circleBody: PhysicsBody)
        -> CollisionInfo {
        guard let rectangle = rectangleBody.shape as? Rectangle, let circle = circleBody.shape as? Circle else {
            fatalError(
                "Rectangle-circle collision detection called when bodies are not a rectangle and a circle in that order"
            )
        }

        // Find the closest point on the rectangle to the circle's center
        let closestX = max(rectangle.center.x - rectangle.width / 2,
                           min(circle.center.x, rectangle.center.x + rectangle.width / 2))
        let closestY = max(rectangle.center.y - rectangle.height / 2,
                           min(circle.center.y, rectangle.center.y + rectangle.height / 2))

        // Calculate the distance between the circle's center and this closest point
        let distanceX = circle.center.x - closestX
        let distanceY = circle.center.y - closestY
        let distanceSquared = distanceX * distanceX + distanceY * distanceY

        // If the distance is less than the circle's radius, they overlap
        guard distanceSquared <= circle.radius * circle.radius else {
            return .none
        }

        rectangleBody.timesCollided += 1
        circleBody.timesCollided += 1

        let normal = CGVector(dx: distanceX, dy: distanceY).normalize()
        let distance = sqrt(distanceSquared)
        let penetration = circle.radius - distance
        return CollisionInfo(body1: rectangleBody, body2: circleBody, normal: normal, penetration: penetration)
    }
}
