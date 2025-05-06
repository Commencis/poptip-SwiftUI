import AMPopTip
import SwiftUI

@MainActor
public extension EnvironmentValues {

    /// The maximum width of the PopTip view.
    /// Defaults to `.zero`, which typically implies no explicit width limit unless overridden.
    @Entry var popTipMaxWidth: CGFloat = .zero

    /// A closure executed when the PopTip is tapped.
    /// Defaults to an empty closure, allowing customization of tap behavior.
    @Entry var popTipTapHandler: @Sendable () -> Void = {}

    /// Determines whether tapping the PopTip dismisses it.
    /// Defaults to `true`, enabling dismissal on tap unless explicitly disabled.
    @Entry var popTipDismissOnTap: Bool = true

    /// A closure executed when a tap occurs outside the PopTip.
    /// Defaults to an empty closure, allowing custom handling of outside taps.
    @Entry var popTipOutsideTapHandler: @Sendable () -> Void = {}

    /// Determines whether tapping outside the PopTip dismisses it.
    /// Defaults to `true`, enabling dismissal on outside tap unless explicitly disabled.
    @Entry var popTipDismissOnOutsideTap: Bool = true

    /// A closure executed when the PopTip is dismissed.
    /// Defaults to an empty closure, allowing custom actions on dismissal.
    @Entry var popTipOnDismiss: @Sendable () -> Void = {}

    /// Determines whether scrolling dismisses the PopTip.
    /// Defaults to `false`, keeping the PopTip visible during scroll unless explicitly enabled.
    @Entry var popTipDismissOnScroll: Bool = false

    /// The direction in which the PopTip is displayed relative to its anchor point.
    /// Defaults to `.auto`, positioning the PopTip based on available space.
    @Entry var popTipDirection: PopTipDirection = .auto

    /// Determines whether the PopTip overlay includes a transparent cutout over the target view.
    /// Defaults to `false`, meaning no cutout is applied unless explicitly enabled.
    @Entry var popTipHasOverlayTargetHole: Bool = false

    /// The margin between the PopTip and the screen edges.
    /// Defaults to `16.0`, ensuring the PopTip remains fully visible.
    @Entry var popTipEdgeMargin: CGFloat = 16.0

    /// The offset between the PopTip and its anchor point.
    /// Defaults to `2.0`, fine-tuning the PopTip's positioning.
    @Entry var popTipOffset: CGFloat = 2.0

    /// A closure to customize the configuration of the PopTip instance.
    ///
    /// Assign a closure to this property to apply custom configurations to the `PopTip` instance before it is presented. The closure takes a `PopTip` parameter, allowing direct modification of its properties, such as animation settings or additional styling. The closure is marked `@Sendable` to ensure thread safety.
    ///
    /// - Default: An empty closure (`{ _ in }`) that performs no configuration.
    @Entry var configurePopTip: @MainActor (PopTip) -> Void = { _ in }
}
