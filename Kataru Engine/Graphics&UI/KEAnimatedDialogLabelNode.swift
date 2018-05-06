//
//  KEAnimatedLabelNode.swift
//  Kataru Engine
//
//  Created by Kalle Takeuchi on 2018-03-18.
//  Copyright © 2018 Takemaki Studios. All rights reserved.
//

import SpriteKit

class KEAnimatedDialogLabelNode {
	
	///The strings in the embedded arrays represent rows in one textbox. Each embedded array itself is a new textbox
	fileprivate var animatedText: [[String]] = [[""]]
	var boxCounter: Int = 0 
	var awaitingAnimationStart: Bool = false
	var delayBetweenLetters = 0
	///Contains each row of the textlabel
	fileprivate var textLabelInstances = [SKLabelNode]()
	var fontName: String = gameSettings.defaultFont
	var fontSize: CGFloat = gameSettings.defaultFontSize
	var fontColor: SKColor
	var isAnimating: Bool = false
	var position = CGPoint(x: 0, y: 0)
	var horozontalAlignmentMode: SKLabelHorizontalAlignmentMode = .left
	fileprivate var textHeight: CGFloat = 0
	
	init(fontName fn: String, fontSize fz: CGFloat, fontColor fc: SKColor) {
		fontSize = fz
		fontName = fn
		fontColor = fc
	}
	
	/**
	Returns references to SKLabelNodes so that they can be added to a scene
	*/
	func getChildren() -> [SKLabelNode] {
		
		return textLabelInstances
		
	}
	
	/**Schedules the appearence of the letters in a textbox**/
	func startAnimation() {
		
		isAnimating = true
		var rowCounter: Int = 0
		textLabelInstances[rowCounter].position = position
		
		let delayChart = getLetterDelayChart(forBox: boxCounter)
		
		//populate text label instances
		textLabelInstances.removeAll()
		
		var tempNodeReference: SKLabelNode
		var tempPosition: CGPoint = CGPoint(x: position.x, y: position.y)
		
		for _ in  delayChart {
			tempNodeReference = SKLabelNode()
			tempNodeReference.position = tempPosition
			textLabelInstances.append(tempNodeReference)
			tempPosition = CGPoint(x: tempPosition.x, y: tempPosition.y - textHeight)
		}
		
		//Queue up letters to animate in each row
		for row in delayChart {
			
			for letter in row.keys {
				
				queueLetter(letterToAdd: letter, row: rowCounter, delay: delayChart[rowCounter][letter]!)
				
			}
			
			rowCounter += 1
			
		}

		
	}
	
	func queueLetter(letterToAdd: String, row: Int, delay: UInt32) {
		
		if textLabelInstances.count - 1 >= row {
		
			DispatchQueue.global(qos: .userInitiated).async {
			
				usleep(delay)
			
				DispatchQueue.main.async {
				
					if self.textLabelInstances[row].text == nil {
						self.textLabelInstances[row].text = ""
					}
					
					self.textLabelInstances[row].text! += letterToAdd
					
					//Do not make "Voice" sound when printing spaces.
					if letterToAdd != " " {
						soundModule.playSoundEffect(effectName: "voice")
					}
					
				}
			
			}
			
		}
		
	}
	
	/** The letter delay chart shows the delay for each letter in a textbox to appear */
	func getLetterDelayChart(forBox nr: Int) -> [[String:UInt32]] {
		
		var delayChart = [[String:UInt32]]()
		var delayCounter = 0
		var counter = 0
		
		for row in animatedText[nr] {
			
			for letter in row {
				
				delayChart[counter][String(letter)] = UInt32(delayCounter * delayBetweenLetters)
				delayCounter += 1
				
			}
			
			counter += 1
			delayChart.append([String:UInt32]())
			
		}
		
		return delayChart
		
	}
	
