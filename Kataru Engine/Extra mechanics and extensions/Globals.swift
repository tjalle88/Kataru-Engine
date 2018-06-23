//
//  Globals.swift
//  Kataru Engine
//
//  Created by Kalle Takeuchi on 2018-06-23.
//  Copyright © 2018 Takemaki Studios. All rights reserved.
//

import Foundation
import UIKit

var gameSettings = SKGameSettings()
///The sound module of the game
let soundModule = KEAudioModule(numberOfSoundPlayers: 5)

struct SKGameSettings {
	var titleFont: String = "MarkerFelt-Thin"
	var defaultFont: String = "Helvetica Neue"
	var defaultFontSize: CGFloat = 30
	var gameTitle: String = "Game!"
	var textAnimationDelayInSeconds: Double = 0.2
	var testBool: Bool = false
	var testCounter: Int = 0
	var defaultFontColor: UIColor = UIColor.black
	var language: KELanguage = KELanguage.swedish
	
	var rightPadding: CGFloat?
	var leftPadding: CGFloat?
	var topPadding: CGFloat?
	var bottomPadding: CGFloat?
}

enum KELanguage {
	case japanese
	case swedish
	case english
}
