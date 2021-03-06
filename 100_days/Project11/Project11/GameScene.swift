//
//  GameScene.swift
//  Project11
//
//  Created by Victor Rubenko on 04.03.2021.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var scoreLabel: SKLabelNode!
    var editLabel: SKLabelNode!
    var ballsLabel: SKLabelNode!
    var newGameLabel: SKLabelNode!
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var editingMode: Bool = false {
        didSet {
            editLabel.text = editingMode ? "Done" : "Edit"
        }
    }
    
    var ballsLeft = 5 {
        didSet {
            ballsLabel.text = "Balls: \(ballsLeft)"
        }
    }
    
    let ballImages = ["ballBlue", "ballRed", "ballGreen", "ballPurple", "ballGrey", "ballCyan", "ballYellow"]
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 2400, y: 1050)
        scoreLabel.setScale(2.48)
        addChild(scoreLabel)
        
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.horizontalAlignmentMode = .left
        editLabel.position = CGPoint(x: 132, y: 950)
        editLabel.setScale(2.48)
        addChild(editLabel)
        
        newGameLabel = SKLabelNode(fontNamed: "Chalkduster")
        newGameLabel.text = "New Game"
        newGameLabel.horizontalAlignmentMode = .left
        newGameLabel.position = CGPoint(x: 132, y: 1050)
        newGameLabel.setScale(2.48)
        addChild(newGameLabel)
        
        ballsLabel = SKLabelNode(fontNamed: "Chalkduster")
        ballsLabel.text = "Balls: 5"
        ballsLabel.horizontalAlignmentMode = .right
        ballsLabel.position = CGPoint(x: 2400, y: 950)
        ballsLabel.setScale(2.48)
        addChild(ballsLabel)
        
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        background.setScale(2.48)
        background.blendMode = .replace
        background.zPosition = -1
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        addChild(background)
        
        addBouncer(at: CGPoint(x: 0, y: 0))
        addBouncer(at: CGPoint(x: 633, y: 0))
        addBouncer(at: CGPoint(x: 1266, y: 0))
        addBouncer(at: CGPoint(x: 1899, y: 0))
        addBouncer(at: CGPoint(x: 2532, y: 0))
        
        makeSlot(at: CGPoint(x: 316, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 949, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 1582, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 2215, y: -0), isGood: false)
    }
    
    func addBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.setScale(2.48)
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }
    
    func makeSlot(at position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        slotBase.setScale(2.48)
        slotBase.position = position
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.frame.size)
        slotBase.physicsBody?.isDynamic = false
        
        slotGlow.setScale(2.48)
        slotGlow.position = position
        let spin = SKAction.rotate(byAngle: .pi, duration: 3.5)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
        
        addChild(slotBase)
        addChild(slotGlow)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let objects = nodes(at: location)
            if objects.contains(newGameLabel) {
                score = 0
                ballsLeft = 5
                removeObstacles()
                return
            }
            if objects.contains(editLabel) {
                editingMode.toggle()
            } else {
                if editingMode {
                    let obstacles = nodes(at: location).filter( { $0.name == "obstacle" } )
                    if obstacles.count > 0 {
                        destroy(ball: obstacles[0], particles: false)
                        return
                    }
                    let size = CGSize(width: Int.random(in: 50...100), height: 16)
                    let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1.0), size: size)
                    box.setScale(2.48)
                    box.zRotation = CGFloat.random(in: 0...3)
                    box.position = location
                    box.physicsBody = SKPhysicsBody(rectangleOf: size)
                    box.physicsBody?.isDynamic = false
                    box.name = "obstacle"
                    addChild(box)
                } else {
                    if ballsLeft <= 0 {
                        return
                    }
                    let ball = SKSpriteNode(imageNamed: ballImages.randomElement()!)
                    ball.name = "ball"
                    ball.setScale(2.48)
                    ball.position = CGPoint(x: location.x, y: 1150)
                    ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
                    ball.physicsBody?.restitution = 0.7
                    ball.physicsBody?.contactTestBitMask = ball.physicsBody!.collisionBitMask
                    
                    ballsLeft -= 1
                    
                    addChild(ball)
                }
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name == "ball" {
            collisionBetween(ball: nodeA, object: nodeB)
            if nodeB.name == "obstacle" {
                nodeB.removeFromParent()
            }
        } else if nodeB.name == "ball" {
            collisionBetween(ball: nodeB, object: nodeA)
            if nodeA.name == "obstacle" {
                nodeA.removeFromParent()
            }
        }
    }
    
    func collisionBetween(ball: SKNode, object: SKNode) {
        if object.name == "good" {
            destroy(ball: ball)
            score += 1
            ballsLeft += 1
        } else if object.name == "bad" {
            destroy(ball: ball)
            score -= 1
        }
    }
    
    func destroy(ball: SKNode, particles: Bool = true) {
        if particles {
            if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
                fireParticles.position = ball.position
                addChild(fireParticles)
            }
        }
        ball.removeFromParent()
    }
    
    func removeObstacles() {
        for object in self.children {
            if let name = object.name {
                if name == "obstacle" {
                    object.removeFromParent()
                }
            }
        }
    }
    
}
