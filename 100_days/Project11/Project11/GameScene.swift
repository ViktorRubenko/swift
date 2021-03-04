//
//  GameScene.swift
//  Project11
//
//  Created by Victor Rubenko on 04.03.2021.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 0, y: 0)
        background.blendMode = .replace
        background.zPosition = -1
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        addChild(background)
        
        addBouncer(at: CGPoint(x: 0, y: 0))
        addBouncer(at: CGPoint(x: 230, y:0))
        addBouncer(at: CGPoint(x: -230, y:0))
        addBouncer(at: CGPoint(x: 460, y:0))
        addBouncer(at: CGPoint(x: -460, y: 0))
    }
    
    func addBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let ball = SKSpriteNode(imageNamed: "ballRed")
            ball.position = location
            ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
            ball.physicsBody?.restitution = 0.4
            addChild(ball)
        }
    }
    
}
