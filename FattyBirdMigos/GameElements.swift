//
//  GameElements.swift
//  FattyBirdMigos
//
//  Created by Crack on 4/23/18.
//  Copyright © 2018 nyu.edu. All rights reserved.
//

import SpriteKit

struct CollisionBitMask {
    static let birdCategory:UInt32 = 0x1 << 0
    static let pillarCategory:UInt32 = 0x1 << 1
    static let flowerCategory:UInt32 = 0x1 << 2
    static let groundCategory:UInt32 = 0x1 << 3
    static let migosCategory:UInt32 = 0x1 << 4
    static let tomatoCategory:UInt32 = 0x1 << 5
}

extension GameScene {
    
    func createBird() -> SKSpriteNode {
        //1
        let bird = SKSpriteNode(texture: SKTextureAtlas(named:"player").textureNamed("bird1"))
        bird.size = CGSize(width: 100, height: 75)
        bird.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
        //2
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.width / 4)
        bird.physicsBody?.linearDamping = 1.1
        bird.physicsBody?.restitution = 0
        //3
        bird.physicsBody?.categoryBitMask = CollisionBitMask.birdCategory
        bird.physicsBody?.collisionBitMask = CollisionBitMask.groundCategory
        bird.physicsBody?.contactTestBitMask = CollisionBitMask.pillarCategory | CollisionBitMask.flowerCategory | CollisionBitMask.groundCategory | CollisionBitMask.tomatoCategory
        //4
        bird.physicsBody?.affectedByGravity = false
        bird.physicsBody?.isDynamic = true
        
