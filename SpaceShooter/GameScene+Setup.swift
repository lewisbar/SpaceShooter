//
//  GameScene+Setup.swift
//  SpaceShooter
//
//  Created by Lennart Wisbar on 03.07.17.
//  Copyright © 2017 Lennart Wisbar. All rights reserved.
//

import SpriteKit

extension GameScene {
    override func didMove(to view: SKView) {
        
        // Physics world
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        // Background
        setupNode(background, name: "background")
        background.size = self.size
        self.addChild(background)
        
        setupNode(backgroundEffect, name: "backgroundEffect")
        self.addChild(backgroundEffect)
        
        // Spaceship
        setupNode(spaceship, name: "spaceship")
        spaceship.setScale(0.2)
        self.addChild(spaceship)
        
        // Pause Background and Label
        let pauseColor = SKColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        let pauseBackground = SKSpriteNode(color: pauseColor, size: self.size)
        setupNode(pauseBackground, name: "pauseBackground")
        self.addChild(pauseBackground)
        
        let pauseLabel = SKLabelNode(text: "Tap to play")
        setupNode(pauseLabel, name: "pauseLabel")
        pauseLabel.fontSize = self.size.height * 0.06
        pauseLabel.fontColor = SKColor.white
        self.addChild(pauseLabel)
        
        isPaused = true
        
        // Music
        prepareMusic()
        
        // Lives
        addLives(3)
        
        // Shoot
        startSpaceshipFire()
        
        // Score Label
        setupNode(scoreLabel, name: "scoreLabel")
        scoreLabel.fontColor = .white
        scoreLabel.fontSize = self.size.height / 17.5
        self.addChild(scoreLabel)
        
        //spaceship.physicsBody?.categoryBitMask = 0b1
    }
}
