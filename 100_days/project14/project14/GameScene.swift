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
    var popupTime = 0.85
    var gameOver: SKSpriteNode!
    var numRounds = 0
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "whackBackground")
        background.scale(to: CGSize(width: 2532, height: 1170))
        background.position = CGPoint(x: 1266, y: 585)
        background.zPosition = -1
        background.blendMode = .replace
        addChild(background)
        
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.position = CGPoint(x: 70, y: 50)
        gameScore.text = "Score: 0"
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        gameScore.setScale(2.48)
        addChild(gameScore)
        
        setSlots()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            [weak self] in
            self?.createEnemy()
        })
    }

    func createEnemy() {
        popupTime *= 0.95

        if numRounds >= 5 {
            for slot in slots {
                slot.hide()
            }
            
            gameOver = SKSpriteNode()
            gameOver.zPosition = 1
            gameOver.name = "gameOver"
            
            let gameOverScore = SKLabelNode()
            gameOverScore.text = "Your score is \(score)"
            gameOverScore.horizontalAlignmentMode = .center
            gameOverScore.fontName = "Chalkduster"
            gameOverScore.fontSize = 80
            gameOverScore.zPosition = 1
            let background = SKSpriteNode(color: .black, size: gameOverScore.frame.size)
            background.position = CGPoint(x: 0, y: 30)
            gameOverScore.addChild(background)
            gameOverScore.position = CGPoint(x: 1266, y: 400)
            gameOver.addChild(gameOverScore)
            
            let gameOverImage = SKSpriteNode(imageNamed: "gameOver")
            gameOverImage.position = CGPoint(x: 1266, y: 585)
            gameOverImage.zPosition = 1
            gameOver.addChild(gameOverImage)
            
            addChild(gameOver)
            
            gameOver.run(SKAction.playSoundFileNamed("gameover.caf", waitForCompletion: false))
            return
        }
        
        slots.shuffle()
        slots[0].show(hideTime: popupTime)
        
        if Int.random(in: 0...12) > 4 { slots[1].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 8 { slots[2].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 10 { slots[3].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 11 { slots[4].show(hideTime: popupTime) }
        
        let minDelay = popupTime / 2.0
        let maxDelay = popupTime * 2
        let delay = Double.random(in: minDelay...maxDelay)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            [weak self] in
            self?.createEnemy()
        })
        
        numRounds += 1
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        for node in tappedNodes {
            if let whackSlot = node.parent?.parent as? WhackSlot {
                if !whackSlot.isVisible { return }
                if whackSlot.isHit { continue }
                if node.name == "charFriend" {
                    whackSlot.hit()
                    if let particles = SKEmitterNode(fileNamed: "mud.sks") {
                        particles.position = whackSlot.position
                        addChild(particles)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            particles.removeFromParent()
                        }
                    }
                    score -= 5
                    
                    run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion: false))
                } else if node.name == "charEnemy" {
                    whackSlot.hit()
                    if let particles = SKEmitterNode(fileNamed: "smoke.sks") {
                        particles.position = whackSlot.position
                        addChild(particles)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            particles.removeFromParent()
                        }
                    }
                    score += 5
                    
                    run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
                }
            }
            if node.name == "gameOver" {
                self.removeChildren(in: [gameOver])
                score = 0
                numRounds = 0
                createEnemy()
            }
        }
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
