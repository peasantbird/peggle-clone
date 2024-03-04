//
//  Powerup.swift
//  Peggle
//
//  Created by proglab on 3/3/24.
//

import Foundation

protocol Powerup {
    func activate(hitPeg: GamePeg, gameEngine: GameEngine)
}
