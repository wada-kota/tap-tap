//
//  GameScene.swift
//  tap tap
//
//  Created by 和田昂太 on 2025/01/18.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var mainCharaNode: SKSpriteNode = SKSpriteNode(imageNamed: "ossan.png")
    let gameOverLabel = SKLabelNode()
    
    override func didMove(to view: SKView) {
        // このシーンが表示されるタイミングで呼び出される
        // 主に初期化処理に使う
        
        // 透過
        self.mainCharaNode.alpha = 1
        // 画面中央が 0, 0
        self.mainCharaNode.position = CGPoint(x: 200, y: view.frame.height / -2 + 100)
        self.addChild(self.mainCharaNode)
        
        self.backgroundColor = UIColor.white
        self.addShark()
        
        self.gameOverLabel.text = "Game Over"
        self.gameOverLabel.fontColor = UIColor.black
        self.gameOverLabel.fontSize = 128
        self.gameOverLabel.alpha = 0
        self.addChild(gameOverLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 画面をタッチ開始した時に呼ばれる
        let movePos = CGPoint(x: self.mainCharaNode.position.x, y: self.mainCharaNode.position.y + 300)
        
        let jumpUpAction: SKAction = SKAction.move(to: movePos, duration: 0.2)
        jumpUpAction.timingMode = .easeInEaseOut
        
        let jumpDownAction: SKAction = SKAction.move(to: self.mainCharaNode.position, duration: 0.2)
        jumpDownAction.timingMode = .easeInEaseOut
        
        let jumpActions = SKAction.sequence([jumpUpAction, jumpDownAction])
        
        self.mainCharaNode.run(jumpActions)
        
        if self.isGameOver() == true {
            self.gameOverLabel.alpha = 1
        }
    }
    
    /**
     Game Over Check
        true: Game Over
        false: still okay
     */
    func isGameOver() -> Bool {
        if self.mainCharaNode.position.y > self.view!.frame.height / 2 - 100 {
            return true
        }
        
        return false
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // タッチした指が移動した時に呼ばれる
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 画面から指が離れた時に呼ばれる
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        // タッチ処理が継続出来ずに終了した時に呼び出される
        // 基本的に touchesEnded と同様の処理を行う
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // ゲームが60fpsで動作している時、1秒間に60回呼び出される
        // 負荷などの理由により必ず同じタイミングで呼び出される訳ではないので引数のcurrentTimeの差分だけ処理をする
        // 当たり判定
        guard let node = self.childNode(withName: "fish") else { return }
        let nodes = self.nodes(at: node.position)
        
        if nodes.count > 1 {
            self.gameOverLabel.alpha = 1
        }
    }
    
    func addShark() {
        let shark = SKSpriteNode(imageNamed: "teru.png")
        let yPos = CGFloat(Int.random(in: 0 ..< Int(self.view!.frame.height))) - (self.view!.frame.height / 2)
        
        shark.name = "fish"
        shark.position = CGPoint(
            x: self.view!.frame.width * -1,
            y: yPos
        )
        
        self.addChild(shark)
        let moveAction = SKAction.moveTo(x: self.view!.frame.width, duration: 3)
        shark.run(
            SKAction.sequence([moveAction, SKAction.removeFromParent()])
        )
        
        let sharkAttack = SKAction.run {
            self.addShark()
        }
        
        let newSharkAction = SKAction.sequence([SKAction.wait(forDuration: 3), sharkAttack])
        self.run(newSharkAction)
    }
}
