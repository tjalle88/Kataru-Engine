//
//  KEDialogStyle.swift
//  Kataru Engine
//
//  Created by Kalle Takeuchi on 2018-02-26.
//  Copyright © 2018 Takemaki Studios. All rights reserved.
//

import Foundation

enum KEDialogStyle {
	
	///Box with game color scheme appearing at the bottom of the screen
	case standard
	///Invisible box at the bottom of the screen
	case frameless
	///Box with game color scheme appearing in the middle of the screen.
	case standardMiddle
	///Box with game color scheme appearing at the top of the screen
	case standardTop
	///Invisible box with game color scheme appearing in the middle of the screen.
	case framelessMiddle
	///Invisible box with game color scheme appearing at the top of the screen
	case framelessTop
	
}

enum KEDialogEffect {
	
	case none
	case shake
	
}
