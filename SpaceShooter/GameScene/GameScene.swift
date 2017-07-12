//
//  GameScene.swift
//  SpaceShooter
//
//  Created by Lennart Wisbar on 28.06.17.
//  Copyright © 2017 Lennart Wisbar. All rights reserved.
//

import SpriteKit
import AVFoundation

// MARK: - Properties
class GameScene: SKScene {
    // Nodes
    let background = SKSpriteNode(imageNamed: "BackgroundImage")
    let background2 = SKSpriteNode(imageNamed: "BackgroundImage")
    let backgroundEffect = SKEmitterNode(fileNamed: "BackgroundEffect")!
    let spaceship = SKSpriteNode(imageNamed: "Spaceship")
    
    // Sound
    var musicPlayer: AVAudioPlayer?
    
    // Lives
    var liveCount = 0
    var liveArray = [SKSpriteNode]()
    
    // Timers
    var timer1 = Timer()
    var timer2 = Timer()
    var whirlTimer = Timer()
    
    // Score
    var score = 0 {
        didSet {
            scoreLabel.text = "\(score)"
        }
    }
    var scoreLabel = SKLabelNode()
    
    override var isPaused: Bool {
        didSet {
            if isPaused, oldValue == false {
                stopTimers()
            } else if !isPaused, oldValue == true {
                startTimers()
            }
        }
    }
    
    var spaceshipIsVulnerable = true
}

// MARK: - Touches
extension GameScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isPaused {
            isPaused = false
            let pauseBackground = childNode(withName: "pauseBackground")
            let pauseLabel = childNode(withName: "pauseLabel")
            
            pauseBackground?.removeFromParent()
            pauseLabel?.removeFromParent()
            musicPlayer?.play()
            
            // startTimers()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchPosition = touch.location(in: self)
            spaceship.position = CGPoint(x: touchPosition.x, y: touchPosition.y + self.size.height * 0.07)
        }
    }
    
    func startTimers() {
        timer1 = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(shootFireBall), userInfo: nil, repeats: true)
        timer2 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(addEnemy), userInfo: nil, repeats: true)
        whirlTimer = Timer.scheduledTimer(timeInterval: 5.6, target: self, selector: #selector(addWhirl), userInfo: nil, repeats: true)
    }
    
    func stopTimers() {
        timer1.invalidate()
        timer2.invalidate()
        whirlTimer.invalidate()
    }
}

// MARK: - Contact
extension GameScene: SKPhysicsContactDelegate {
    fileprivate func hitWhirl(_ whirl: Whirl) {
        whirl.health -= 1
        if whirl.health > 0 {
            makeSpriteNodeFlash(whirl)
            if whirl.shape == Whirl.Shape.folded {
                whirl.unfold()
            }
        } else {
            makeSpriteNodeExplode(whirl)
            score += 5
        }
    }
    
    fileprivate func hitSpaceship() {
        // Substract life
        liveArray.popLast()?.removeFromParent()
        
        if liveArray.isEmpty {
            gameOver()
        } else {
            makeSpriteNodeFlash(spaceship)
            // TODO: Spaceship should be invulnerable while flashing
            for heart in liveArray {
                makeSpriteNodeFlash(heart)
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if contact.isContactOf("fireBall", "enemy") {
        
            // Explode enemy and fireBall
            guard let explodingNode1 = contact.bodyA.node as? SKSpriteNode,
                let explodingNode2 = contact.bodyB.node as? SKSpriteNode else { return }
            makeSpriteNodeExplode(explodingNode1)
            makeSpriteNodeExplode(explodingNode2)
            
            score += 1
        } else if contact.isContactOf("spaceship", "enemy") {
            
            // Explode enemy
            guard let explodingNode = (contact.bodyA.node?.name == "enemy") ? contact.bodyA.node : contact.bodyB.node else { return }
            makeSpriteNodeExplode(explodingNode as! SKSpriteNode)
            
            hitSpaceship()
        } else if contact.isContactOf("fireBall", "whirl") {
            guard let fireBall = (contact.bodyA.node?.name == "fireBall") ? contact.bodyA.node : contact.bodyB.node,
            let whirlNode = (contact.bodyA.node?.name == "whirl") ? contact.bodyA.node : contact.bodyB.node
                else { return }
            let whirl = whirlNode as! Whirl
            
            makeSpriteNodeExplode(fireBall as! SKSpriteNode)
            hitWhirl(whirl)
        } else if contact.isContactOf("spaceship", "whirl") {
            guard spaceshipIsVulnerable,
                let _ = (contact.bodyA.node?.name == "spaceship") ? contact.bodyA.node : contact.bodyB.node,
                let whirlNode = (contact.bodyA.node?.name == "whirl") ? contact.bodyA.node : contact.bodyB.node
                else { return }
            let whirl = whirlNode as! Whirl
            print("\n\nSpaceship hits whirl\n\n")
            hitWhirl(whirl)
            hitSpaceship()
            spaceshipIsVulnerable = false
        }
    }
    // TODO: Make spaceship invulnerable while flashing?
    func didEnd(_ contact: SKPhysicsContact) {
        if contact.isContactOf("spaceship", "whirl") {
            if let bodies = spaceship.physicsBody?.allContactedBodies() {
                for body in bodies {
                    if body.node?.name == "whirl" {
                        return
                    }
                }
            }
            spaceshipIsVulnerable = true
        }
    }
    
    func gameOver() {
        timer1.invalidate()
        timer2.invalidate()
        musicPlayer?.stop()
        
        makeSpriteNodeExplode(spaceship) {
            let gameOverScene = GameOverScene(size: self.size)
            gameOverScene.score = self.score
            let transition = SKTransition.crossFade(withDuration: 0.5)
            self.view?.presentScene(gameOverScene, transition: transition)
        }
    }
    
    func makeSpriteNodeExplode(_ node: SKSpriteNode, completion: @escaping ()->() = {}) {
        self.run(SKAction.playSoundFileNamed("ExplosionSound.wav", waitForCompletion: false))
        let explosion = SKEmitterNode(fileNamed: "Explosion")!
        setupNode(explosion, name: "explosion")
        explosion.position = node.position
        explosion.particleScale = node.size.width / 200
        explosion.setScale(node.size.width / 25)
        self.addChild(explosion)
        
        node.removeFromParent()
        self.run(SKAction.wait(forDuration: 1)) {
            explosion.removeFromParent()
            completion()
        }
    }
    
    func makeSpriteNodeFlash(_ node: SKSpriteNode) {
        node.run(SKAction.repeat(SKAction.sequence([SKAction.fadeAlpha(to: 0.1, duration: 0.1), SKAction.fadeAlpha(to: 1, duration: 0.1)]), count: 10))
    }
}

extension SKPhysicsContact {
    func isContactOf(_ node1: String, _ node2: String) -> Bool {
        let bodyBitMasks = [bodyA.categoryBitMask, bodyB.categoryBitMask]
        
        return bodyBitMasks.contains(GameScene.categoryBitMask(forNodeWithName: node1)!) && bodyBitMasks.contains(GameScene.categoryBitMask(forNodeWithName: node2)!)
    }
}
