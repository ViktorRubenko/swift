//
//  GameScene.swift
//  project14
//
//  Created by Victor Rubenko on 09.03.2021.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var gameScore: SKLabelNode!
    var score = 0 {
        didSet {
            gameScore.text = "Score: \(score)"
        }
    }
    var slots = [WhackSlot]()
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "whackBackground")
        background.scale(to: CGSize(width: 2532, height: 1170))
        background.position = CGPoint(x: 1266, y: 585)
        background.zPosition = -1
        background.blendMode = .replace
        addChild(background)
        
        let gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.position = CGPoint(x: 70, y: 50)
        gameScore.text = "Score: 0"
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        gameScore.setScale(2.48)
        addChild(gameScore)
        
        setSlots()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    func setSlots() {
        for i in 0..<5 {
            createSlot(at: CGPoint(x: 250 + i * 420, y: 640))
        }
        for i in 0..<4 {
            createSlot(at: CGPoint(x: 450 + i * 420, y: 500))
        }
        for i in 0..<5 {
            createSlot(at: CGPoint(x: 250 + i * 420, y: 360))
        }
        for i in 0..<4 {
            createSlot(at: CGPoint(x: 450 + i * 420, y: 220))
        }
    }
    
    func createSlot(at position: CGPoint) {
        let slot = WhackSlot()
        slot.configure(position: position)
        slot.setScale(2)
        addChild(slot)
        slots.append(slot)
    }
}
