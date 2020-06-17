//
//  String.swift
//  Countdown
//
//  Created by royal on 17/06/2020.
//  Copyright © 2020 shameful. All rights reserved.
//

import Foundation

extension String {
	var isValidHex: Bool {
		var string: String = self.uppercased()
		if string.starts(with: "#") {
			string = String(string.dropFirst())
		}
		return string.count >= 3 && string.count <= 6 && string.rangeOfCharacter(from: CharacterSet(charactersIn: "0123456789ABCDEF").inverted) == nil
	}
}
