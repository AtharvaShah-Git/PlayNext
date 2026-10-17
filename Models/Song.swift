import Foundation

struct Song: Identifiable, Equatable {

    let id = UUID()
    let url: URL

    var title: String {
        url.deletingPathExtension().lastPathComponent
    }

}
