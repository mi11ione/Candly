import SwiftUICore

public protocol BaseView: View {
    associatedtype T
    associatedtype I
    associatedtype Model: BaseModel<T, I>
    var model: Model { get }

    func handleIntent(_ intent: I)
}

public extension BaseView {
    func handleIntent(_ intent: I) {
        model.handle(intent)
    }
}
