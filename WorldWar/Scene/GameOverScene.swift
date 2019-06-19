//
//  GameOverScene.swift
//  WorldWar
//
//  Created by sinbad on 6/18/19.
//  Copyright © 2019 sinbad. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    
       let restartLabel = SKLabelNode(fontNamed: "LuckiestGuy-Regular.ttf")
      let highScoreLabel = SKLabelNode(fontNamed: "LuckiestGuy-Regular.ttf")
    override func didMove(to view: SKView) {
        
        let bg  = SKSpriteNode(imageNamed: "starBackground")
        bg.size = CGSize(width: frame.size.width, height: frame.size.height)
        bg.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        bg.zPosition = 0
        self.addChild(bg)
        
        let gameOverLabel = SKLabelNode(fontNamed: "LuckiestGuy-Regular")
        gameOverLabel.text = "Game Over"
        gameOverLabel.fontSize = 70
        gameOverLabel.fontColor = SKColor.white
        gameOverLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height*0.7)
        gameOverLabel.zPosition = 1
        addChild(gameOverLabel)
        
        let scoreLabel = SKLabelNode(fontNamed: "LuckiestGuy-Regular.ttf")
        scoreLabel.text = "Score: \(gameScore)"
        scoreLabel.fontSize = 50
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.55)
        scoreLabel.zPosition = 1
        addChild(scoreLabel)
        
        
        let defaults = UserDefaults()
        var highScoreNumber = defaults.integer(forKey: "highScoreSaved")
        
        if gameScore > highScoreNumber {
            highScoreNumber = gameScore
            defaults.set(highScoreNumber, forKey: "highScoreSaved")
        }
        
        highScoreLabel.text = "High Score: \(highScoreNumber)"
        highScoreLabel.fontSize = 50
        highScoreLabel.fontColor = SKColor.white
        highScoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.45)
        highScoreLabel.zPosition = 1
        addChild(highScoreLabel)
        
        
     
        restartLabel.text = "Restart"
        restartLabel.fontSize = 50
        restartLabel.fontColor = SKColor.white
        restartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.90)
        restartLabel.zPosition = 1
        addChild(restartLabel)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch : AnyObject in touches {
            let pointTouch = touch.location(in: self)
            if restartLabel.contains(pointTouch) {
                let sceneMoveTo = GameScene(size : self.size)
                sceneMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneMoveTo, transition: myTransition)
            }
            
        }
    }
   
}
