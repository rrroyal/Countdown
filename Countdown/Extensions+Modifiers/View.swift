//
//  View.swift
//  Harbour
//
//  Created by royal on 15/03/2020.
//  Copyright © 2020 shameful. All rights reserved.
//

import SwiftUI
import Combine

/// Modifies button to our custom style
struct ButtonModifier: ViewModifier {
	var color: Color
	var enabled: Bool
	
	func body(content: Content) -> some View {
		content
			.foregroundColor(.white)
			.font(.headline)
			.padding()
			.frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
			.background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(color))
			.opacity(self.enabled ? 1 : 0.5)
	}
}

/// Adapts the view to software keyboard
struct AdaptsToSoftwareKeyboard: ViewModifier {
	@State var currentHeight: CGFloat = 0
	
	func body(content: Content) -> some View {
		content
			.padding(.bottom, currentHeight)
			// .animation(.easeInOut(duration: 0.25))
			.animation(.default)
			.edgesIgnoringSafeArea(currentHeight == 0 ? Edge.Set() : .bottom)
			.onAppear(perform: subscribeToKeyboardChanges)
	}
	
	// Keyboard Height
	private let keyboardHeightOnOpening = NotificationCenter.default
		.publisher(for: UIResponder.keyboardWillShowNotification)
		.map { $0.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect }
		.map { $0.height }
	
	private let keyboardHeightOnHiding = NotificationCenter.default
		.publisher(for: UIResponder.keyboardWillHideNotification)
		.map { _ in return CGFloat(0) }
	
	// Subscriber to Keyboard's changes
	private func subscribeToKeyboardChanges() {
		_ = Publishers.Merge(keyboardHeightOnOpening, keyboardHeightOnHiding)
			.subscribe(on: RunLoop.main)
			.sink { (height) in
				if self.currentHeight == 0 || height == 0 {
					self.currentHeight = height
				}
		}
	}
}


/// Modifies button to our custom style
struct NavigationBarButtonModifier: ViewModifier {
	var edge: Edge.Set
	
	func body(content: Content) -> some View {
		content
			.padding([.vertical, edge == .leading ? .trailing : .leading])
			.padding(edge, 5)
			.font(.system(size: 20))
	}
}

// MARK: - View
extension View {
	func customButton(_ color: Color, enabled: Bool) -> ModifiedContent<Self, ButtonModifier> {
		return modifier(ButtonModifier(color: color, enabled: enabled))
	}
	
	func navigationBarButton(edge: Edge.Set) -> ModifiedContent<Self, NavigationBarButtonModifier> {
		return modifier(NavigationBarButtonModifier(edge: edge))
	}
	
	func withBackground() -> some View {
		return self
			.background(Color.secondary.opacity(0.05))
			.mask(RoundedRectangle(cornerRadius: 10))
			.frame(height: 55)
	}
}
