//
//  StartScene.swift
//  WorldWar
//
//  Created by sinbad on 6/14/19.
//  Copyright © 2019 sinbad. All rights reserved.
//

import SpriteKit
class StartScene : SKScene {
    
    let logo = SKSpriteNode(imageNamed: "player")
    let playButton = SKSpriteNode(imageNamed: "b_2")
    
    override func didMove(to view: SKView) {
        backgroundColor = .white
        addLogo()
        addPlayButton()
    }
    
    func addLogo(){
        logo.position = CGPoint(x: self.size.width / 2, y: self.size.height * 3/4)
        addChild(logo)
    }
    
    func addPlayButton(){
        playButton.size = CGSize(width: 200, height: 50)
        playButton.position = CGPoint(x: self.size.width / 2, y: self.size.height / 5)
        addChild(playButton)
    }
    
}
