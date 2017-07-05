//
//  GameOverScene.swift
//  SpaceShooter
//
//  Created by Lennart Wisbar on 04.07.17.
//  Copyright © 2017 Lennart Wisbar. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    var score = 0
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "BackgroundImage.jpg")
        background.position = self.size.center
        self.addChild(background)
        
        let backgroundEffect = SKEmitterNode(fileNamed: "BackgroundEffect")!
        backgroundEffect.position = self.size.center
        backgroundEffect.zPosition = 1
        self.addChild(backgroundEffect)
        
        let gameOverLabel = SKLabelNode(text: "Game Over")
        gameOverLabel.fontColor = .white
        gameOverLabel.fontSize = self.size.height / 17.5
        gameOverLabel.zPosition = 1
        gameOverLabel.position = self.size.center
        self.addChild(gameOverLabel)
        
        let scoreLabel = SKLabelNode(text: "Score: \(score)")
        scoreLabel.fontColor = .white
        scoreLabel.fontSize = self.size.height / 25
        scoreLabel.zPosition = 1
        scoreLabel.position = CGPoint(x: self.size.width / 2, y: gameOverLabel.position.y - gameOverLabel.fontSize)
        self.addChild(scoreLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let newGameScene = GameScene(size: self.size)
        self.view?.presentScene(newGameScene)
    }
}
