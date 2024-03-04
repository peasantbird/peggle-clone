//
//  LevelSelectionViewModel.swift
//  Peggle
//
//  Created by proglab on 1/3/24.
//

import Foundation

class LevelSelectionViewModel {
    var savedLevels: [String: Board] = [:]

    init() {
        let savedLevelNames = fetchSavedLevelNames()
        loadLevels(levelNames: savedLevelNames)
    }

    private func fetchSavedLevelNames() -> [String] {
        let fileManager = FileManager.default
        let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil)

            let levelNames = fileURLs.compactMap { url -> String? in
                guard url.pathExtension == "json" else {
                    return nil
                }

                return url.deletingPathExtension().lastPathComponent
            }
            return levelNames
        } catch {
            // TODO: Error handling
            return []
        }
    }

    private func loadLevels(levelNames: [String]) {
        for levelName in levelNames {
            do {
                let board = try Board().load(levelName: levelName)
                self.savedLevels[levelName] = board
            } catch {
                // TODO: Error handling
            }
        }
    }
}