        return bird
    }
    
    func createMigos() -> SKSpriteNode {
        var arraySprites :[SKSpriteNode] = [SKSpriteNode]()
        let quavo = SKSpriteNode(imageNamed: "quavo")
        arraySprites.append(quavo)
        let offset = SKSpriteNode(imageNamed: "offset")
        arraySprites.append(offset)
        let takeoff = SKSpriteNode(imageNamed: "takeoff")
        arraySprites.append(takeoff)
        
        let migos = arraySprites[Int(arc4random_uniform(UInt32( arraySprites.count)))]
        
        migos.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.width / 4)
        migos.physicsBody?.linearDamping = 1.1
        migos.physicsBody?.restitution = 0
        migos.position = CGPoint(x: 20, y: self.frame.height / 2)
        migos.physicsBody?.categoryBitMask = CollisionBitMask.migosCategory
        migos.physicsBody?.collisionBitMask = CollisionBitMask.groundCategory 
        migos.physicsBody?.contactTestBitMask = CollisionBitMask.birdCategory
        migos.setScale(0.18)
        migos.physicsBody?.affectedByGravity = false
        migos.physicsBody?.isDynamic = true
        migos.physicsBody?.allowsRotation = false
        migos.physicsBody?.friction = 0.0
        
        self.addChild(migos)
        
        return migos
        
    }
    
    //1
    func createRestartBtn() {
        restartBtn = SKSpriteNode(imageNamed: "restart")
        restartBtn.size = CGSize(width:100, height:100)
        restartBtn.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        restartBtn.zPosition = 6
        restartBtn.setScale(0)
        self.addChild(restartBtn)
        restartBtn.run(SKAction.scale(to: 1.0, duration: 0.3))
    }
    //2
    func createPauseBtn() {
        pauseBtn = SKSpriteNode(imageNamed: "pause")
        pauseBtn.size = CGSize(width:40, height:40)
        pauseBtn.position = CGPoint(x: self.frame.width - 30, y: 30)
        pauseBtn.zPosition = 6
        self.addChild(pauseBtn)
    }
    //3
    func createScoreLabel() -> SKLabelNode {
        let scoreLbl = SKLabelNode()
        scoreLbl.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + self.frame.height / 2.6)
        scoreLbl.text = "\(score)"
        scoreLbl.zPosition = 5
        scoreLbl.fontSize = 50
        scoreLbl.fontName = "HelveticaNeue-Bold"
        
        let scoreBg = SKShapeNode()
        scoreBg.position = CGPoint(x: 0, y: 0)
        scoreBg.path = CGPath(roundedRect: CGRect(x: CGFloat(-50), y: CGFloat(-30), width: CGFloat(100), height: CGFloat(100)), cornerWidth: 50, cornerHeight: 50, transform: nil)
        let scoreBgColor = UIColor(red: CGFloat(0.0 / 255.0), green: CGFloat(0.0 / 255.0), blue: CGFloat(0.0 / 255.0), alpha: CGFloat(0.2))
        scoreBg.strokeColor = UIColor.clear
        scoreBg.fillColor = scoreBgColor
        scoreBg.zPosition = -1
        scoreLbl.addChild(scoreBg)
        return scoreLbl
    }
    //4
    func createHighscoreLabel() -> SKLabelNode {
        let highscoreLbl = SKLabelNode()
        highscoreLbl.position = CGPoint(x: self.frame.width - 80, y: self.frame.height - 22)
        if let highestScore = UserDefaults.standard.object(forKey: "highestScore"){
            highscoreLbl.text = "Highest Score: \(highestScore)"
        } else {
            highscoreLbl.text = "Highest Score: 0"
        }
        highscoreLbl.zPosition = 5
        highscoreLbl.fontSize = 15
        highscoreLbl.fontName = "Helvetica-Bold"
        return highscoreLbl
    }
    //5
    func createLogo() -> SKSpriteNode {
        logoImg = SKSpriteNode()
        logoImg = SKSpriteNode(imageNamed: "logo")
        logoImg.size = CGSize(width: 382.66, height: 382.66)
        logoImg.position = CGPoint(x:self.frame.midX, y:self.frame.midY + 100)
        logoImg.setScale(0.5)
        self.addChild(logoImg)
        logoImg.run(SKAction.scale(to: 1.0, duration: 0.3))
        
        return logoImg
    }
    //6
    func createTaptoplayLabel() -> SKSpriteNode {
        let selectMigosLbl = SKSpriteNode(imageNamed: "arcade")
        selectMigosLbl.position = CGPoint(x:self.frame.midX, y:self.frame.midY - 250)
        selectMigosLbl.size = CGSize(width: 300, height: 300)
        selectMigosLbl.zPosition = 5
        return selectMigosLbl
    }
    
    func createVegetable() -> SKNode {
        var arraySprites :[SKSpriteNode] = [SKSpriteNode]()
        let broccoli = SKSpriteNode(imageNamed: "broccoli")
        arraySprites.append(broccoli)
        let carrot = SKSpriteNode(imageNamed: "carrot")
        arraySprites.append(carrot)
        let chilli = SKSpriteNode(imageNamed: "chilli")
        arraySprites.append(chilli)
        let green_pepper = SKSpriteNode(imageNamed: "green_pepper")
        arraySprites.append(green_pepper)
        let mushroom = SKSpriteNode(imageNamed: "mushroom")
        arraySprites.append(mushroom)
        let peas = SKSpriteNode(imageNamed: "peas")
        arraySprites.append(peas)
        let red_pepper = SKSpriteNode(imageNamed: "red_pepper")
        arraySprites.append(red_pepper)
        let tomato = SKSpriteNode(imageNamed: "tomato")
        arraySprites.append(tomato)
        
        let flowerNode = arraySprites[Int(arc4random_uniform(UInt32( arraySprites.count)))]
        
        flowerNode.setScale(0.4)
        flowerNode.position = CGPoint(x: 0, y: 0)
        flowerNode.physicsBody = SKPhysicsBody(rectangleOf: flowerNode.size)
        flowerNode.physicsBody?.affectedByGravity = false
        flowerNode.physicsBody?.isDynamic = false
        flowerNode.physicsBody?.categoryBitMask = CollisionBitMask.flowerCategory
        if (flowerNode == tomato) {
            flowerNode.physicsBody?.categoryBitMask = CollisionBitMask.tomatoCategory
        }
        flowerNode.physicsBody?.collisionBitMask = 0
        flowerNode.physicsBody?.contactTestBitMask = CollisionBitMask.birdCategory
        flowerNode.color = SKColor.blue
        
        let randomPosition = random(min: 0, max: self.frame.height - flowerNode.frame.height)
        flowerNode.position.y = flowerNode.position.y + randomPosition

        flowerNode.run(moveAndRemoveFlower)
        
        return flowerNode
    }
    
    func createWalls() -> SKNode  {
        // 2
        var arraySprites :[SKSpriteNode] = [SKSpriteNode]()
        let Spoon = SKSpriteNode(imageNamed: "spoon")
        arraySprites.append(Spoon)
        let Knife = SKSpriteNode(imageNamed: "knife")
        arraySprites.append(Knife) 
        let Fork = SKSpriteNode(imageNamed: "fork")
        arraySprites.append(Fork)
        
        let Wall = arraySprites[Int(arc4random_uniform(UInt32( arraySprites.count)))]
        Wall.position = CGPoint(x: 0, y: 0)
        Wall.setScale(0.7)
        
        Wall.physicsBody = SKPhysicsBody(rectangleOf: Wall.size)
        Wall.physicsBody?.categoryBitMask = CollisionBitMask.pillarCategory
        Wall.physicsBody?.collisionBitMask = CollisionBitMask.birdCategory
        Wall.physicsBody?.contactTestBitMask = CollisionBitMask.birdCategory
        Wall.physicsBody?.isDynamic = false
        Wall.physicsBody?.affectedByGravity = false
        
        Wall.zPosition = 1
        // 3
        let randomPosition = random(min: 0, max: self.frame.height - Wall.frame.height)
        Wall.position.y = Wall.position.y + randomPosition
        
        Wall.run(moveAndRemove)
        
        return Wall
    }
    func random() -> CGFloat{
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    func random(min : CGFloat, max : CGFloat) -> CGFloat{
        return random() * (max - min) + min
    }
}


