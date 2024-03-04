//
//  OverlapVisitor.swift
//  Peggle
//
//  Created by proglab on 3/3/24.
//

import Foundation

protocol OverlapVisitor {
    func checkOverlap(with block: Block) -> Bool
    func checkOverlap(with peg: Peg) -> Bool
}
