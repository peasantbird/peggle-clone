//
//  PaletteViewModelProtocol.swift
//  Peggle
//
//  Created by proglab on 8/2/24.
//

import Foundation

protocol PaletteViewModelProtocol {
    var selectedAction: Action { get }

    func selectAddBluePegAction()
    func selectAddOrangePegAction()
    func selectAddGreenPegAction()
    func selectAddGreyPegAction()
    func selectAddBlockAction()
    func selectDeleteAction()
}
