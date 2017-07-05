//
//  GameOverScene.swift
//  SpaceShooter
//
//  Created by Lennart Wisbar on 04.07.17.
//  Copyright © 2017 Lennart Wisbar. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    override func didMove(to view: SKView) {
        let gameOverLabel = SKLabelNode(text: "Game Over")
        gameOverLabel.fontColor = .white
        gameOverLabel.fontSize = self.size.height / 17.5
        gameOverLabel.zPosition = 1
        gameOverLabel.position = self.size.center
        self.addChild(gameOverLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let newGameScene = GameScene(size: self.size)
        self.view?.presentScene(newGameScene)
    }
}
