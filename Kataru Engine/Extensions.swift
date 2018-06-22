//
//  Extensions.swift
//  Kataru Engine
//
//  Created by Kalle Takeuchi on 2018-04-08.
//  Copyright © 2018 Takemaki Studios. All rights reserved.
//

import SpriteKit

extension UITextView {
	
	/** Returns true if the text will cause the UITextbox to scroll **/
	func willScroll(withString st: String) -> Bool {
		
		let dummy = UITextView(frame: self.frame)
		
		dummy.font = self.font!
		dummy.text = st
		
		if dummy.contentSize.height > dummy.frame.size.height {
			return true
		} else {
			return false
		}
		
	}
	
}
