//
//  GameScene.swift
//  Kataru Engine
//
//  Created by Kalle Jönsson on 2017-12-10.
//  Copyright © 2017 Takemaki Studios. All rights reserved.
//

import SpriteKit
import GameplayKit

class TitleScene: SKScene {
	
	//Background for the company logo
	let backgroundNode = SKSpriteNode(imageNamed: "TakemakiBackground")
	let logoNode = SKSpriteNode(imageNamed: "TakemakiLogo")
	let companyNode = SKLabelNode(fontNamed: gameSettings.titleFont)
	let soundModule = KEAudioModule(numberOfSoundPlayers: 5)

	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override init(size: CGSize) {
		super.init(size: size)
		
		backgroundColor = SKColor(red: 0.62, green: 0.19, blue: 0.19, alpha: 1)
		
		backgroundNode.size.width = frame.size.width
		backgroundNode.anchorPoint = CGPoint(x: 0.5, y: 0.0)
		backgroundNode.position = CGPoint(x: size.width / 2.0, y: 0.0)
		addChild(backgroundNode)
		
		companyNode.text = "Takemaki Studios!"
		companyNode.position = CGPoint(x: size.width/2, y: size.height/2)
		addChild(companyNode)
		
		logoNode.position = CGPoint(x: companyNode.position.x, y: companyNode.position.y + 2*companyNode.fontSize)
		addChild(logoNode)
		
		print("The size is (\(size)")
		
	}
	
	override func sceneDidLoad() {
		super.sceneDidLoad()
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		soundModule.playSoundEffect(effectName: "Neko")
	}
	
}
