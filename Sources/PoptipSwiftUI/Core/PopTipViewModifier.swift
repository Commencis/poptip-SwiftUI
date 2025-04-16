import AMPopTip
import SwiftUI

/// A view modifier that adds a PopTip to a SwiftUI view.
///
/// This modifier integrates a PopTip (e.g., from AmPoptip) with customizable behavior and appearance. The PopTip’s visual styling is defined by a `PopTipTheme`, while its behavior and positioning are configured via environment values or parameters passed during initialization.
public struct PopTipViewModifier<V: View>: ViewModifier {

    @State private var popTip = PopTip()
    @State private var holderView = PassthroughView()

    // Action handlers
    @Environment(\.popTipTapHandler) private var tapHandler
    @Environment(\.popTipOutsideTapHandler) private var tapOutsideHandler

    // Dismiss behavior
    @Environment(\.popTipDismissOnScroll) private var popTipDismissOnScroll
    @Environment(\.popTipDismissOnTap) private var dismissOnTap
    @Environment(\.popTipDismissOnOutsideTap) private var dismissOnOutsideTap
    @Environment(\.popTipOnDismiss) private var popTipOnDismiss

    // Positioning
    @Environment(\.popTipDirection) private var popTipDirection
    @Environment(\.popTipMaxWidth) private var popTipMaxWidth
    @Environment(\.popTipEdgeMargin) private var popTipEdgeMargin
    @Environment(\.popTipOffset) private var popTipOffset

    // Overlay
    @Environment(\.popTipHasOverlayTargetHole) private var popTipHasOverlayTargetHole

    @Environment(\.configurePopTip) private var configurePopTip

    /// A binding to control the presentation state of the PopTip.
    @Binding var isPresented: Bool

    /// The custom content view to display within the PopTip, if provided.
    @ViewBuilder var contentView: V

    /// The theme defining the PopTip's visual appearance, including colors, font, and layout properties.
    let theme: PopTipTheme

    /// The text message to display in the PopTip when no custom content is provided.
    let message: String

    /// The duration after which the PopTip automatically dismisses, if specified.
    let autoDismissDuration: TimeInterval?

    /// Initializes the modifier with a text-based PopTip and a theme.
    ///
    /// Use this initializer to create a PopTip that displays a text message, styled according to the provided theme.
    ///
    /// - Parameters:
    ///   - isPresented: A binding to control the PopTip's visibility.
    ///   - message: The text to display in the PopTip.
    ///   - theme: The theme defining the PopTip's visual appearance, including bubble color, text color, font, and more.
    ///   - autoDismissDuration: The duration in seconds after which the PopTip automatically dismisses. If `nil`, the PopTip remains visible until dismissed manually. Defaults to `nil`.
    public init(
        isPresented: Binding<Bool>,
        message: String,
        theme: PopTipTheme,
        autoDismissDuration: TimeInterval? = nil
    ) where V == EmptyView {
        self.contentView = EmptyView()
        self._isPresented = isPresented
        self.message = message
        self.theme = theme
        self.autoDismissDuration = autoDismissDuration
    }

    /// Initializes the modifier with a custom content view and a theme.
    ///
    /// Use this initializer to create a PopTip that displays a custom SwiftUI view, styled according to the provided theme.
    ///
    /// - Parameters:
    ///   - isPresented: A binding to control the PopTip's visibility.
    ///   - theme: The theme defining the PopTip's visual appearance, including bubble color, text color, font, and more.
    ///   - autoDismissDuration: The duration in seconds after which the PopTip automatically dismisses. If `nil`, the PopTip remains visible until dismissed manually. Defaults to `nil`.
    ///   - contentView: A closure that returns the custom SwiftUI view to display in the PopTip.
    public init(
        isPresented: Binding<Bool>,
        theme: PopTipTheme,
        autoDismissDuration: TimeInterval? = nil,
        contentView: () -> V
    ) {
        self.contentView = contentView()
        self._isPresented = isPresented
        self.message = ""
        self.theme = theme
        self.autoDismissDuration = autoDismissDuration
    }

    /// Applies the PopTip modifier to the content view.
    ///
    /// This method configures the PopTip’s behavior and appearance, handling its presentation, dismissal, and interaction based on environment values and the provided theme.
    ///
    /// - Parameter content: The SwiftUI view to modify.
    /// - Returns: A modified view with PopTip functionality.
    public func body(content: Content) -> some View {
        content
            .onFrameChanged { newFrame in
                tipFrame.wrappedValue = newFrame
                if popTipHasOverlayTargetHole {
                    holderView.holeRect = newFrame
                }
                if popTipDismissOnScroll {
                    isPresented = false
                    popTip.hide()
                }
            }
            .onDisappear {
                isPresented = false
                popTip.hide(forced: true)
                cleanUp()
            }
            .onChange(of: isPresented) { isPresented in
                presentPopTip(shouldPresent: isPresented)
            }
            .onChange(of: popTipHasOverlayTargetHole) { newValue in
                holderView.holeRect = if newValue {
                    tipFrame.wrappedValue
                } else {
                    nil
                }
            }
            .onReceive(
                NotificationCenter.default.publisher(for: .poptipShouldDismiss)
                    .drop { _ in !isPresented }
            ) { _ in
                isPresented = false
            }
    }
}

