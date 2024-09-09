import CoreUI
import SharedModels
import SwiftUI

public struct PatternGrid: View {
    private let patterns: [Pattern]

    public init(patterns: [Pattern]) {
        self.patterns = patterns
    }

    public var body: some View {
        GridView(items: patterns) { pattern in
            PatternCell(pattern: pattern)
        }
    }
}
