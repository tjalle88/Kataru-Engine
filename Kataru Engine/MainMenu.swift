//
//  MainMenu.swift
//  Kataru Engine
//
//  Created by Kalle Takeuchi on 2018-01-17.
//  Copyright © 2018 Takemaki Studios. All rights reserved.
//

import SpriteKit
import GameplayKit

fileprivate enum MainMenuItem: String {
	case startGame = "Start"
	case continueGame = "Continue"
}

class MainMenu: SKScene {
	
	//Background for the main menu
	let backgroundNode = SKSpriteNode(imageNamed: "MainMenuBackground")
	let titleNode = SKLabelNode(fontNamed: gameSettings.titleFont)
	let soundModule = KEAudioModule(numberOfSoundPlayers: 5)
	let menuItems: [String] = [MainMenuItem.startGame.rawValue, MainMenuItem.continueGame.rawValue]
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override init(size: CGSize) {
		super.init(size: size)
		
		backgroundColor = SKColor(red: 0.62, green: 0.19, blue: 0.19, alpha: 1)
		
		backgroundNode.size.width = frame.size.width
		backgroundNode.anchorPoint = CGPoint(x: 0.5, y: 0.0)
		backgroundNode.position = CGPoint(x: size.width / 2.0, y: 0.0)
		backgroundNode.name = "background"
		addChild(backgroundNode)
		
		//Add game title
		titleNode.position = CGPoint(x: size.width/2.0, y: size.height*3/4)
		titleNode.text = gameSettings.gameTitle
		
		var tempLabel: SKLabelNode
		var counter: Int = 0
		var yLocation: Int = Int(size.height*3/4)
		var name: String
		
		for item in menuItems {
			
			tempLabel = SKLabelNode(fontNamed: gameSettings.titleFont)
			tempLabel.text = item
			name = "lbl" + item
			tempLabel.name = name
			tempLabel.position = CGPoint(x: Int(size.width*2/3), y: yLocation)
			tempLabel.horizontalAlignmentMode = .left
			tempLabel.isUserInteractionEnabled = false
			
			addChild(tempLabel)
			
			counter = counter + 1
			yLocation = yLocation - Int(tempLabel.fontSize*2)
			
		}
		
	}
	
	override func sceneDidLoad() {
		super.sceneDidLoad()
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		if let touch = touches.first {
			
			let location = touch.location(in: self)
			var frame: CGRect
			
			for node in self.children {
				
				frame = node.frame
				
				if frame.contains(location) {
					
					if let name = node.name {
						
						if name == "lbl" + MainMenuItem.startGame.rawValue {
							newGame()
						} else if name == "lbl" + MainMenuItem.continueGame.rawValue{
							continueGame()
						}
						
					}
					
				}
				
			}
			
		}
		
	}
	
	func newGame() {
		
		var characters = [String : KEDialogCharacter]()
		characters["カッレ"] = KEDialogCharacter(nameOfCharacter: "カッレ", colorOfText: "1.0,1.0,1.0,1.0", fontName: gameSettings.defaultFont, fontSize: "30", portraitData: "smile:testSmile,frown:testFrown")
		
		let skView: SKView = view!
        let scene = KEScene(size: skView.frame.size, dictOfCharacters: characters)
		self.view!.presentScene(scene, transition: SKTransition.fade(withDuration: 1))
	}
	
	func continueGame() {
		soundModule.playSoundEffect(effectName: "select")
	}
	
}
