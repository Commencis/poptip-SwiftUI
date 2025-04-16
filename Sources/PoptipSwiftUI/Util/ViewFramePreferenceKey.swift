import SwiftUI

/// A `PreferenceKey` used to store the frame (position and size) of a view in the coordinate space.
internal struct ViewFramePreferenceKey: PreferenceKey {

    /// The default value for the preference key, representing the frame (origin and size) of the view.
    static let defaultValue: CGRect = .zero

    /// Updates the stored value for the preference key.
    ///
    /// - Parameters:
    ///   - value: The current value of the preference.
    ///   - nextValue: A closure that provides the next value to combine with the current one.
    ///
    /// This method is intentionally left blank because the view's frame should be considered per view,
    /// without combining values from multiple views.
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        // Left blank intentionally
        // View Rect Preference must be considered per view instead of combining multiple views
    }
}
