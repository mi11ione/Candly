import Core
import Models
import SwiftUICore

public struct PatternGrid: View {
    public var patterns: [Pattern]

    public var body: some View {
        GridView(items: patterns) { pattern in
            PatternCell(pattern: pattern)
        }
    }
}
