//
//  PhysicsBody.swift
//  Peggle
//
//  Created by proglab on 16/2/24.
//

import Foundation

class PhysicsBody {
    /// The shape of the physics body contains the position of the  
    /// center of the shape, and other attributes that define the shape. 
    /// We move the physics body by moving the shape.
    var shape: Shape
    var center: CGPoint {
        shape.center
    }
    var mass: Double
    var restitution: Double
    var velocity: CGVector
    var force = CGVector.zero
    var acceleration: CGVector {
        force / mass
    }
    var affectedByGravity: Bool
    var isDynamic: Bool
    var timesCollided = 0

    init(shape: Shape, mass: Double, restitution: Double, affectedByGravity: Bool, isDynamic: Bool,
         velocity: CGVector = .zero) {
        self.shape = shape
        self.mass = mass
        self.restitution = restitution
        self.affectedByGravity = affectedByGravity
        self.isDynamic = isDynamic
        self.velocity = velocity
    }

    func applyForce(_ force: CGVector) {
        guard isDynamic else {
            return
        }

        self.force += force
    }

    func setPosition(to position: CGPoint) {
        self.shape.setCenter(to: position)
    }

    func setVelocity(_ velocity: CGVector) {
        self.velocity = velocity
    }

    func update(dt deltaTime: TimeInterval) {
        // Update position
        let deltaPosition = velocity * deltaTime + 0.5 * acceleration * pow(deltaTime, 2)
        shape.move(by: deltaPosition)

        // Update velocity
        velocity += acceleration * deltaTime

        // Reset force
        force = CGVector.zero
    }
}