	func reset() {
		
		textLabelInstances.removeAll()
		textLabelInstances.append(SKLabelNode(fontNamed: fontName))
		textLabelInstances[0].fontSize = fontSize
		
	}
	
	/**
	Sets the string to be animated and the animation speed.
	The animation consists of letters appearing one by one
	with a delay between them.
	
	# Arguments #
	1. stringToAnimate: string to display and animate
	2. animationDelay: The dalay between the appearence of letters
	*/
	func set(stringToAnimate: String, maxSize: CGSize, animationDelay: Int) {
		
		reset()
		
		var formatProgressArray = ["", stringToAnimate]
		var formatedRows = [String]()
		
		//Get the correctly formated rows
		while formatProgressArray[1].count > 0 {
			
			formatProgressArray = formatedRowAndRemainder(stringToFormat: formatProgressArray[1], maxWidth: maxSize.width)
			formatedRows.append(formatProgressArray[0])
			
		}
		
		animatedText = formatTextBoxes(rows: formatedRows, maxHeight: maxSize.height)
		
		textHeight = stringToAnimate.sizeOfLabelNode(fontName: fontName, fontSize: fontSize).height
		awaitingAnimationStart = true
		boxCounter = 0
		delayBetweenLetters = animationDelay
		
	}
	
	
	func formatTextBoxes(rows: [String], maxHeight: CGFloat) -> [[String]] {
		
		var textBoxArray = [[String]]()
		var height: CGFloat = 0
		var textBoxCounter: Int = 0
		
		for row in rows {
			
			//If height will fit within textbox
			if height + row.sizeOfLabelNode(fontName: fontName, fontSize: fontSize).height > maxHeight {
				
				height += row.sizeOfLabelNode(fontName: fontName, fontSize: fontSize).height
				textBoxArray[textBoxCounter].append(row)
				
			} else {
				
				//Start a new textbox (column)
				textBoxCounter += 1
				textBoxArray.append([String]())
				textBoxArray[textBoxCounter].append(row)
				height = row.sizeOfLabelNode(fontName: fontName, fontSize: fontSize).height
				
				
			}
			
		}
		
		return textBoxArray
		
	}
	
	/**
	Returns an array of length 2. Array[0] containes a string with the length of one row.
	Array[1] contains the remainder of the given string.
	
	###TODO
	- [ ] Add support for line breaks
	*/
	func formatedRowAndRemainder(stringToFormat str: String, maxWidth: CGFloat) -> [String] {
		
		var formatedString = [[String]]()
		var size = str.sizeOfLabelNode(fontName: fontName, fontSize: fontSize)
		formatedString.append([String]())
		formatedString[0].append(str)
		var splitString: [Substring]
		var mutatedString: String = ""
		var wordCounter : Int = 0
		
		//Spit string into words
		splitString = str.split(separator: Character(" "))

		let numberOfWords = splitString.count
		
		if maxWidth > size.width  {
			
			while maxWidth > size.width {
				
				mutatedString = ""
				
				/*Append all words to mutatedString minus the last word.
				If the while requirement is not broken, next time around append all but the
				last 2 words etc */
				wordCounter += 1
				
				//The first word cannot fit.
				if wordCounter == numberOfWords {
					
					//Let the bloody word clip. I don't care.
					mutatedString = String(splitString[0])
					break
					
				} else {
					
					for i in 0...numberOfWords - 1 - wordCounter {
						
						mutatedString = mutatedString + " " + String(splitString[i])
						
					}
				}
				
				size = mutatedString.sizeOfLabelNode(fontName: self.fontName, fontSize: self.fontSize)
				
			}
			
		} else {
			
			mutatedString = str
			
		}
		
		var returnArray = [mutatedString]
		var remainder = ""
		
		if wordCounter < splitString.count {
			
			for i in wordCounter...splitString.count-1 {
				remainder += splitString[i]
			}
			
		}
		
		returnArray.append(remainder)
		return returnArray

	}
		
}
