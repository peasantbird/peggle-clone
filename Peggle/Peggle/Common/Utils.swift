//
//  Utils.swift
//  Peggle
//
//  Created by proglab on 3/3/24.
//

import Foundation

struct Utils {
    static func pegToImageName(pegType: PegType, isHit: Bool = false) -> String {
        switch (pegType, isHit) {
        case (.optional, true):
            return "peg-blue-glow"
        case (.optional, false):
            return "peg-blue"
        case (.compulsory, true):
            return "peg-orange-glow"
        case (.compulsory, false):
            return "peg-orange"
        case (.stubborn, true), (.stubborn, false):
            return "peg-grey"
        case (.powerup, true):
            return "peg-green-glow"
        case (.powerup, false):
            return "peg-green"
        }
    }

    static func createPowerup(for type: PowerupType) -> Powerup {
        switch type {
        case .explosion:
            return ExplosionPowerup()
        case .spookyBall:
            return SpookyBallPowerup()
        }
    }
}
