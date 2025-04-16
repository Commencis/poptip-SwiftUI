import UIKit

@MainActor
internal final class PassthroughView: UIView, UIGestureRecognizerDelegate {

    public var holeRect: CGRect? {
        didSet {
            if oldValue != holeRect {
                setNeedsDisplay()
            }
        }
    }

    var tapHandler: (() -> Void)?

    weak var presentedView: UIView?

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setupView()
    }

    private func setupView() {
        // Add pan gesture recognizer
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        panGesture.delegate = self
        self.addGestureRecognizer(panGesture)
        clipsToBounds = true
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)

        if let presentedView {
            if !presentedView.frame.contains(point) {
                tapHandler?()
            }
        } else {
            tapHandler?()
        }

        if hitView == self {
            return nil
        }
        return hitView
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        guard let holeRect else {
            return
        }

        let context = UIGraphicsGetCurrentContext()
        context?.clear(bounds)

        let clipPath = UIBezierPath(rect: bounds)
        clipPath.append(UIBezierPath(rect: holeRect))
        clipPath.usesEvenOddFillRule = true
        clipPath.addClip()

        backgroundColor?.setFill()
        clipPath.fill()
    }

    @objc
    private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: superview)
        center = CGPoint(x: center.x + translation.x, y: center.y + translation.y)
        gesture.setTranslation(.zero, in: superview)
    }

    // MAARK: - UIGestureRecognizerDelegate

    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldReceive touch: UITouch
    ) -> Bool {
        // Pass through touches in the lower half of the view
        let location = touch.location(in: self)
        if location.y > bounds.height / 2 {
            return false  // Touch passes to underlying views
        }
        return true  // Pan gesture handles the touch
    }
}
