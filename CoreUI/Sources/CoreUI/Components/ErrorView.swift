import SwiftUI

public struct ErrorView: View {
    let error: String
    let retryAction: () -> Void

    public init(error: String, retryAction: @escaping () -> Void) {
        self.error = error
        self.retryAction = retryAction
    }

    public var body: some View {
        VStack {
            Text(error)
                .foregroundColor(.red)
            Button("Try Again", action: retryAction)
        }
    }
}
