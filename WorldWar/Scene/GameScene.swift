//
//  GameScene.swift
//  WorldWar
//
//  Created by sinbad on 6/14/19.
//  Copyright © 2019 sinbad. All rights reserved.
//

import SpriteKit
class GameScene : SKScene, SKPhysicsContactDelegate {
    
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
    
    struct PhsicsCategories {
        static let None : UInt32 = 0 //
        static let Player : UInt32 = 0b1 // 1
        static let Bullet : UInt32 = 0b10 // 2
        static let Enemy  : UInt32 = 0b100 // 4
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
        
        self.physicsWorld.contactDelegate = self
        
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
        planeNode.physicsBody = SKPhysicsBody(rectangleOf: planeNode.size)
        planeNode.physicsBody!.affectedByGravity = false
        planeNode.physicsBody?.categoryBitMask = PhsicsCategories.Player
        planeNode.physicsBody?.collisionBitMask = PhsicsCategories.None
        planeNode.physicsBody?.contactTestBitMask = PhsicsCategories.Enemy
        addChild(planeNode)
    }
    
    func fireBullet(){
        let bullet = SKSpriteNode(imageNamed: "laserRed")
        bullet.position = planeNode.position
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody!.affectedByGravity = false
        bullet.physicsBody?.categoryBitMask = PhsicsCategories.Bullet
        bullet.physicsBody?.collisionBitMask = PhsicsCategories.None
        bullet.physicsBody?.contactTestBitMask = PhsicsCategories.Enemy
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
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody!.affectedByGravity = false
        enemy.physicsBody?.categoryBitMask = PhsicsCategories.Enemy
        enemy.physicsBody?.collisionBitMask = PhsicsCategories.None
        enemy.physicsBody?.contactTestBitMask = PhsicsCategories.Player | PhsicsCategories.Bullet
        addChild(enemy)
        
        let moveEnemy = SKAction.move(to: endPoint, duration: 1)
        let deleteEnemy = SKAction.removeFromParent()
        let enemySequence = SKAction.sequence([moveEnemy,deleteEnemy])
        enemy.run(enemySequence)
    }
    
    
    func startNewLevel(){
        let spawn = SKAction.run(spawnEnemy)
        let waitToSpawn = SKAction.wait(forDuration: 0.5)
        let spawnSequence = SKAction.sequence([spawn, waitToSpawn])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        self.run(spawnForever)
        
    }
    
    func spawnExplosion(spawnPostion: CGPoint){
        let explosion = SKSpriteNode(imageNamed: "explosion")
        explosion.position = spawnPostion
        explosion.zPosition = 3
        self.addChild(explosion)
        
        let scaleIn = SKAction.scale(to: 1, duration: 0.1)
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
        let delete = SKAction.removeFromParent()
        let seq = SKAction.sequence([scaleIn, fadeOut, delete])
        explosion.run(seq)
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
    
    func didBegin(_ contact: SKPhysicsContact) {
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.collisionBitMask {
            body1 = contact.bodyA
            body2 = contact.bodyB
        } else {
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        
        
        if body1.categoryBitMask == PhsicsCategories.Player && body2.categoryBitMask == PhsicsCategories.Enemy {
            // if the player has hit the enemy
            print("==player==Enemy")
            if   body1.node != nil {
                spawnExplosion(spawnPostion: body1.node!.position)
            }
            if body2.node != nil {
                spawnExplosion(spawnPostion: body2.node!.position)
            }
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            print("remove----player and enemy")
        }
        
        if body1.categoryBitMask == PhsicsCategories.Bullet && body2.categoryBitMask == PhsicsCategories.Enemy && (body2.node?.position.y)! < self.size.height {
            if body2.node != nil {
                spawnExplosion(spawnPostion: body2.node!.position)
            }
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            
            print("remove---- bullet and enemy")
        }
        
        
    }
}
