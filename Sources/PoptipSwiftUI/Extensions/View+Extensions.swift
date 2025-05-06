//
//  View+Extensions.swift
//  PegasusKit
//
//  Created by Berat Demir on 3/17/25.
//  Copyright © 2025 Commencis. All rights reserved.
//
//  Save to the extent permitted by law, you may not use, copy, modify,
//  distribute or create derivative works of this material or any part
//  of it without the prior written consent of .
//  Any reproduction of this material must contain this notice.
//

import SwiftUI

extension View {

    /// Applies a PopTip with a text message to the view.
    /// - Parameters:
    ///   - isPresented: A binding to control the visibility of the PopTip.
    ///   - message: The text to display within the PopTip.
    ///   - theme: The theme defining the PopTip's appearance.
    ///   - autoDismiss: Whether the PopTip should automatically dismiss after a duration. Defaults to `false`.
    /// - Returns: A modified view with the PopTip functionality.
    public func popTip(
        isPresented: Binding<Bool>,
        message: String,
        theme: PopTipTheme,
        autoDismissDuration: TimeInterval? = nil
    ) -> some View {
        modifier(
            PopTipViewModifier(
                isPresented: isPresented,
                message: message,
                theme: theme,
                autoDismissDuration: autoDismissDuration
            )
        )
    }

    /// Applies a PopTip with a custom content view to the view.
    /// - Parameters:
    ///   - isPresented: A binding to control the visibility of the PopTip.
    ///   - theme: The theme defining the PopTip's appearance. 
    ///   - autoDismiss: Whether the PopTip should automatically dismiss after a duration. Defaults to `false`.
    ///   - contentView: A closure providing the custom SwiftUI view to display within the PopTip.
    /// - Returns: A modified view with the PopTip functionality.
    public func popTip<V: View>(
        isPresented: Binding<Bool>,
        theme: PopTipTheme,
        autoDismissDuration: TimeInterval? = nil,
        contentView: () -> V
    ) -> some View {
        modifier(
            PopTipViewModifier(
                isPresented: isPresented,
                theme: theme,
                autoDismissDuration: autoDismissDuration,
                contentView: contentView
            )
        )
    }
}
