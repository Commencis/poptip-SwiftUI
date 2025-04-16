import SwiftUI

/// A view modifier that tracks changes to a view's frame within a specified coordinate space.
///
/// This modifier uses `GeometryReader` to monitor the frame of the content view and updates
/// a bound `CGRect` whenever the frame changes. It leverages SwiftUI's preference system
/// to propagate frame data efficiently.
///
/// - Note: This modifier is marked with `@MainActor` to ensure all UI updates occur on the main thread.
internal struct ViewFrameTrackingViewModifier: ViewModifier {

    /// The coordinate space in which the view's frame will be tracked.
    ///
    /// This determines the reference frame for the reported `CGRect`. Common values include
    /// `.global`, `.local`, or a custom named coordinate space created with `.coordinateSpace(name:)`.
    let coordinateSpace: CoordinateSpace

    /// A binding to the `CGRect` that will be updated with the view's current frame.
    ///
    /// This binding allows two-way communication: the modifier updates the frame when it changes,
    /// and external updates to the binding can influence the view's layout if needed.
    @Binding var frame: CGRect

    func body(content: Content) -> some View {
        content.background(
            GeometryReader { proxy in
                Color.clear
                    .preference(
                        key: ViewFramePreferenceKey.self,
                        value: proxy.frame(in: coordinateSpace)
                    )
            }
            .onPreferenceChange(ViewFramePreferenceKey.self) { [$frame] newValue in
                $frame.wrappedValue = newValue
            }
        )
    }
}

// MARK: - View Extension

internal extension View {

    /// Adds a modifier to track changes to the view's frame within a specified coordinate space.
    ///
    /// This modifier allows you to monitor the position and size of a view as it changes,
    /// providing the new frame through a closure. It's useful for layouts that need to
    /// respond to dynamic view positioning or sizing.
    ///
    /// - Parameters:
    ///   - coordinateSpace: The coordinate space in which to track the frame. Defaults to `.global`.
    ///   - onFrameChanged: A closure executed on the main actor whenever the view's frame changes.
    ///     - newFrame: The updated `CGRect` representing the view's new position and size.
    /// - Returns: A modified view that tracks and reports its frame changes.
    func onFrameChanged(
        coordinateSpace: CoordinateSpace = .global,
        onFrameChanged: @escaping @MainActor (_ newFrame: CGRect) -> Void
    ) -> some View {
        modifier(
            ViewFrameTrackingViewModifier(
                coordinateSpace: coordinateSpace,
                frame: Binding<CGRect> {
                    .zero
                } set: { newValue in
                    onFrameChanged(newValue)
                }
            )
        )
    }

    /// Adds a modifier to track changes to the view's frame with a binding.
    ///
    /// This overload allows you to bind the frame directly to a `@State` or `@Binding`
    /// property, providing two-way communication between the view's frame and your state.
    ///
    /// - Parameters:
    ///   - coordinateSpace: The coordinate space in which to track the frame. Defaults to `.global`.
    ///   - frame: A `Binding<CGRect>` to store and update the view's frame.
    /// - Returns: A modified view that tracks and updates the bound frame.
    func onFrameChanged(
        coordinateSpace: CoordinateSpace = .global,
        frame: Binding<CGRect>
    ) -> some View {
        modifier(
            ViewFrameTrackingViewModifier(
                coordinateSpace: coordinateSpace,
                frame: frame
            )
        )
    }
}
