import SwiftUI
import SpriteKit

protocol GameScreenViewControllerDelegate: AnyObject {
    func ballFalled(at: Int)
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    public weak var gameDelegate: GameScreenViewControllerDelegate?
    public var currentBall = 0
    private var ball: SKShapeNode?
    private let boxWidth: CGFloat = 29
    private let boxHeight: CGFloat = 20
    private let boxCount: Int = 10
    private let spacing: CGFloat = 40
    private let centralX: CGFloat
    private var boxMultipliers: [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    private var boxNodes: [SKSpriteNode] = []
    private var boxLabels: [SKLabelNode] = []
    private var isLaunching: Bool = true
    private var ballLanded = true
    private var isBonusActive: Bool = false

    override init() {
        self.centralX = UIScreen.main.bounds.width / 2
        super.init(size: CGSize(width: 342, height: 519))
        let backTextrure = SKTexture(image: UIImage(named: "backback")!)
        let backnode = SKSpriteNode(texture: backTextrure)
        backnode.position = CGPoint(x: 171, y: 259.5)
        backnode.size = CGSize(width: 342, height: 519)
        backnode.zPosition = -1 // Размещаем поверх фона
    
        addChild(backnode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public override func didMove(to view: SKView) {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadPressed), name: NSNotification.Name("targetReloaded"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dropBallAtPosition(_:)), name: NSNotification.Name("ballDropped"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(moveBallToPosition(_:)), name: NSNotification.Name("ballMoved"), object: nil)
        setupPhysicsWorld()
        createInitialScene()
        loadData()
        
        for i in 0..<boxLabels.count {
            boxLabels[i].text = "\(i+1)"
        }
    }
    
    @objc
    func reloadPressed() {
        for i in 0..<10 {
            boxLabels[i].fontColor = .green
            boxNodes[i].texture = SKTexture(imageNamed: "box")
        }
    }
    
    func loadData() {
        let arr = GetterSingletone.shared.currentArray
        for i in arr {
            boxLabels[i].fontColor = .white
            boxNodes[i].texture = SKTexture(imageNamed: "boxWhite")
        }
    }
    
    private func setupPhysicsWorld() {
        physicsWorld.gravity = CGVector(dx: 0, dy: -15)
        physicsWorld.contactDelegate = self
        physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
    }
     
    private func createInitialScene() {
        createBall(at: CGPoint(x: size.width / 2, y: size.height - 70))
        createInvertedTrianglePegs()
        createBoxesWithRandomZeroMultiplier()
    }
    
    private func createBoxesWithRandomZeroMultiplier() {
        let startY: CGFloat = 128
        let totalBoxWidth = CGFloat(boxCount) * boxWidth
        let totalSpacing = CGFloat(boxCount - 1) * spacing / 10
        let startX = (size.width - (totalBoxWidth + totalSpacing)) / 2
        var dynamicBoxMultipliers = boxMultipliers
        let shouldHaveZero = Bool.random()
        if shouldHaveZero {
            let randomIndex = Int.random(in: 0..<boxCount)
            dynamicBoxMultipliers[randomIndex] = 0
        }
        for i in 0..<boxCount {
            let boxX = startX + CGFloat(i) * (boxWidth + spacing / 10)
            createBox(at: CGPoint(x: boxX, y: startY), withMultiplier: dynamicBoxMultipliers[i])
        }
    }
    
    private func createBox(at position: CGPoint, withMultiplier multiplier: Int) {
        createBoxWalls(at: position, withMultiplier: multiplier)
        addMultiplierLabelWithBackground(at: position, withMultiplier: multiplier)
    }

    private func addMultiplierLabelWithBackground(at position: CGPoint, withMultiplier multiplier: Int) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: -boxWidth / 2, y: -boxHeight / 2))
        path.addLine(to: CGPoint(x: -boxWidth / 2, y: boxHeight / 2))
        path.addLine(to: CGPoint(x: boxWidth / 2, y: boxHeight / 2))
        path.addLine(to: CGPoint(x: boxWidth / 2, y: -boxHeight / 2))
        path.close()
        let texture = SKTexture(imageNamed: "box")
        let imageNode = SKSpriteNode(texture: texture)
        imageNode.size = CGSize(width: boxWidth, height: boxHeight)
        imageNode.position = CGPoint(x: position.x + boxWidth / 2, y: position.y + boxHeight / 2)
        imageNode.zPosition = 1
        imageNode.name = "box"
        addChild(imageNode)
        boxNodes.append(imageNode)
        let label = SKLabelNode(text: "\(multiplier)")
        label.fontColor = .green
        label.alpha = 1.0
        label.fontSize = 14
        label.fontName = "Helvetica-Bold"
        label.position = CGPoint(x: position.x + boxWidth / 2, y: position.y + boxHeight / 2 - 3)
        label.zPosition = 9
        addChild(label)
        boxLabels.append(label)
        
    }

    private func createBoxWalls(at position: CGPoint, withMultiplier multiplier: Int) {
        let wallsNodes = [
            SKSpriteNode(color: .clear, size: CGSize(width: 2, height: boxHeight)),
            SKSpriteNode(color: .clear, size: CGSize(width: 2, height: boxHeight)),
            SKSpriteNode(color: .clear, size: CGSize(width: boxWidth, height: 2))
        ]
        wallsNodes[0].position = CGPoint(x: position.x, y: position.y + boxHeight / 2)
        wallsNodes[1].position = CGPoint(x: position.x + boxWidth, y: position.y + boxHeight / 2)
        wallsNodes[2].position = CGPoint(x: position.x + boxWidth / 2, y: position.y);
        for wallNode in wallsNodes {
            wallNode.physicsBody = SKPhysicsBody(rectangleOf: wallNode.size)
            wallNode.physicsBody?.isDynamic = false
            wallNode.name = "box"
            addChild(wallNode)
        }
    }
    


   public override func update(_ currentTime: TimeInterval) {
        if !ballLanded, let ball = ball {
            let boxIndex = checkBallInBoxes(ballPosition: ball.position)
            if boxIndex != -1 {
                let multiplier = boxMultipliers[boxIndex]
                NotificationCenter.default.post(name: NSNotification.Name("updateMultiplier"), object: multiplier)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    self.children.filter { $0.name == "ball" }.forEach { $0.removeFromParent() }
                    self.createBall(at: CGPoint(x: self.size.width / 2, y: self.size.height - 70))
                }
                NotificationCenter.default.post(name: Notification.Name("ballFalled"), object: nil, userInfo: ["index": boxIndex])
                ballLanded = true
                NotificationCenter.default.post(name: NSNotification.Name("ballLanded"), object: nil)
            }
        }
        applyForceTowardsCenter()
    }

    private func checkBallInBoxes(ballPosition: CGPoint) -> Int {
        let startY: CGFloat = 128

        let totalBoxWidth = CGFloat(boxCount) * boxWidth
        let totalSpacing = CGFloat(boxCount - 1) * spacing / 10
        let startX = (size.width - (totalBoxWidth + totalSpacing)) / 2
        for i in 0..<boxCount {
            let boxX = startX + CGFloat(i) * (boxWidth + spacing / 10)
            let boxRect = CGRect(x: boxX, y: startY, width: boxWidth, height: boxHeight)
            if boxRect.contains(ballPosition) {
                boxLabels[i].fontColor = .white
                boxNodes[i].texture = SKTexture(imageNamed: "boxWhite")
                return i
            }
        }
        return -1
    }
    
    private func createInvertedTrianglePegs() {
        let topY = size.height * 0.8
        let startingPegs = 3
        let endingPegs = 10
        
        for i in 0..<7 {
            let pegsInRow = startingPegs + i * (endingPegs - startingPegs) / (10 - 1)
            let totalWidth = CGFloat(pegsInRow - 1) * spacing
            let xOffset = (size.width - totalWidth) / 2
            for j in 0..<pegsInRow {
                let pegX = xOffset + CGFloat(j) * spacing
                let pegY = topY - CGFloat(i) * spacing
                createCircle(at: CGPoint(x: pegX, y: pegY))
            }
        }
    }
    
    private func createCircle(at position: CGPoint) {
        let circle = SKShapeNode(circleOfRadius: 4)
        circle.position = position
        circle.fillColor = .white
        circle.physicsBody = SKPhysicsBody(circleOfRadius: 4)
        circle.physicsBody?.isDynamic = false
        circle.physicsBody?.friction = 0.3
        circle.physicsBody?.restitution = 0.4
        circle.physicsBody?.categoryBitMask = 1
        circle.physicsBody?.contactTestBitMask = 2
        addChild(circle)
    }
    
    private func createBall(at position: CGPoint) {
        ball = SKShapeNode(circleOfRadius: 10)
        ball?.position = position
        ball?.fillColor = .purple
        let ballPhysicsBody = SKPhysicsBody(circleOfRadius: 10)
        ballPhysicsBody.friction = 0.2
        ballPhysicsBody.restitution = 0.6
        ballPhysicsBody.linearDamping = 0.1
        ballPhysicsBody.angularDamping = 0.1
        ballPhysicsBody.isDynamic = false
        ballPhysicsBody.categoryBitMask = 2
        ballPhysicsBody.contactTestBitMask = 1
        ball?.physicsBody = ballPhysicsBody
        ball?.name = "ball"
        if let ball = ball {
            addChild(ball)
        }
    }
    
    @objc private func dropBallAtPosition(_ notification: Notification) {
        guard let _ = notification.object as? CGFloat else { return }
        ballLanded = false
        if isBonusActive {
            for i in 0..<3 {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.1) {
                    if let newBall = self.ball {
                        newBall.physicsBody?.isDynamic = true
                    }
                }
            }
        } else {
            ball?.physicsBody?.isDynamic = true
        }

        isLaunching = false
    }
    
    @objc private func moveBallToPosition(_ notification: Notification) {
        guard let newXPosition = notification.object as? CGFloat else { return }
        ball?.position.x = newXPosition
    }
    
    public func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        if (bodyA.categoryBitMask == 1 && bodyB.categoryBitMask == 2) || (bodyA.categoryBitMask == 2 && bodyB.categoryBitMask == 1) {
            animateCircleCollision(for: bodyA, bodyB)
        }
    }
    
    
    private func animateCircleCollision(for bodyA: SKPhysicsBody, _ bodyB: SKPhysicsBody) {
        guard let circleNode = bodyA.categoryBitMask == 1 ? bodyA.node : bodyB.node else {
            return
        }
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.1)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.1)
        let sequence = SKAction.sequence([scaleUp, scaleDown])
        circleNode.run(sequence)
    }
    
    private func applyForceTowardsCenter() {
        guard let ball = ball, let physicsBody = ball.physicsBody else { return }
        
        let ballPositionX = ball.position.x
        let distanceToCenter = centralX - ballPositionX
        
        if isLaunching {
            let minXPosition = centralX - 30.0
            let maxXPosition = centralX + 30.0
            
            if ball.position.x < minXPosition {
                ball.position.x = minXPosition
            } else if ball.position.x > maxXPosition {
                ball.position.x = maxXPosition
            }
        }
        
        let forceMagnitude: CGFloat = distanceToCenter * CGFloat.random(in: 0.02...0.1)
        physicsBody.applyForce(CGVector(dx: forceMagnitude, dy: 0))
    }
}
