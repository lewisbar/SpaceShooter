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
    }
    
    func stopTimers() {
        timer1.invalidate()
        timer2.invalidate()
    }
}

// MARK: Contact
extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        
        let bodyBitMasks = [contact.bodyA.categoryBitMask, contact.bodyB.categoryBitMask]
        
        if bodyBitMasks.contains(categoryBitMask(forNodeWithName: "fireBall")!),
            bodyBitMasks.contains(categoryBitMask(forNodeWithName: "enemy")!) {
            
            // Explode enemy and fireBall
            // The method is called once for every contact point. So we need to make sure both nodes still exist, in case an enemy is hit by a fire ball and the spaceship simultanously, which would cause a crash for the second call.
            guard let explodingNode1 = contact.bodyA.node as? SKSpriteNode,
                let explodingNode2 = contact.bodyB.node as? SKSpriteNode else { return }
            makeSpriteNodeExplode(explodingNode1)
            makeSpriteNodeExplode(explodingNode2)
            
            score += 1
        } else if bodyBitMasks.contains(categoryBitMask(forNodeWithName: "spaceship")!),
            bodyBitMasks.contains(categoryBitMask(forNodeWithName: "enemy")!) {
            
            // Explode enemy
            // The method is called once for every contact point, but all of the below should happen only once. Otherwise, the app would crash because the enemy would no longer exist. If that crash would be prevented, more than one heart would be removed at one crash.
            guard let explodingNode = (contact.bodyA.node?.name == "enemy") ? contact.bodyA.node : contact.bodyB.node else { return }
            makeSpriteNodeExplode(explodingNode as! SKSpriteNode)
            
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
