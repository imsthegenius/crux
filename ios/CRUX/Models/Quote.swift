import Foundation

nonisolated struct Quote: Codable, Identifiable, Hashable, Sendable {
    let id: String
    let text: String
    let short: String
    let author: String
    let source: String
    let reference: String
    let translator: String
    let collectionID: String
}
