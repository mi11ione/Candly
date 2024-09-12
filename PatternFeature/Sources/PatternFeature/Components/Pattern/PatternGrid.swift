import Core
import Models
import SwiftUICore

struct PatternGrid: View {
    var patterns: [Pattern]

    var body: some View {
        GridView(items: patterns) { pattern in
            PatternCell(pattern: pattern)
        }
    }
}
