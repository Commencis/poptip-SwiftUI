import UIKit

@MainActor
internal extension UIScreen {

    /// The width of the main screen in points.
    static var screenWidth: CGFloat { UIScreen.main.bounds.size.width }

    /// The height of the main screen in points.
    static var screenHeight: CGFloat { UIScreen.main.bounds.size.height }

    /// The size of the main screen as a `CGSize`, including both width and height.
    static var screenSize: CGSize { UIScreen.main.bounds.size }
}
