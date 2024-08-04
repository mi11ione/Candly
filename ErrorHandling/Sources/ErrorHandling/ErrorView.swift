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
            Button(action: retryAction) {
                Text("Try Again")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(minWidth: 120, minHeight: 44)
                    .background(Color.red)
                    .cornerRadius(10)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}
