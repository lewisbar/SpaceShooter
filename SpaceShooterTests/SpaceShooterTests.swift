//
//  SpaceShooterTests.swift
//  SpaceShooterTests
//
//  Created by Lennart Wisbar on 04.07.17.
//  Copyright © 2017 Lennart Wisbar. All rights reserved.
//

import XCTest
import SpriteKit
@testable import SpaceShooter

class SpaceShooterTests: XCTestCase {
    
//    override func setUp() {
//        super.setUp()
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//    
//    override func tearDown() {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//        super.tearDown()
//    }
    
    func test_setupNode_Spaceship() {
        let scene = GameScene()
        let node = SKSpriteNode(imageNamed: "Spaceship")
        scene.setupNode(node, name: "spaceship")
        
        let expectedCategoryBitMask: UInt32 = 0b1
        XCTAssertEqual(node.physicsBody?.categoryBitMask, expectedCategoryBitMask)
        let expectedContactTestBitMask: UInt32 = 0b100
        XCTAssertEqual(node.physicsBody?.contactTestBitMask, expectedContactTestBitMask)
        XCTAssertEqual(node.zPosition, 3)
        XCTAssertEqual(node.physicsBody?.isDynamic, false)
    }
    
    func test_setupNode_FireBall() {
        let scene = GameScene()
        let node = SKSpriteNode(imageNamed: "Sternschuss")
        scene.setupNode(node, name: "fireBall")
        
        let expectedCategoryBitMask: UInt32 = 0b10
        XCTAssertEqual(node.physicsBody?.categoryBitMask, expectedCategoryBitMask)
    }
    
    func test_setupNode_Enemy() {
        let scene = GameScene(size: CGSize(width: 250, height: 700))
        let node = SKSpriteNode(imageNamed: "Raumschiff")
        scene.setupNode(node, name: "enemy")
        
        let expectedCategoryBitMask: UInt32 = 0b100
        XCTAssertEqual(node.physicsBody?.categoryBitMask, expectedCategoryBitMask)
    }
    
    func test_categoryBitMaskForNodeWithName_Spaceship() {
        let scene = GameScene()
        let categoryBitMask = scene.categoryBitMask(forNodeWithName: "spaceship")
        let expectedCategoryBitMask: UInt32 = 0b1
        XCTAssertEqual(categoryBitMask, expectedCategoryBitMask)
    }
    
    func test_categoryBitMaskForNodeWithName_FireBall() {
        let scene = GameScene()
        let categoryBitMask = scene.categoryBitMask(forNodeWithName: "fireBall")
        let expectedCategoryBitMask: UInt32 = 0b10
        XCTAssertEqual(categoryBitMask, expectedCategoryBitMask)
    }
    
    func test_categoryBitMaskForNodeWithName_Enemy() {
        let scene = GameScene()
        let categoryBitMask = scene.categoryBitMask(forNodeWithName: "enemy")
        let expectedCategoryBitMask: UInt32 = 0b100
        XCTAssertEqual(categoryBitMask, expectedCategoryBitMask)
    }
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}
