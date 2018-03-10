//
//  KEDialogCharacter.swift
//  Kataru Engine
//
//  Created by Kalle Takeuchi on 2018-02-26.
//  Copyright © 2018 Takemaki Studios. All rights reserved.
//

import SpriteKit

class KEDialogCharacter {
	
	//Every portrait corresponds to a mood. A portrait is represented by the resourse name
	//of the image file.
	var portraits: [String: String]
	
	//A character can have a specific text color.
	let textColor: SKColor
	
	//Special font style for the character
	let fontStyle: UIFont
	
	
	init(colorOfText: String = "1,1,1,1", fontName: String = "default", fontSize: String = "11", portraitData: String = "") {
		
		var splitChar: Character
		
		//Parse portraits
		if portraitData != "" {
			
			splitChar = ","
			let splitPD = portraitData.split(separator: splitChar)
			var keyValuePair: [Substring]
			portraits = [String: String]()
			splitChar = ":"
			
			for portrait in splitPD {
				
				keyValuePair = portrait.split(separator: splitChar)
				portraits[String(keyValuePair[0])] = String(keyValuePair[1])
				
			}
			
		}
		
		//Set text color
		splitChar = ","
        var colorStringArray: [Substring] = colorOfText.split(separator: splitChar)
		if colorStringArray.count != 4 {
			colorStringArray = ["1", "1", "1", "1"]
		}
		//Check that color values are numeric and between 0 and 1
		for text in colorStringArray {
			
			if !KEIsNumeric(text: String(text)){
				colorStringArray = ["1", "1", "1", "1"]
				break
			}
			
		}
		
		var colorValues = [CGFloat]()
		var colorValue: CGFloat
		
		for valueString in colorStringArray {
			
            guard let colorDoubleValue = Double(valueString) else {
                colorValues = [1, 1, 1, 1]
                break
            }
			
            colorValue = CGFloat(colorDoubleValue)
			colorValues.append(colorValue)
			
		}
		
		textColor = SKColor(red: colorValues[0], green: colorValues[1], blue: colorValues[2], alpha: colorValues[3])
		
		
		//SetFont
		var fontSizeValue: CGFloat
		
		if fontName == "default" || fontName == "Default" {
			fontStyle = UIFont(name: gameSettings.defaultFont!, size: gameSettings.defaultFontSize!)
		} else {
			
            guard let fontSizeDubleValue = Double(fontSize) {
//                make ui font here
            } else {
                fontStyle = UIFont(name: gameSettings.defaultFont, size: gameSettings.defaultFontSize)
            }
            
			do {
				try fontSizeValue = CGFloat(fontSize)
				try fontStyle = UIFont(name: fontName, size: fontSizeValue)
			}catch {
				fontStyle = UIFont(name: gameSettings.defaultFont, size: gameSettings.defaultFontSize)
			}
			
		}
		
	}
	
}
