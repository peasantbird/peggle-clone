//
//  Board+Storage.swift
//  Peggle
//
//  Created by proglab on 7/2/24.
//

import Foundation

extension Board {

    func getFileURL(from name: String, with extension: String) -> URL {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return directory.appendingPathComponent(name).appendingPathExtension(`extension`)
    }

    func save(levelName: String) throws {
        let fileURL = getFileURL(from: levelName, with: "json")

        let encoder = JSONEncoder()
        let data = try encoder.encode(self)

        try data.write(to: fileURL, options: [.atomic])
    }

    func load(levelName: String) throws -> Board {
        let fileURL = getFileURL(from: levelName, with: "json")

        let data = try Data(contentsOf: fileURL)

        let decoder = JSONDecoder()
        let board = try decoder.decode(Board.self, from: data)

        return board
    }
}
