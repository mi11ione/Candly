import Foundation
import SharedModels

public protocol PatternRepositoryProtocol: Sendable {
    func fetchPatterns() async -> [PatternDTO]
}
