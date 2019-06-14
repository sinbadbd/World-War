//
//  GameScene.swift
//  WorldWar
//
//  Created by sinbad on 6/14/19.
//  Copyright © 2019 sinbad. All rights reserved.
//

import SpriteKit
class GameScene : SKScene {
    
    let gameBg = SKSpriteNode(imageNamed: "backgroundColor")
    let planeNode = SKSpriteNode(imageNamed: "player")
    
    var timer = Timer()
    
    
    override func didMove(to view: SKView) {
        
        gameBg.size = CGSize(width: view.frame.width, height: view.frame.height)
        gameBg.position = CGPoint(x: frame.midX, y: frame.midY)
        gameBg.zPosition = 0
        addChild(gameBg)
        
        
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(addSmallBall), userInfo: nil, repeats: true)
        
        addPlane()
        addSmallBall()
    }
    
    func addPlane(){
        planeNode.position = CGPoint(x: frame.midX, y: frame.minY + planeNode.size.height + 10)
        planeNode.zPosition = 1
        addChild(planeNode)
    }
    
   @objc func addSmallBall(){
    
        let randomX = arc4random_uniform(UInt32(self.size.width))
        let smallBall = SKSpriteNode(imageNamed: "meteorSmall")
        smallBall.position.y =   self.size.height
        smallBall.position.x = CGFloat(randomX)
        addChild(smallBall)
        
        let moveAction = SKAction.moveTo(y: 0, duration: 5)
        let deleteAction = SKAction.removeFromParent()
        let scaleAction = SKAction.scale(by: 0.5, duration: 1)
        smallBall.run(SKAction.sequence([moveAction,scaleAction,deleteAction]))
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if  let location = touch?.location(in: self) {
            planeNode.position.x = location.x
        }
    }
}
