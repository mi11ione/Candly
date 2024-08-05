import SwiftUI

public struct ErrorView: View {
    public let error: AppError
    public let retryAction: () -> Void

    public init(error: AppError, retryAction: @escaping () -> Void) {
        self.error = error
        self.retryAction = retryAction
    }

    public var body: some View {
        VStack(spacing: 16) {
            Text("Error")
                .font(.title)
                .foregroundColor(.red)

            Text(error.localizedDescription)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button(action: retryAction) {
                Text("Try Again")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(minWidth: 120, minHeight: 44)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}
