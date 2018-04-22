//
//  KEGeneralFunctions.swift
//  Kataru Engine
//
//  Created by Kalle Takeuchi on 2018-02-26.
//  Copyright © 2018 Takemaki Studios. All rights reserved.
//

import SpriteKit

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

	/*
	//Animates a text string one letter at a time in the label node. Each letter has a delay between them specified by the argument. The kabel node starts empty.
	func letterByLetterAnimation(textToAnimate: String, animationTimeInMilliseconds: Int) {
		
		self.text = ""
		
		for ch in textToAnimate {
			
			diplayTextAfterDelay(textToDisplay: self.text! + String(ch), delayInMilliseconds: animationTimeInMilliseconds)
			
		}
		
		return
		
	}
	
	func diplayTextAfterDelay(textToDisplay: String, delayInMilliseconds: Int) {
		
		while true {
			
			DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(delayInMilliseconds), execute: {
				
				self.text = textToDisplay
				return
				
			})
			
		}
		
	}
	
}
*/
