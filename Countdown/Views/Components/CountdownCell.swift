//
//  CountdownCell.swift
//  Countdown
//
//  Created by royal on 17/06/2020.
//  Copyright © 2020 shameful. All rights reserved.
//

import SwiftUI

struct CountdownCell: View {
	var countdown: Countdown
	var now: Date
	
    var body: some View {
		VStack(alignment: .leading) {
			HStack {
				if (countdown.icon != nil && !(countdown.icon?.isEmpty ?? true)) {
					Image(systemName: countdown.icon ?? "staroflife.fill")
				}
				
				Text(countdown.title)
					.font(.headline)
			}
			.padding(.bottom, 2)
			Text(countdown.date.distanceString(from: self.now) ?? "Unknown")
				.font(.system(.callout, design: .monospaced))
		}
		.foregroundColor(countdown.color == nil ? Color.primary : Color(countdown.color!))
		.padding(.vertical, 10)
		// .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(Color(UIColor.systemGray5).opacity(0.25)))
		.contentShape(Rectangle())
		.onDrop(of: ["com.apple.uikit.color"], isTargeted: nil) { (items) in
			if let item = items.first {
				_ = item.loadObject(ofClass: UIColor.self) { (color, _) in
					if let color = color as? UIColor {
						self.countdown.color = color
					}
				}
			}
			
			return true
		}
    }
}

/* struct CountdownCell_Previews: PreviewProvider {
    static var previews: some View {
        CountdownCell()
    }
} */
