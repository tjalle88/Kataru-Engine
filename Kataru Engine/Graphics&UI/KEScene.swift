//
//  KEScene.swift
//  Kataru Engine
//
//  Created by Kalle Takeuchi on 2018-02-26.
//  Copyright © 2018 Takemaki Studios. All rights reserved.
//

import SpriteKit

class KEScene: SKScene {
	
	//The dictionary of dialog characters will be built upon initialization
    var dialogCharacters: [String: KEDialogCharacter]
	
    func ShowDialog(character: String, expression: String, style: KEDialogStyle, effect: KEDialogEffect, dialog: String) {
        
        let lblDialogText = SKLabelNode()
        lblDialogText.fontName = dialogCharacters["default"]!.fontStyle.fontName
        lblDialogText.fontSize = dialogCharacters["default"]!.fontStyle.pointSize
        
        lblDialogText.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        lblDialogText.text = dialog
        addChild(lblDialogText)
        
    }
    
    override init(size: CGSize) {
        
        dialogCharacters = [String : KEDialogCharacter]()
        
        //        Initiates the default dialog character, which is basically only plain text with no portrait.
        dialogCharacters["default"] = KEDialogCharacter()
        
        super.init(size: size)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
