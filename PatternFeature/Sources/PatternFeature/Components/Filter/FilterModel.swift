import SwiftUICore

enum FilterModel: String, CaseIterable {
    case single = "Single"
    case double = "Double"
    case triple = "Triple"
    case complex = "Complex"
    case allPatterns = "All Patterns"

    var color: Color {
        switch self {
        case .single: .blue
        case .double: .green
        case .triple: .indigo
        case .complex: .pink
        case .allPatterns: .primary
        }
    }

    var symbol: String {
        switch self {
        case .single: "chevron.up.right.dotted.2"
        case .double: "distribute.horizontal.center.fill"
        case .triple: "chart.bar.fill"
        case .complex: "xmark.triangle.circle.square.fill"
        case .allPatterns: "rectangle.pattern.checkered"
        }
    }
}
