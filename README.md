# PopTip SwiftUI

The popTip-SwiftUI provides a flexible and customizable way to display tooltips (PopTips) in SwiftUI applications. It integrates a UIKit-based PopTip component (from [AmPoptip](https://github.com/andreamazz/AMPopTip)) with SwiftUI, allowing you to present text-based or custom SwiftUI content in a tooltip with configurable appearance and behavior. This wrapper uses a view modifier (`PopTipViewModifier`) to attach PopTips to SwiftUI views, with styling managed via `PopTipTheme` and behavior controlled through environment values.

## Features

- **UIKit + SwiftUI Integration**  
  Wraps [AMPopTip](https://github.com/andreamazz/AMPopTip) for easy use in SwiftUI views.
- **Target Highlighting**  
  Supports transparent overlay cutouts to draw focus to the tooltip’s anchor view.
- **Custom SwiftUI Content**  
  Display any SwiftUI view inside the PopTip.
- **Customizable**  
  Full control over theme, behavior, positioning, dismissal, and interactivity.

- **Target View Highlighting**:
  Ability to use a transparent cutout in the overlay (via popTipHasOverlayTargetHole), which draws attention to the target view.

## Installation

### With Xcode

1. In Xcode, go to `File > Add Packages`.
2. Use the URL: https://github.com/Commencis/poptip-SwiftUI
3. Choose the latest version or specify a range.
4. Add `"PopTipSwiftUI"` to your app target.

### With `Package.swift`

Add this package as dependency:

```swift
.package(url: "https://github.com/Commencis/poptip-SwiftUI", from: "x.y.z")
```

And in your target dependencies:

```swift
.target(
  name: "YourApp",
  dependencies: [
    .product(name: "PopTipSwiftUI", package: "poptip-SwiftUI")
  ]
)
```

## Usage

Attach a PopTip to any SwiftUI view using the `.popTip` modifier. You control:

- Presentation via `Binding<Bool>`
- Appearance via `PopTipTheme`
- Content: simple text or any SwiftUI view

### Plain Text PopTip

Shows a basic tooltip with a message and a custom theme.

```swift
Button("Show Plain PopTip") {
    showPlainTip.toggle()
}
.popTip(
    isPresented: $showPlainTip,
    message: "This is a simple PopTip!",
    theme: previewTipTheme
)
.padding()
.background(Color.gray.opacity(0.2))
.cornerRadius(8)
```

### Timed PopTip with Auto-Dismiss

Automatically dismisses the tooltip after 2 seconds, and highlights the target view.

```swift
Button("Show Timed PopTip") {
    showTimerTip.toggle()
}
.popTip(
    isPresented: $showTimerTip,
    message: "This will dismiss in 2 seconds!",
    theme: previewTipTheme2,
    autoDismissDuration: 2.0
)
.popTipHasOverlayTargetHole(true)
.padding()
.background(Color.gray.opacity(0.2))
.cornerRadius(8)
```

### Custom SwiftUI Content PopTip

Displays a fully customized SwiftUI view inside the tooltip.

```swift
Button("Show Custom PopTip") {
    showCustomTip.toggle()
}
.popTip(
    isPresented: $showCustomTip,
    theme: previewTipTheme3
) {
    HStack {
        Image(systemName: "star.fill")
            .foregroundColor(.yellow)
        Text("Custom Content!")
            .font(.headline)
            .foregroundColor(.white)
    }
    .padding(8)
}
.padding()
.background(Color.gray.opacity(0.2))
.cornerRadius(8)
```

## Theming & Behavior

### Customize Appearance

You can style the tooltip using `PopTipTheme`:

```swift
let customTheme = PopTipTheme(
    bubbleColor: .purple.opacity(0.9),
    textColor: .white,
    font: .systemFont(ofSize: 15, weight: .bold),
    cornerRadius: 12,
    textAlignment: .center,
    overlayColor: .black.opacity(0.5),
    edgeInsets: EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10),
    arrowSize: CGSize(width: 14, height: 7)
)

Button("Show Custom PopTip") { /* Action */ }
    .popTip(
        isPresented: .constant(true),
        message: "Custom styled PopTip!",
        theme: customTheme
    )
```

### Customizing Behavior

Use view modifiers to configure the PopTip’s behavior and positioning. These modifiers set environment values that the PopTipViewModifier reads. You may also use `configurePopTip` API to directly access PopTip just before presented.

```swift
Button("Show PopTip")
    .popTip(
        isPresented: .constant(true),
        message: "Interactive PopTip",
        theme: .previewTipTheme
    )
    .popTipDismissOnScroll(true) // Dismiss on scroll
    .popTipMaxWidth(250) // Limit width to 250 points
    .popTipOnTapInside { print("PopTip tapped!") } // Custom tap handler
    .popTipDismissOnTap(false) // Prevent dismissal on tap
    .popTipDirection(.down) // Show PopTip below target
    .popTipEdgeMargin(20) // 20-point screen edge margin
    .popTipOffset(5) // 5-point offset from anchor
    .popTipHasOverlayTargetHole(true) // Transparent cutout over target
    .configurePopTip { popTip in // Custom PopTip configuration
        popTip.animationIn = 0.8
        popTip.animationOut = 0.4
        popTip.shouldBounce = true
        popTip.borderWidth = 1.0
        popTip.borderColor = .white
    }
```
