//
//  ActionButtonsViewModelProtocol.swift
//  Peggle
//
//  Created by proglab on 8/2/24.
//

protocol ActionButtonsViewModelProtocol {
    var board: Board { get }
    func loadBoard(levelName: String) throws
    func saveBoard(levelName: String) throws
    func clearBoard()
}
