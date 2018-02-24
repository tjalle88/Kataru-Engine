//
//  GameViewController.swift
//  Kataru Engine
//
//  Created by Kalle Jönsson on 2017-12-10.
//  Copyright © 2017 Takemaki Studios. All rights reserved.
//

import SpriteKit

class GameViewController: UIViewController {
		
	var titleScene: TitleScene!
		
	override var prefersStatusBarHidden: Bool {
		return true
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//Configure main view
		let skView = view as! SKView
		skView.showsFPS = true
		
		//Create and configure game scene
		titleScene = TitleScene(size: skView.bounds.size)
		titleScene.scaleMode = .aspectFill
		
		//show the scene
		skView.presentScene(titleScene)
		
		//Ready next scene and transition
		let transition = SKTransition.fade(withDuration: 1)
		let mainMenuScene = MainMenu(size: skView.bounds.size)
		mainMenuScene.scaleMode = .aspectFill
		
		DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
			skView.presentScene(mainMenuScene, transition: transition)
		})
		
	}
		
}
