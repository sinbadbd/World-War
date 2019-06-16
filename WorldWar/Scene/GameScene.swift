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
    
    let bottomBG = SKSpriteNode(imageNamed: "starBackground")
    var timer = Timer()
    
    let bulletSound = SKAction.playSoundFileNamed("bullet.aiff", waitForCompletion: false)
    
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min : CGFloat, max: CGFloat) -> CGFloat { // random number generate with max in min
        return random() * (max - min) + min
    }
    
    
    var gameArea : CGRect
    
    override init(size: CGSize) {
        
        let maxAspectRatio : CGFloat = 16.0/9.0
        let playableWidth = size.height / maxAspectRatio
        
        let margin = (size.width - playableWidth) / 2
        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    
    override func didMove(to view: SKView) {
        
        gameBg.size = CGSize(width: view.frame.width, height: view.frame.height)
        gameBg.position = CGPoint(x: frame.midX, y: frame.midY)
        gameBg.zPosition = 0
        addChild(gameBg)
        
        
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(addSmallBall), userInfo: nil, repeats: true)
        
        addPlane()
        addSmallBall()
        
        startNewLevel()
    }
    
    func addPlane(){
        planeNode.position = CGPoint(x: frame.midX, y: frame.minY + planeNode.size.height + 10)
        planeNode.zPosition = 1
        addChild(planeNode)
    }
    
    func fireBullet(){
        let bullet = SKSpriteNode(imageNamed: "laserRed")
        bullet.position = planeNode.position
        //  bullet.zPosition = -1
        addChild(bullet)
        
        let moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 1)
        let deleteBullet = SKAction.removeFromParent()
        let bulletSequence = SKAction.sequence([bulletSound,moveBullet,deleteBullet])
        bullet.run(bulletSequence)
    }
    
    
    func spawnEnemy(){
        let randomXStart = random(min: gameArea.minX, max: gameArea.maxX)
        print(randomXStart)
        let randomXEnd = random(min: gameArea.minX, max: gameArea.maxX)
        
        let startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.2)
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.2)
        
        let enemy = SKSpriteNode(imageNamed: "enemyUFO")
        enemy.position = startPoint
        enemy.zPosition = 2
        addChild(enemy)
        
        let moveEnemy = SKAction.move(to: endPoint, duration: 1)
        let deleteEnemy = SKAction.removeFromParent()
        let enemySequence = SKAction.sequence([moveEnemy,deleteEnemy])
        enemy.run(enemySequence)
    }
    
    
    func startNewLevel(){
        let spawn = SKAction.run(spawnEnemy)
        let waitToSpawn = SKAction.wait(forDuration: 5)
        let spawnSequence = SKAction.sequence([spawn, waitToSpawn])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        self.run(spawnForever)
        
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        fireBullet()
     //   spawnEnemy()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if  let location = touch?.location(in: self) {
            planeNode.position.x = location.x
            
            if planeNode.position.x > gameArea.maxX - planeNode.size.width/2  {
                planeNode.position.x = gameArea.maxX - planeNode.size.width/2
            }
            if planeNode.position.x < gameArea.minX + planeNode.size.width/2 {
                planeNode.position.x = gameArea.minX + planeNode.size.width/2
            }
        }
    }
}
