import Foundation
import AppKit

class MusicLibrary {

    static func selectFolder() -> [Song] {

        let panel = NSOpenPanel()

        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.allowsMultipleSelection = false

        guard panel.runModal() == .OK,
              let folder = panel.url
        else {
            return []
        }

        let extensions = [
            "mp3",
            "m4a",
            "wav",
            "aac"
        ]

        let fileManager = FileManager.default

        guard let files = try? fileManager.contentsOfDirectory(
            at: folder,
            includingPropertiesForKeys: nil
        ) else {
            return []
        }

        return files
            .filter {
                extensions.contains(
                    $0.pathExtension.lowercased()
                )
            }
            .map { Song(url: $0) }
            .sorted {
                $0.title < $1.title
            }
    }

}
