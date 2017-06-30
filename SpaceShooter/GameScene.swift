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
//        if let musicURL = Bundle.main.url(forResource: "ExplosionSound", withExtension: "wav") {
//            print("Audio file found")
//            musicPlayer = try? AVAudioPlayer(contentsOf: musicURL)
//            musicPlayer?.numberOfLoops = 0
//            musicPlayer?.prepareToPlay()
//        } else {
//            print("Audio file not found")
//        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isPaused {
            isPaused = false
            let pauseBackground = childNode(withName: "pauseBackground")
            let pauseLabel = childNode(withName: "pauseLabel")
            
            pauseBackground?.removeFromParent()
            pauseLabel?.removeFromParent()
            musicPlayer?.play()
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchPosition = touch.location(in: self)
            spaceship.position.x = touchPosition.x
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
}