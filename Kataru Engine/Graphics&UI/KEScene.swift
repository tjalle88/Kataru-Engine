//
//  KEScene.swift
//  Kataru Engine
//
//  Created by Kalle Takeuchi on 2018-02-26.
//  Copyright © 2018 Takemaki Studios. All rights reserved.
//

import SpriteKit

class KEScene: SKScene {
	
	///The dictionary of dialog characters will be built upon initialization
    var dialogCharacters: [String: KEDialogCharacter]
	///When the scene is in dialog mode, touches began will go to the next textbox page
	var dialogMode: Bool = false
	
	/**
	Shows a box with dialog
	
	- parameter character: The name of the speaking character. Must be a character already added to the scene.
	- parameter expression: The expression the character makes when speaking. Must be an expression present in the character data.
	- parameter style: Select an appropriate style. Default: Standard.
	- parameter effect: Visual effect to be shown when delivering dialog. Default: none.
	- parameter dialog: The spoken dialog.
	*/
    func ShowDialog(character: String, expression: String, style: KEDialogStyle, effect: KEDialogEffect, dialog: String) {
		
		var characterName: String
		
		if dialogCharacters.keys.contains(character) {
			characterName = character
		} else {
			characterName = "default"
		}
		
		let mySize = self.view!.bounds.size
		let boxHeight = mySize.height/3
		let boxWidth = mySize.width
		let boxSize = CGSize(width: boxWidth, height: boxHeight)
		let lblNameText: KEDialogLabelNode
		let sprPortraitNode: KEDialogSpriteNode
		
		//Set character name location
		if characterName != "default" {
			
			lblNameText = KEDialogLabelNode()
			lblNameText.fontName = gameSettings.defaultFont
			lblNameText.fontSize = gameSettings.defaultFontSize
			lblNameText.color = SKColor.white
			lblNameText.text = characterName
			lblNameText.position = CGPoint(x: 0, y: boxHeight)
			lblNameText.horizontalAlignmentMode = .left
			addChild(lblNameText)
			
		}
		
        let lblDialogText = KEAnimatedDialogLabelNode(fontNamed: dialogCharacters[characterName]!.fontStyle.fontName)
        lblDialogText.fontSize = dialogCharacters[characterName]!.fontStyle.pointSize
		let margin = lblDialogText.fontSize * 2
		lblDialogText.fontColor = dialogCharacters[characterName]!.textColor
		
		let boxShape = KEDialogShapeNode(rectOf: boxSize)
		boxShape.position = CGPoint(x: boxWidth/2, y: boxHeight/2)
		boxShape.strokeColor = SKColor.gray
		boxShape.fillColor = SKColor.gray
		boxShape.alpha = 0.5
		

		
		//Set portrait location
		if expression != "" && dialogCharacters.keys.contains(character) {
			
			if (dialogCharacters[character]!.portraits.keys.contains(expression)){
				
				sprPortraitNode = KEDialogSpriteNode(imageNamed: dialogCharacters[character]!.portraits[expression]!)
				sprPortraitNode.anchorPoint = CGPoint(x: 1.0, y: 0.0)
				sprPortraitNode.position = CGPoint(x: boxWidth, y: boxHeight)
				addChild(sprPortraitNode)
				
			}
			
		}
		
        //Set dialog text location
		lblDialogText.position = CGPoint(x: lblDialogText.fontSize * 2, y: boxHeight - lblDialogText.fontSize * 2)
		lblDialogText.text = ""
		lblDialogText.horizontalAlignmentMode = .left
			
		addChild(boxShape)
        addChild(lblDialogText)
		
		lblDialogText.set(stringToAnimate: dialog, maxSize: CGSize(width: boxSize.width - margin * 2, height: boxSize.height - margin * 2), animationDelay: 100000)
		
    }
	
	//The charcters have to be prepared in an earlier step
	init(size: CGSize, dictOfCharacters: [String : KEDialogCharacter]) {
        
        dialogCharacters = dictOfCharacters
        
        //Initiates the default dialog character, which is basically only plain text with no portrait.
        dialogCharacters["default"] = KEDialogCharacter()
        
        super.init(size: size)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		gameSettings.testCounter += 1
		
		cleanDialogNodes()
		
		switch gameSettings.testCounter {
			
		case 1:
			ShowDialog(character: "カッレ", expression: "smile", style: KEDialogStyle.standard, effect: KEDialogEffect.none, dialog: "今日は、タカちゃん! これはテストの為の長い文書です。この文書で、分が長すぎたら、どうなるか試します。まだテキストが足りないから、つづく。結局新しい一列が出るはずです。")
		case 2:
			ShowDialog(character: "カッレ", expression: "frown", style: KEDialogStyle.standard, effect: KEDialogEffect.none, dialog: "ところで、甘いもの食べすぎたらダメだ！")
		default:
			soundModule.playSoundEffect(effectName: "Neko")
		}
    }
	
	func cleanDialogNodes() {
		
		for node in children {
			
			if node is KEDialogSpriteNode || node is KEDialogLabelNode || node is KEAnimatedDialogLabelNode || node is KEDialogShapeNode {
				
				node.removeFromParent()
			}
			
		}
		
	}
	
	override func update(_ currentTime: TimeInterval) {
		super.update(currentTime)
		
		for node in self.children {
			
			if let animatedLabel = node as? KEAnimatedDialogLabelNode {
				
				if animatedLabel.awaitingAnimationStart {
				
					startAnimation(animatedLabel: animatedLabel)
					
				}
				
			}
			
		}
		
	}
	
	func startAnimation(animatedLabel: KEAnimatedDialogLabelNode) {
		
		

		animatedLabel.awaitingAnimationStart = false
		
	}
	
	func queueLetter(animatedLabel: KEAnimatedDialogLabelNode, letterToAdd: String, delay: UInt32) {
		
		DispatchQueue.global(qos: .userInitiated).async {
		
			usleep(delay)
		
			DispatchQueue.main.async {
				animatedLabel.text = animatedLabel.text! + letterToAdd
			
				//Do not make "Voice" sound when printing spaces.
				if letterToAdd != " " {
					self.soundModule.playSoundEffect(effectName: "voice")
				}
			
			}
			
		}
		
	}
	
	func resetTextBox(animatedLabel: KEAnimatedDialogLabelNode, delay: UInt32) {
		
		DispatchQueue.global(qos: .userInitiated).async {
			
			usleep(delay)
			
			DispatchQueue.main.async {
				animatedLabel.text = ""
			}
			
		}
		
	}
	
    
}
