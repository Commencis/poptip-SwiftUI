import UIKit

private enum Constant {

    static let maxIterations: Int = 100
}

@MainActor
internal extension UIApplication {

    /// Retrieves the currently presented view controller from the key window.
    /// This property traverses the view controller hierarchy to find the topmost presented view controller,
    /// handling cases like tab bar controllers and nested presentations, with a safeguard against infinite loops.
    var keyWindowPresentedController: UIViewController? {
        // Start with the root view controller of the key window
        var viewController = self.keyWindow?.rootViewController

        // Maximum number of iterations to prevent infinite loops (e.g., due to circular references)
        var iterationCount: Int = .zero

        // If the root view controller is a UITabBarController
        if let presentedController = viewController as? UITabBarController {
            // Update to the currently selected view controller in the tab bar
            viewController = presentedController.selectedViewController
        }

        // Traverse the hierarchy to find the topmost presented view controller
        while let presentedController = viewController?.presentedViewController {
            // Increment iteration count and check against the limit
            iterationCount += 1
            if iterationCount >= Constant.maxIterations {
                assertionFailure("Max iteration limit (\(Constant.maxIterations)) reached in view controller presentation hierarchy. Possible circular reference detected.")
                break
            }

            // If the presented controller is a UITabBarController
            if let presentedController = presentedController as? UITabBarController {
                // Update to the selected view controller in the tab bar
                viewController = presentedController.selectedViewController
            } else {
                // Move to the next presented view controller
                viewController = presentedController
            }
        }

        return viewController
    }

    /// Returns the key window from the current application scene.
    /// This private property filters active scenes to find the foreground window marked as the key window.
    private var keyWindow: UIWindow? {
        self.connectedScenes
            .filter { $0.activationState == .foregroundActive } // Keep only active foreground scenes
            .first { $0 is UIWindowScene } // Find the first UIWindowScene
            .flatMap { $0 as? UIWindowScene }?.windows // Cast to UIWindowScene and get its windows
            .first(where: \.isKeyWindow) // Return the window marked as key
    }
}
