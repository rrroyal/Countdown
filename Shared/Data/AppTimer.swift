//
//  AppTimer.swift
//  Countdown
//
//  Created by royal on 16/06/2020.
//  Copyright © 2020 shameful. All rights reserved.
//

import Foundation
import Combine

final class AppTimer: ObservableObject {
	public static let shared: AppTimer = AppTimer()
	public let timeChanged = PassthroughSubject<Void, Never>()
	public var timer: Timer!
	
	private init() { }
	
	/// Starts the timer.
	public func start() {
		print("[*] (AppTimer) Starting timer.")
		self.timer?.invalidate()
		self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
			self.timeChanged.send()
		}
	}
	
	/// Invalidates the timer.
	public func invalidate() {
		print("[*] (AppTimer) Invalidating timer.")
		self.timer?.invalidate()
	}
}
