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
		
	}
	
	override func viewDidLayoutSubviews() {
		
		//Configure main view
		let skView = view as! SKView
		skView.showsFPS = true
		
		//Create and configure game scene
		if #available(iOS 11.0, *) {
			gameSettings.rightPadding = skView.safeAreaInsets.right
			print("rightPadding: " + String(Float(gameSettings.rightPadding!)))
			gameSettings.leftPadding = skView.safeAreaInsets.left
			print("leftPadding: " + String(Float(gameSettings.leftPadding!)))
			gameSettings.topPadding = skView.safeAreaInsets.top
			print("topPadding: " + String(Float(gameSettings.topPadding!)))
			gameSettings.bottomPadding = skView.safeAreaInsets.bottom
			print("bottomPadding: " + String(Float(gameSettings.bottomPadding!)))
		} else {
			gameSettings.rightPadding = 0
			gameSettings.leftPadding = 0
			gameSettings.topPadding = 0
			gameSettings.bottomPadding = 0
		}
		
		titleScene = TitleScene(size: skView.frame.size)
		titleScene.scaleMode = .aspectFill
		
		//show the scene
		skView.presentScene(titleScene)
		
		//Ready next scene and transition
		//let guide = view.safeAreaLayoutGuide
		let transition = SKTransition.fade(withDuration: 1)
		let mainMenuScene = MainMenu(size: skView.frame.size)
		mainMenuScene.scaleMode = .aspectFill
		
		DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
			skView.presentScene(mainMenuScene, transition: transition)
		})
		
	}
		
}
