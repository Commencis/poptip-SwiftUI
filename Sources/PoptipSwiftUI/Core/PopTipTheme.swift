import SwiftUI

/// A theme configuration for styling a PopTip view.
///
/// The `PopTipTheme` struct defines the visual properties of a PopTip, such as its bubble color, text color, font, and other stylistic attributes. Use this struct to customize the appearance of a PopTip consistently across your app. Conforms to `Equatable` for comparing theme configurations.
public struct PopTipTheme: Equatable {

    /// The background color of the PopTip bubble.
    ///
    /// This property sets the color of the PopTip's background, defining the appearance of the bubble that contains the content.
    public let bubbleColor: Color

    /// The color of the text displayed within the PopTip.
    ///
    /// This property specifies the color of the text inside the PopTip, ensuring readability against the `bubbleColor`.
    public let textColor: Color

    /// The font used for the text within the PopTip.
    ///
    /// This property defines the font style and size for the PopTip's text content, allowing customization of typography.
    public let font: UIFont

    /// The corner radius of the PopTip bubble.
    ///
    /// This property sets the radius of the PopTip's corners, controlling the roundness of the bubble's edges.
    public let cornerRadius: CGFloat

    /// The alignment of the text within the PopTip.
    ///
    /// This property specifies how text is aligned within the PopTip, such as left, center, or right alignment.
    public let textAlignment: NSTextAlignment

    /// The color of the overlay behind the PopTip.
    ///
    /// This property sets the color of the background overlay, which appears behind the PopTip to dim or highlight the underlying content.
    ///
    /// - Note: A `.clear` color results in a transparent overlay.
    public let overlayColor: Color

    /// The edge insets for the PopTip's content.
    ///
    /// This property defines padding around the PopTip's content, controlling the spacing between the content and the PopTip's edges.
    public let edgeInsets: EdgeInsets

    /// The size of the PopTip's arrow.
    ///
    /// This property defines the width and height of the arrow that points to the target view, affecting the PopTip's visual appearance.
    public let arrowSize: CGSize

    /// Creates a theme configuration for a PopTip view.
    ///
    /// Use this initializer to create a `PopTipTheme` with custom values for the PopTip's visual properties.
    ///
    /// - Parameters:
    ///   - bubbleColor: The background color of the PopTip bubble.
    ///   - textColor: The color of the text displayed within the PopTip.
    ///   - font: The font used for the text within the PopTip.
    ///   - cornerRadius: The corner radius of the PopTip bubble.
    ///   - textAlignment: The alignment of the text within the PopTip.
    ///   - overlayColor: The color of the overlay behind the PopTip.
    ///   - edgeInsets: The padding around the PopTip's content.
    ///   - arrowSize: The size of the PopTip's arrow.
    public init(
        bubbleColor: Color,
        textColor: Color,
        font: UIFont,
        cornerRadius: CGFloat,
        textAlignment: NSTextAlignment,
        overlayColor: Color,
        edgeInsets: EdgeInsets,
        arrowSize: CGSize
    ) {
        self.bubbleColor = bubbleColor
        self.textColor = textColor
        self.font = font
        self.cornerRadius = cornerRadius
        self.textAlignment = textAlignment
        self.overlayColor = overlayColor
        self.edgeInsets = edgeInsets
        self.arrowSize = arrowSize
    }
}
