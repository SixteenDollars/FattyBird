//
//  GameScene.swift
//  FattyBirdMigos
//
//  Created by Crack on 4/23/18.
//  Copyright © 2018 nyu.edu. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var isGameStarted = Bool(false)
    
    var isDied = Bool(false)
    
    let coinSound = SKAction.playSoundFileNamed("CoinSound.mp3", waitForCompletion: false)
    var stirFryInstrumental: AVAudioPlayer?
    
    var score = Int(0)
    
    var scoreLbl = SKLabelNode()
    var highscoreLbl = SKLabelNode()
    var selectMigosLbl = SKSpriteNode()
    var restartBtn = SKSpriteNode()
    var pauseBtn = SKSpriteNode()
    var logoImg = SKSpriteNode()
    var quavo = SKSpriteNode()
    var takeoff = SKSpriteNode()
    var offset = SKSpriteNode()
    var quavobut = SKSpriteNode()
    var takeoffbut = SKSpriteNode()
    var offsetbut = SKSpriteNode()
    var Wall = SKNode()
    var WallTemp = SKNode()
    var flowerNode = SKNode()
    var migos = SKSpriteNode()
    
    var moveAndRemove = SKAction()
    var moveAndRemoveFlower = SKAction()
    var moveMigos = SKAction()
    var clock = Int(-1)
    
    var arrayAdlibs :[SKAction] = [SKAction]()
    let adlib1 = SKAction.playSoundFileNamed("adlib1.mp3", waitForCompletion: false)
    let adlib2 = SKAction.playSoundFileNamed("adlib2.mp3", waitForCompletion: false)
    let adlib3 = SKAction.playSoundFileNamed("adlib3.mp3", waitForCompletion: false)
    let adlib4 = SKAction.playSoundFileNamed("adlib4.mp3", waitForCompletion: false)
    let adlib5 = SKAction.playSoundFileNamed("adlib5.mp3", waitForCompletion: false)
    let adlib6 = SKAction.playSoundFileNamed("adlib6.mp3", waitForCompletion: false)
    let adlib7 = SKAction.playSoundFileNamed("adlib7.mp3", waitForCompletion: false)
    let adlib8 = SKAction.playSoundFileNamed("adlib8.mp3", waitForCompletion: false)
    
    //CREATE THE BIRD ATLAS FOR ANIMATION
    let birdAtlas = SKTextureAtlas(named:"player")
    var birdSprites = Array<Any>()
    var bird = SKSpriteNode()
    var repeatActionBird = SKAction()
    
    func createScene() {
        
        let path = Bundle.main.path(forResource: "Stir Fry.mp3", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            stirFryInstrumental = try AVAudioPlayer(contentsOf: url)
            stirFryInstrumental?.play()
            stirFryInstrumental?.numberOfLoops = -1
        } catch {
            // couldn't load file
        }
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.categoryBitMask = CollisionBitMask.groundCategory 
        self.physicsBody?.collisionBitMask = CollisionBitMask.birdCategory | CollisionBitMask.migosCategory
        self.physicsBody?.contactTestBitMask = CollisionBitMask.birdCategory
        self.physicsBody?.isDynamic = false
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.restitution = 0
        
        self.physicsWorld.contactDelegate = self
        
        for i in 0 ..< 2 {
            let background = SKSpriteNode(imageNamed: "bg")
            background.anchorPoint = CGPoint.init(x: 0, y: 0)
            background.position = CGPoint(x:CGFloat(i) * self.frame.width, y:0)
            background.name = "background"
            background.size = (self.view?.bounds.size)!
            self.addChild(background)
        }
        
        arrayAdlibs.append(adlib1)
        arrayAdlibs.append(adlib2)
        arrayAdlibs.append(adlib3)
        arrayAdlibs.append(adlib4)
        arrayAdlibs.append(adlib5)
        arrayAdlibs.append(adlib6)
        arrayAdlibs.append(adlib7)
        arrayAdlibs.append(adlib8)
        
        //SET UP THE BIRD SPRITES FOR ANIMATION
        birdSprites.append(birdAtlas.textureNamed("bird1"))
        birdSprites.append(birdAtlas.textureNamed("bird2"))
        birdSprites.append(birdAtlas.textureNamed("bird3"))
        birdSprites.append(birdAtlas.textureNamed("bird4"))
        
        self.bird = createBird()
        self.addChild(bird)
        
        //PREPARE TO ANIMATE THE BIRD AND REPEAT THE ANIMATION FOREVER
        let animateBird = SKAction.animate(with: self.birdSprites as! [SKTexture], timePerFrame: 0.1)
        self.repeatActionBird = SKAction.repeatForever(animateBird)
        
        scoreLbl = createScoreLabel()
        self.addChild(scoreLbl)
        
        highscoreLbl = createHighscoreLabel()
        self.addChild(highscoreLbl)
        
        quavo = SKSpriteNode()
        quavo = SKSpriteNode(imageNamed: "quavo")
        quavo.position = CGPoint(x:self.frame.midX, y:self.frame.midY - 100)
        quavo.size = CGSize(width: 160, height: 375)
        quavo.setScale(0.5)
        self.addChild(quavo)
        
        takeoff = SKSpriteNode()
        takeoff = SKSpriteNode(imageNamed: "takeoff")
        takeoff.position = CGPoint(x:self.frame.midX - 100, y:self.frame.midY - 100)
        takeoff.size = CGSize(width: 160, height: 375)
        takeoff.setScale(0.5)
        self.addChild(takeoff)
        
        offset = SKSpriteNode()
        offset = SKSpriteNode(imageNamed: "offset")
        offset.position = CGPoint(x:self.frame.midX + 100, y:self.frame.midY - 130)
        offset.size = CGSize(width: 160, height: 375)
        offset.setScale(0.5)
        self.addChild(offset)
        
        logoImg = createLogo()
        
        self.selectMigosLbl = createTaptoplayLabel()
        self.addChild(selectMigosLbl)
        
        let moveUp = SKAction.moveBy(x: 0, y: 10, duration: 1)
        let sequence = SKAction.sequence([moveUp, moveUp.reversed()])
        let sequence1 = SKAction.sequence([moveUp.reversed(), moveUp])
        selectMigosLbl.run(SKAction.repeatForever(sequence), withKey:  "moving")
        quavo.run(SKAction.repeatForever(sequence1), withKey:  "moving")
        takeoff.run(SKAction.repeatForever(sequence), withKey:  "moving")
        offset.run(SKAction.repeatForever(sequence), withKey:  "moving")
        logoImg.run(SKAction.repeatForever(sequence), withKey:  "moving")
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        if firstBody.categoryBitMask == CollisionBitMask.birdCategory && secondBody.categoryBitMask == CollisionBitMask.pillarCategory || firstBody.categoryBitMask == CollisionBitMask.pillarCategory && secondBody.categoryBitMask == CollisionBitMask.birdCategory {
            
            if (firstBody.categoryBitMask == CollisionBitMask.pillarCategory) {
                firstBody.collisionBitMask = 0
            }
            if (secondBody.categoryBitMask == CollisionBitMask.pillarCategory) {
                secondBody.collisionBitMask = 0
            }
            migos.physicsBody?.applyImpulse(CGVector(dx: self.frame.width / 24, dy: 0))
            let fadeAction = SKAction.fadeAlpha(to: 0, duration: 0.5)
            firstBody.node?.run(fadeAction)
            let adlib = arrayAdlibs[Int(arc4random_uniform(UInt32( arrayAdlibs.count)))]
            run(adlib)
        }
            
        else if firstBody.categoryBitMask == CollisionBitMask.birdCategory && secondBody.categoryBitMask == CollisionBitMask.groundCategory || firstBody.categoryBitMask == CollisionBitMask.groundCategory && secondBody.categoryBitMask == CollisionBitMask.birdCategory {
            
            migos.physicsBody?.applyImpulse(CGVector(dx: self.frame.width / 24, dy: 0))
            migos.position = CGPoint(x: migos.position.x, y: bird.position.y)
            let adlib = arrayAdlibs[Int(arc4random_uniform(UInt32( arrayAdlibs.count)))]
            run(adlib)
            
        }
            
        else if firstBody.categoryBitMask == CollisionBitMask.birdCategory && secondBody.categoryBitMask == CollisionBitMask.migosCategory {
            enumerateChildNodes(withName: "Wall", using: ({
                (node, error) in
                node.speed = 0
                self.removeAllActions()
            }))
            if isDied == false {
                isDied = true
                createRestartBtn()
                pauseBtn.removeFromParent()
                self.bird.removeFromParent()
                self.flowerNode.removeFromParent()
            }
        } else if firstBody.categoryBitMask == CollisionBitMask.migosCategory && secondBody.categoryBitMask == CollisionBitMask.birdCategory {
            enumerateChildNodes(withName: "Wall", using: ({
                (node, error) in
                node.speed = 0
                self.removeAllActions()
            }))
            if isDied == false {
                isDied = true
                createRestartBtn()
                pauseBtn.removeFromParent()
                self.bird.removeFromParent()
                self.flowerNode.removeFromParent()
            }
        } else if firstBody.categoryBitMask == CollisionBitMask.birdCategory && secondBody.categoryBitMask == CollisionBitMask.flowerCategory {
            run(coinSound)
            score += 1
            scoreLbl.text = "\(score)"
            secondBody.node?.removeFromParent()
            if (flowerNode.physicsBody?.categoryBitMask != CollisionBitMask.tomatoCategory) {
                if (bird.size.width <= 300 && bird.size.height <= 225) {
                    bird.size = CGSize(width: bird.size.width + 2, height: bird.size.height + 2);
                }
            }
            else if (flowerNode.physicsBody?.categoryBitMask == CollisionBitMask.tomatoCategory) {
                if (bird.size.width > 100 && bird.size.height > 75) {
                    bird.size = CGSize(width: bird.size.width - 2, height: bird.size.height - 2);
                }
            }
        } else if firstBody.categoryBitMask == CollisionBitMask.flowerCategory && secondBody.categoryBitMask == CollisionBitMask.birdCategory {
            run(coinSound)
            score += 1
            scoreLbl.text = "\(score)"
            firstBody.node?.removeFromParent()
            if (flowerNode.physicsBody?.categoryBitMask != CollisionBitMask.tomatoCategory) {
                if (bird.size.width <= 300 && bird.size.height <= 225) {
                    bird.size = CGSize(width: bird.size.width + 2, height: bird.size.height + 2);
                }
            }
            else if (flowerNode.physicsBody?.categoryBitMask == CollisionBitMask.tomatoCategory) {
                if (bird.size.width > 100 && bird.size.height > 75) {
                    bird.size = CGSize(width: bird.size.width - 2, height: bird.size.height - 2);
                }
            }
        }
    }
    
    func restartScene(){
        self.removeAllChildren()
        self.removeAllActions()
        isDied = false
        isGameStarted = false
        score = 0
        createScene()
    }
    
    override func didMove(to view: SKView) {
        createScene()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if isGameStarted == false {
            //1
            isGameStarted =  true
            self.migos = createMigos()
            bird.physicsBody?.affectedByGravity = true
            bird.position = CGPoint(x: self.frame.midX + (self.frame.width / 4), y: self.frame.midY)
            migos.physicsBody?.affectedByGravity = true
            createPauseBtn()
            //2
            logoImg.run (
                SKAction.scale(to: 0.5, duration: 0.3), completion: {
                    self.logoImg.removeFromParent()
            }
            )
            selectMigosLbl.removeFromParent()
            quavo.removeFromParent()
            takeoff.removeFromParent()
            offset.removeFromParent()
            quavobut.removeFromParent()
            takeoffbut.removeFromParent()
            offsetbut.removeFromParent()
            //3
            self.bird.run(repeatActionBird)
            
            //TODO: add pillars here
            //1
            let spawn = SKAction.run({
                () in
                self.Wall = self.createWalls()
                self.addChild(self.Wall)
                self.flowerNode = self.createVegetable()
                self.addChild(self.flowerNode)
            })
            //2
            let delay = SKAction.wait(forDuration: 1)
            let SpawnDelay = SKAction.sequence([spawn, delay])
            let spawnDelayForever = SKAction.repeatForever(SpawnDelay)
            self.run(spawnDelayForever)
            //3
            let movePillars = SKAction.moveBy(x: self.frame.width + Wall.frame.width, y: 0, duration: TimeInterval(0.003 * (self.frame.width + Wall.frame.width)))
            let moveFlower = SKAction.moveBy(x: self.frame.width + flowerNode.frame.width, y: 0, duration: TimeInterval(0.004 * (self.frame.width + flowerNode.frame.width)))
            let removePillars = SKAction.removeFromParent()
            moveAndRemove = SKAction.sequence([movePillars, removePillars])
            moveAndRemoveFlower = SKAction.sequence([moveFlower, removePillars])
            
            bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 40))
            
            migos.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            migos.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 40))
        }
        else {
            //4
            if isDied == false {
                bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 40))
                migos.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                migos.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 40))
            }
        }
        
        for touch in touches {
            let location = touch.location(in: self)
            //1
            if isDied == true {
                if restartBtn.contains(location) {
                    if UserDefaults.standard.object(forKey: "highestScore") != nil {
                        let hscore = UserDefaults.standard.integer(forKey: "highestScore")
                        if hscore < Int(scoreLbl.text!)!{
                            UserDefaults.standard.set(scoreLbl.text, forKey: "highestScore")
                        }
                    } else {
                        UserDefaults.standard.set(0, forKey: "highestScore")
                    }
                    restartScene()
                }
            } else {
                //2
                if pauseBtn.contains(location) {
                    if self.isPaused == false {
                        self.isPaused = true
                        pauseBtn.texture = SKTexture(imageNamed: "play")
                    } else {
                        self.isPaused = false
                        pauseBtn.texture = SKTexture(imageNamed: "pause")
                    }
                }
            }
        }
    }
    
    var lastUpdateTime: TimeInterval = 0
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if isGameStarted == true {
            if isDied == false {
                enumerateChildNodes(withName: "background", using: ({
                    (node, error) in
                    let bg = node as! SKSpriteNode
                    bg.position = CGPoint(x: bg.position.x - 2, y: bg.position.y)
                    if bg.position.x <= -bg.size.width {
                        bg.position = CGPoint(x:bg.position.x + bg.size.width * 2, y:bg.position.y)
                    }
                }))
            }
        }
    }
}
