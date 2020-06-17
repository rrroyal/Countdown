//
//  UIColor.swift
//  Countdown
//
//  Created by royal on 16/06/2020.
//  Copyright © 2020 shameful. All rights reserved.
//

import UIKit

extension UIColor {
	public convenience init?(hex: String) {
		var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
		
		// Remove the #
		if (cString.hasPrefix("#")) {
			cString.remove(at: cString.startIndex)
		}
		
		// Keep it at maximum 6 characters
		if (cString.count > 6) {
			cString.removeLast(cString.count - 6)
		}
		
		if (!cString.isValidHex) {
			return nil
		}
		
		// If invalid value, make the color transparent
		let alpha: CGFloat = cString.isValidHex ? 1 : 0
		var rgbValue: UInt64 = 0
		Scanner(string: cString).scanHexInt64(&rgbValue)
		
		self.init(
			red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
			green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
			blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
			alpha: alpha
		)
	}
	
	public var hex: String? {
		guard let components = cgColor.components, components.count >= 3 else {
			return nil
		}
		
		let r = Float(components[0])
		let g = Float(components[1])
		let b = Float(components[2])
				
		return String(format: "#%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
	}
}
