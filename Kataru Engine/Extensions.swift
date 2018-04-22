//
//  Extensions.swift
//  Kataru Engine
//
//  Created by Kalle Takeuchi on 2018-04-08.
//  Copyright © 2018 Takemaki Studios. All rights reserved.
//

import SpriteKit

extension String {
	
	func sizeOfLabelNode(fontName: String, fontSize: CGFloat) -> CGSize {
		
		let label = SKLabelNode(fontNamed: fontName)
		label.fontSize = fontSize
		label.text = self
		
		return label.frame.size
		
	}
}
