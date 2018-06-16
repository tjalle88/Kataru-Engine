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
	///Handles dialog text
	var lblDialogText: KEAnimatedDialogLabelNode?
	
	
	//The charcters have to be prepared in an earlier step
	init(size: CGSize, dictOfCharacters: [String : KEDialogCharacter]) {
		
		dialogCharacters = dictOfCharacters
		
		//Initiates the default dialog character, which is basically only plain text with no portrait.
		dialogCharacters["default"] = KEDialogCharacter()
		
		super.init(size: size)
		
	}
	
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
		
		lblDialogText = KEAnimatedDialogLabelNode(fontName: dialogCharacters[characterName]!.fontStyle.fontName, fontSize: dialogCharacters[characterName]!.fontStyle.pointSize, fontColor: dialogCharacters[characterName]!.textColor)
		
		if lblDialogText == nil {
			return
		}
		
		let margin = lblDialogText!.fontSize * 2
		let boxShape = KEDialogShapeNode(rectOf: boxSize) 
		boxShape.position = CGPoint(x: boxWidth/2, y: boxHeight/2)
		boxShape.strokeColor = SKColor.gray
		boxShape.fillColor = SKColor.gray
		boxShape.alpha = 0.5
		addChild(boxShape)
		
		//Set portrait location
		if expression != "" && dialogCharacters.keys.contains(character) {
			
			if (dialogCharacters[character]!.portraits.keys.contains(expression)){
				
				sprPortraitNode = KEDialogSpriteNode(imageNamed: dialogCharacters[character]!.portraits[expression]!)
				sprPortraitNode.anchorPoint = CGPoint(x: 1.0, y: 0.0)
				sprPortraitNode.position = CGPoint(x: boxWidth, y: boxHeight)
				addChild(sprPortraitNode)
				
			}
			
		}
		
        //Set dialog text location.
		var pos = CGPoint(x: lblDialogText!.fontSize * 2, y: boxHeight - lblDialogText!.fontSize * 2)
		//Convert position to view coordinates. In a view Y=0 is at the top, not at the bottom like in a scene.
		pos = convertToViewCoordinates(sceneCoordinates: pos)
		lblDialogText!.set(stringToAnimate: dialog, characterDelay: 100000, positionOfTextBox: pos, sizeOfTextBox: CGSize(width: boxSize.width - margin * 2, height: boxSize.height - margin * 2))
		
    }
	
	func convertToViewCoordinates(sceneCoordinates sc: CGPoint) -> CGPoint {
		
		let y = self.view!.bounds.height - sc.y
		let x = sc.x
		
		return CGPoint(x: x, y: y)
		
	}
	
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		gameSettings.testCounter = 3
		
		cleanDialogNodes()
		
		switch gameSettings.testCounter {
			
		case 1:
			ShowDialog(character: "カッレ", expression: "smile", style: KEDialogStyle.standard, effect: KEDialogEffect.none, dialog: "今日は、タカちゃん! これはテストの為の長い文書です。この文書で、分が長すぎたら、どうなるか試します。まだテキストが足りないから、つづく。結局新しい一列が出るはずです。")
		case 2:
			ShowDialog(character: "カッレ", expression: "frown", style: KEDialogStyle.standard, effect: KEDialogEffect.none, dialog: "ところで、甘いもの食べすぎたらダメだ！")
		case 3:
			ShowDialog(character: "Kalle", expression: "frown", style: .standard, effect: .none, dialog: "Let's take this in english")
		default:
			soundModule.playSoundEffect(effectName: "Neko")
		}
    }
	
	func cleanDialogNodes() {
		
		for node in children {
			
			if node is KEDialogSpriteNode || node is KEDialogLabelNode || node is KEDialogShapeNode {
				
				node.removeFromParent()
			}
			
		}
		
	}
	
	override func update(_ currentTime: TimeInterval) {
		super.update(currentTime)
		
		if lblDialogText != nil {
			
			if lblDialogText!.awaitingAnimationStart {
				self.view!.addSubview(lblDialogText!.textBox)
				lblDialogText!.startAnimation()
			}
			
		}
		
	}
	
    
}
