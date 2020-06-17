//
//  StoreModel.swift
//  Countdown
//
//  Created by royal on 11/06/2020.
//  Copyright © 2020 shameful. All rights reserved.
//

import UIKit
import CoreData
import Combine

class Countdown: Identifiable, Hashable, Codable, Comparable {
	internal init(title: String, icon: String?, colorHex: String?, date: Date) {
		self.title = title
		self.colorHex = colorHex
		self.date = date
		self.icon = (icon?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true) ? nil : icon
	}
	
	private enum CodingKeys: String, CodingKey {
		case id
		case title
		case icon
		case colorHex
		case date
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(id, forKey: .id)
		try container.encode(title, forKey: .title)
		try container.encode(icon, forKey: .icon)
		try container.encode(colorHex, forKey: .colorHex)
		try container.encode(date, forKey: .date)
	}
	
	public func hash(into hasher: inout Hasher) {
		hasher.combine(ObjectIdentifier(self).hashValue)
	}
	
	static func < (lhs: Countdown, rhs: Countdown) -> Bool {
		return lhs.date < rhs.date
	}
	
	static func == (lhs: Countdown, rhs: Countdown) -> Bool {
		return lhs.date == rhs.date
	}
	
	var id: UUID = UUID()
	var title: String
	var icon: String?
	var date: Date
	private var colorHex: String?
	
	var color: UIColor? {
		get {
			guard let hex = self.colorHex else {
				return nil
			}
			return UIColor(hex: hex)
		}
		set(value) {
			self.colorHex = value?.hex
		}
	}
}

final class StoreModel: ObservableObject {
	private var appDelegate: AppDelegate?
	
	public let countdownsUpdated = PassthroughSubject<Int, Never>()
	@Published var countdowns: [Countdown] = []
	
	init() {
		appDelegate = UIApplication.shared.delegate as? AppDelegate
		UIImpactFeedbackGenerator().prepare()
				
		// Load cached data
		let stored = try? appDelegate?.persistentContainer.viewContext.fetch(Countdowns.fetchRequest() as NSFetchRequest)
		if let stored: Countdowns = stored?.last as? Countdowns {
			let decoder = JSONDecoder()
			
			if let countdowns = stored.savedCountdowns {
				if let decoded = try? decoder.decode([Countdown].self, from: countdowns) {
					self.countdowns = decoded
				}
			}
		}		
	}
	
	/// Adds new countdown
	/// - Parameter countdown: Countdown data
	public func addCountdown(_ countdown: Countdown) {
		if (self.countdowns.contains(countdown)) {
			return
		}
		
		self.countdowns.append(countdown)
		self.countdownsUpdated.send(self.countdowns.count)
		appDelegate?.saveAppData()
	}
	
	/// Removes the selected countdown.
	/// - Parameter index: Countdown index
	public func removeCountdown(at index: Int) {
		self.countdowns.remove(at: index)
		self.countdownsUpdated.send(self.countdowns.count)
		appDelegate?.saveAppData()
	}
}
