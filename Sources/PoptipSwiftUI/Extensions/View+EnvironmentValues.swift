import AMPopTip
import SwiftUI

public extension View {

    /// Configures whether the PopTip dismisses when the parent view scrolls.
    ///
    /// Use this modifier to control whether scrolling the content beneath the PopTip causes it to dismiss. When set to `true`, scrolling triggers dismissal; when `false`, the PopTip remains visible during scrolling.
    ///
    /// - Parameter shouldDismiss: A Boolean indicating whether scrolling should dismiss the PopTip. Defaults to `false`.
    /// - Returns: A modified view with the updated scroll dismissal behavior.
    func popTipDismissOnScroll(_ shouldDismiss: Bool = false) -> some View {
        environment(\.popTipDismissOnScroll, shouldDismiss)
    }

    /// Sets the maximum width for the PopTip.
    ///
    /// Use this modifier to specify the maximum width of the PopTip. A value of `.zero` indicates no explicit width limit, allowing the PopTip to size based on its content and other constraints.
    ///
    /// - Parameter maxWidth: The maximum width in points. Defaults to `.zero`.
    /// - Returns: A modified view with the updated maximum width setting.
    func popTipMaxWidth(_ maxWidth: CGFloat = .zero) -> some View {
        environment(\.popTipMaxWidth, maxWidth)
    }

    /// Sets a handler to execute when the PopTip is tapped.
    ///
    /// Use this modifier to define a closure that runs when the user taps the PopTip. The closure takes no parameters and is marked `@Sendable` for thread safety.
    ///
    /// - Parameter handler: A closure to execute when the PopTip is tapped. Defaults to an empty closure.
    /// - Returns: A modified view with the updated tap handler.
    func popTipOnTapInside(_ handler: @Sendable @escaping () -> Void = {}) -> some View {
        environment(\.popTipTapHandler, handler)
    }

    /// Configures whether tapping the PopTip dismisses it.
    ///
    /// Use this modifier to control whether tapping the PopTip causes it to dismiss. When set to `true`, tapping dismisses the PopTip; when `false`, tapping triggers the `popTipTapHandler` without dismissing.
    ///
    /// - Parameter shouldDismiss: A Boolean indicating whether tapping should dismiss the PopTip. Defaults to `true`.
    /// - Returns: A modified view with the updated tap dismissal behavior.
    func popTipDismissOnTap(_ shouldDismiss: Bool = true) -> some View {
        environment(\.popTipDismissOnTap, shouldDismiss)
    }

    /// Sets a handler to execute when the area outside the PopTip is tapped.
    ///
    /// Use this modifier to define a closure that runs when the user taps outside the PopTip’s bounds. The closure takes no parameters and is marked `@Sendable` for thread safety.
    ///
    /// - Parameter handler: A closure to execute when the outside area is tapped. Defaults to an empty closure.
    /// - Returns: A modified view with the updated outside tap handler.
    func popTipOnTapOutside(_ handler: @Sendable @escaping () -> Void = {}) -> some View {
        environment(\.popTipOutsideTapHandler, handler)
    }

    /// Configures whether tapping outside the PopTip dismisses it.
    ///
    /// Use this modifier to control whether tapping outside the PopTip causes it to dismiss. When set to `true`, outside taps dismiss the PopTip; when `false`, outside taps trigger the `popTipOutsideTapHandler` without dismissing.
    ///
    /// - Parameter shouldDismiss: A Boolean indicating whether tapping outside should dismiss the PopTip. Defaults to `true`.
    /// - Returns: A modified view with the updated outside tap dismissal behavior.
    func popTipDismissOnOutsideTap(_ shouldDismiss: Bool = true) -> some View {
        environment(\.popTipDismissOnOutsideTap, shouldDismiss)
    }

    /// Sets a handler to execute when the PopTip is dismissed.
    ///
    /// Use this modifier to define a closure that runs when the PopTip is dismissed, regardless of the dismissal method (e.g., tap, outside tap, or programmatic). The closure takes no parameters and is marked `@Sendable` for thread safety.
    ///
    /// - Parameter handler: A closure to execute when the PopTip is dismissed. Defaults to an empty closure.
    /// - Returns: A modified view with the updated dismissal handler.
    func popTipOnDismiss(_ handler: @Sendable @escaping () -> Void = {}) -> some View {
        environment(\.popTipOnDismiss, handler)
    }

    /// Configures whether the PopTip overlay includes a transparent cutout over the target view.
    ///
    /// Use this modifier to specify whether the overlay behind the PopTip includes a transparent cutout that highlights the target view. When set to `true`, the cutout is applied; when `false`, the overlay is uniform.
    ///
    /// - Parameter hasHole: A Boolean indicating whether the overlay should have a cutout over the target view. Defaults to `false`.
    /// - Returns: A modified view with the updated overlay cutout setting.
    func popTipHasOverlayTargetHole(_ hasHole: Bool = false) -> some View {
        environment(\.popTipHasOverlayTargetHole, hasHole)
    }

    /// Sets the direction in which the PopTip is displayed relative to its anchor point.
    ///
    /// Use this modifier to specify the PopTip’s position relative to the target view. The `.auto` option allows the system to choose the best direction based on available space.
    ///
    /// - Parameter direction: The direction for the PopTip’s display. Defaults to `.auto`.
    /// - Returns: A modified view with the updated PopTip direction.
    func popTipDirection(_ direction: PopTipDirection = .auto) -> some View {
        environment(\.popTipDirection, direction)
    }

    /// Sets the margin between the PopTip and the screen edges.
    ///
    /// Use this modifier to define the minimum distance between the PopTip and the edges of the screen, ensuring it remains fully visible.
    ///
    /// - Parameter margin: The margin in points. Defaults to `16.0`.
    /// - Returns: A modified view with the updated edge margin setting.
    func popTipEdgeMargin(_ margin: CGFloat = 16.0) -> some View {
        environment(\.popTipEdgeMargin, margin)
    }

    /// Sets the offset between the PopTip and its anchor point.
    ///
    /// Use this modifier to adjust the distance between the PopTip’s arrow and the target view, fine-tuning its positioning.
    ///
    /// - Parameter offset: The offset in points. Defaults to `2.0`.
    /// - Returns: A modified view with the updated offset setting.
    func popTipOffset(_ offset: CGFloat = 2.0) -> some View {
        environment(\.popTipOffset, offset)
    }

    /// Configures the PopTip instance with a custom closure.
    ///
    /// Use this modifier to apply custom configurations to the `PopTip` instance before it is presented. The closure takes a `PopTip` parameter, allowing direct modification of its properties, such as animation settings or additional styling.
    ///
    /// - Parameter configure: A closure to customize the `PopTip` instance. Defaults to an empty closure that performs no configuration.
    /// - Returns: A modified view with the updated configuration closure.
    func configurePopTip(_ configure: @Sendable @escaping (PopTip) -> Void = { _ in }) -> some View {
        environment(\.configurePopTip, configure)
    }
}
