//
//  GameScene.swift
//  SpaceShooter
//
//  Created by Lennart Wisbar on 28.06.17.
//  Copyright © 2017 Lennart Wisbar. All rights reserved.
//

import SpriteKit
import AVFoundation

class GameScene: SKScene {
    
    let background = SKSpriteNode(imageNamed: "BackgroundImage.jpg")
    let backgroundEffect = SKEmitterNode(fileNamed: "BackgroundEffect")
    let spaceship = SKSpriteNode(imageNamed: "Spaceship")
    var musicPlayer: AVAudioPlayer?
    var liveCount = 0
    var liveArray = [SKSpriteNode]()
    var timer1 = Timer()
    var timer2 = Timer()
    
    override func didMove(to view: SKView) {
        
        // Background
        background.anchorPoint = .zero
        background.position = .zero
        background.size = self.size
        background.zPosition = 1
        self.addChild(background)
        
        backgroundEffect?.position = self.size.center
        backgroundEffect?.zPosition = 2
        self.addChild(backgroundEffect!)
        
        // Spaceship
        spaceship.position = CGPoint(x: self.size.center.x, y: self.size.height * 0.09)
        spaceship.setScale(0.2)
        spaceship.zPosition = 3
        self.addChild(spaceship)
        
        // Pause Background and Label
        let pauseColor = SKColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        let pauseBackground = SKSpriteNode(color: pauseColor, size: self.size)
        pauseBackground.anchorPoint = .zero
        pauseBackground.zPosition = 30
        pauseBackground.name = "pauseBackground"
        self.addChild(pauseBackground)
        
        let pauseLabel = SKLabelNode(text: "Pause")
        pauseLabel.position = self.size.center
        pauseLabel.fontSize = self.size.height * 0.06
        pauseLabel.fontColor = SKColor.white
        pauseLabel.zPosition = 31
        pauseLabel.name = "pauseLabel"
        self.addChild(pauseLabel)
        
        isPaused = true

        // Music
        prepareMusic()
        
        // Lives
        addLives(3)
        
        // Shoot
        startSpaceshipFire()
    }
    
    @objc func addEnemy() {
        let enemy = SKSpriteNode(imageNamed: "Raumschiff")
        let enemyStartX = CGFloat(arc4random_uniform(UInt32(self.size.width - 2 * enemy.size.width))) + enemy.size.width
        let enemyStartY = self.size.height + enemy.size.height
        enemy.position = CGPoint(x: enemyStartX, y: enemyStartY)
        enemy.zPosition = 2
        enemy.zRotation = .pi   // Upside down
        self.addChild(enemy)
        
        // Action
        let moveDown = SKAction.moveTo(y: -enemy.size.height, duration: 3)
        let delete = SKAction.removeFromParent()
        enemy.run(SKAction.sequence([moveDown, delete]))
    }
    
    @objc func startSpaceshipFire() {
        let fireBall = SKSpriteNode(imageNamed: "Sternschuss")
        fireBall.position = spaceship.position
        fireBall.zPosition = spaceship.zPosition - 1
        self.addChild(fireBall)
        
        // Action
        let shoot = SKAction.moveTo(y: self.size.height + fireBall.size.height, duration: 1)
        let removeFireBall = SKAction.removeFromParent()
        let fireSequence = SKAction.sequence([shoot, removeFireBall])
        
        fireBall.run(fireSequence)
    }
    
    func addLives(_ liveCount: Int) {
        for index in 1...liveCount {
            let heart = SKSpriteNode(imageNamed: "Herz")
            heart.position = CGPoint(x: CGFloat(index) * heart.size.width, y: self.size.height - heart.size.height)
            heart.zPosition = 3
            heart.name = "heart\(index)"
            liveArray.append(heart)
            self.addChild(heart)
        }
    }
    
    func prepareMusic() {
        guard let musicURL = Bundle.main.url(forResource: "BackgroundMusic", withExtension: "mp3") else {
            print("Audio file not found")
            return
        }
        
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: musicURL)
        } catch {
            print("Music player can't be initialized")
        }
        musicPlayer?.numberOfLoops = 0
        musicPlayer?.prepareToPlay()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isPaused {
            isPaused = false
            let pauseBackground = childNode(withName: "pauseBackground")
            let pauseLabel = childNode(withName: "pauseLabel")
            
            pauseBackground?.removeFromParent()
            pauseLabel?.removeFromParent()
            musicPlayer?.play()
            
            timer1 = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(startSpaceshipFire), userInfo: nil, repeats: true)
            timer2 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(addEnemy), userInfo: nil, repeats: true)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchPosition = touch.location(in: self)
            spaceship.position.x = touchPosition.x
        }
    }
}
