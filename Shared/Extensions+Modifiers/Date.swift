//
//  Date.swift
//  Countdown
//
//  Created by royal on 16/06/2020.
//  Copyright © 2020 shameful. All rights reserved.
//

import Foundation

extension Date {
	public var withoutSeconds: Date {
		let components: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute]
		return Calendar.autoupdatingCurrent.dateComponents(components, from: self).date ?? self
	}
	
	public func distanceString(from date: Date) -> String? {
		let components: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
		let difference: DateComponents = Calendar.autoupdatingCurrent.dateComponents(components, from: date, to: self)
		let formatter = DateComponentsFormatter()
		formatter.unitsStyle = .full
		
		return formatter.string(from: difference)
	}
	
	public func string(format: String) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = format
		dateFormatter.locale = Locale.autoupdatingCurrent
		
		return dateFormatter.string(from: self)
	}
}