// MARK: - Computed Properties

private extension PopTipViewModifier {

    /// The calculated maximum width for the PopTip, accounting for insets and margins.
    ///
    /// This property computes the maximum width by subtracting the theme’s edge insets and environment’s edge margins from the provided `popTipMaxWidth` or screen width.
    var maxWidth: CGFloat {
        let normalizedPopTipMaxWidth: CGFloat = if popTipMaxWidth <= .zero {
            UIScreen.screenWidth
        } else {
            popTipMaxWidth
        }

        let totalEdgeInsets = theme.edgeInsets.leading + theme.edgeInsets.trailing
        let totalEdgeMargins = 2 * popTipEdgeMargin
        let maxWidth = normalizedPopTipMaxWidth - totalEdgeInsets - totalEdgeMargins
        return maxWidth
    }

    /// A binding to the frame of the view the PopTip is anchored to.
    ///
    /// This binding synchronizes the PopTip’s anchor frame with the target view’s frame.
    var tipFrame: Binding<CGRect> {
        Binding<CGRect> {
            popTip.from
        } set: { newFrame in
            popTip.from = newFrame
        }
    }
}

// MARK: - Helper Methods

private extension PopTipViewModifier {

    /// Presents or hides the PopTip based on the presentation state.
    ///
    /// This method configures the PopTip and its overlay, applies the theme and environment settings, and shows or hides the PopTip as needed.
    ///
    /// - Parameter shouldPresent: A Boolean indicating whether the PopTip should be presented.
    func presentPopTip(shouldPresent: Bool) {
        guard popTip.isVisible != shouldPresent,
              let viewController = UIApplication.shared.keyWindowPresentedController else {
            return
        }

        guard shouldPresent else {
            popTip.hide()
            return
        }

        holderView.backgroundColor = .init(theme.overlayColor)
        viewController.view.addSubview(holderView)
        holderView.presentedView = popTip
        holderView.holeRect = if popTipHasOverlayTargetHole {
            tipFrame.wrappedValue
        } else {
            nil
        }
        holderView.frame = viewController.view.frame
        holderView.tapHandler = { [weak popTip] in
            if dismissOnOutsideTap {
                isPresented = false
                popTip?.hide()
            }
            tapOutsideHandler()
        }

        popTip.dismissHandler = { @MainActor _ in
            cleanUp()
            popTipOnDismiss()
        }
        popTip.tapHandler = { @MainActor [weak popTip] _ in
            if dismissOnTap {
                isPresented = false
                popTip?.hide()
            }
            tapHandler()
        }
        applyTheme(popTip)
        applyConfiguration(popTip)
        configurePopTip(popTip)
        if V.self is EmptyView.Type {
            popTip.show(
                text: message,
                direction: popTipDirection,
                maxWidth: maxWidth,
                in: holderView,
                from: tipFrame.wrappedValue,
                duration: autoDismissDuration
            )
        } else {
            popTip.show(
                rootView: contentView,
                direction: popTipDirection,
                in: holderView,
                from: tipFrame.wrappedValue,
                parent: viewController,
                duration: autoDismissDuration
            )
        }
    }

    /// Cleans up the PopTip and its overlay.
    ///
    /// This method removes the PopTip and holder view from the view hierarchy and resets the presentation state.
    func cleanUp() {
        popTip.removeFromSuperview()
        holderView.removeFromSuperview()
        isPresented = false
    }

    /// Applies the theme to the PopTip instance.
    ///
    /// This method configures the PopTip’s visual properties based on the provided `PopTipTheme`.
    ///
    /// - Parameter popTip: The PopTip instance to configure.
    func applyTheme(_ popTip: PopTip) {
        popTip.bubbleColor = .init(theme.bubbleColor)
        popTip.textColor = .init(theme.textColor)
        popTip.font = theme.font
        popTip.cornerRadius = theme.cornerRadius
        popTip.textAlignment = theme.textAlignment
        popTip.edgeInsets = .init(
            top: theme.edgeInsets.top,
            left: theme.edgeInsets.leading,
            bottom: theme.edgeInsets.bottom,
            right: theme.edgeInsets.trailing
        )
        popTip.arrowSize = theme.arrowSize
        holderView.backgroundColor = .init(theme.overlayColor)
    }

    /// Applies the base configuration to the PopTip instance.
    ///
    /// This method configures the PopTip’s behavioral and positional properties based on environment values and the theme.
    ///
    /// - Parameter popTip: The PopTip instance to configure.
    func applyConfiguration(_ popTip: PopTip) {
        popTip.shouldDismissOnTap = dismissOnTap
        popTip.shouldDismissOnTapOutside = false // Handled through passthrough view
        popTip.shouldDismissOnSwipeOutside = false
        popTip.edgeMargin = popTipEdgeMargin
        popTip.offset = popTipOffset

    }
}

#Preview {
    PreviewContentView()
}
