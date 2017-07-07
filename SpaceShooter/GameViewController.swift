//
//  GameViewController.swift
//  SpaceShooter
//
//  Created by Lennart Wisbar on 28.06.17.
//  Copyright © 2017 Lennart Wisbar. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    var scene = GameScene()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            
            scene = GameScene(size: view.bounds.size)
            view.presentScene(scene)
            
            view.ignoresSiblingOrder = true
            
//            view.showsFPS = true
//            view.showsNodeCount = true
//            view.showsPhysics = true
        }
    }

//    override var shouldAutorotate: Bool {
//        return true
//    }
//
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        if UIDevice.current.userInterfaceIdiom == .phone {
//            return .allButUpsideDown
//        } else {
//            return .all
//        }
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Release any cached data, images, etc that aren't in use.
//    }
//
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
}
