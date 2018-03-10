//
//  KEGeneralFunctions.swift
//  Kataru Engine
//
//  Created by Kalle Takeuchi on 2018-02-26.
//  Copyright © 2018 Takemaki Studios. All rights reserved.
//

import Foundation

func KEIsNumeric(text: String) -> Bool {
	
	let numbers: [Character] = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
	var pointCounter: Int = 0
	
	for char in text {
		
		if !numbers.contains(char) {
			
			if (char == ".") && pointCounter < 2 {
				pointCounter += 1
			} else {
				return false
			}
		
		}
		
	}
	
	return true
	
}
