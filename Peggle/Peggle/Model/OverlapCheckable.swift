//
//  OverlapCheckable.swift
//  Peggle
//
//  Created by proglab on 3/3/24.
//

import Foundation

protocol OverlapCheckable {
    func accept(_ visitor: OverlapVisitor) -> Bool
}
