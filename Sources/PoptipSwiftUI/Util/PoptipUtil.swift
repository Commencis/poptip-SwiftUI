import Foundation

/// A utility enum for managing PopTip instances across the app.
/// Provides static methods to control PopTip behavior globally.
@MainActor
public enum PoptipUtil {

    /// Dismisses all currently visible PopTips in the application.
    /// This method posts a notification to trigger dismissal of all `SwiftUI PopTip`.
    public static func dismissAll() {
        let notification = Notification(name: .poptipShouldDismiss)
        NotificationCenter.default.post(notification)
    }
}
