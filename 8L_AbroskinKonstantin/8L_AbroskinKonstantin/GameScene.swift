//
//  GameScene.swift
//  8L_AbroskinKonstantin
//
//  Created by Sky on 31.05.2020.
//  Copyright © 2020 Aksilont. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    // Наша змейка
    var snake: Snake?
    var viewGlobal: SKView?
    
    // вызывается при первом запуске сцены
    override func didMove(to view: SKView) {
        viewGlobal = view
        // цвет фона сцены
        backgroundColor = SKColor.black
        // вектор и сила гравитации
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        // делаем нашу сцену делегатом соприкосновения
        self.physicsWorld.contactDelegate = self
        // добавляем поддержку физики
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        // выключаем внешние воздействия на игру
        self.physicsBody?.allowsRotation = false
        // устанавливаем категорию взаимодействия с другими объектами
        self.physicsBody?.categoryBitMask = CollisionCategories.EdgeBody
        // устанваливаем категории, с которыми будут пересекаться края сцены
        self.physicsBody?.collisionBitMask = CollisionCategories.Snake | CollisionCategories.SnakeHead
        // включаем отображение отладочной информации
        view.showsPhysics = true
        
        // Поворот против часовой стрелки
        // создаем ноду(объект)
        let counterClockWiseButton = SKShapeNode()
        // задаем форму круга
        counterClockWiseButton.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 45, height: 45)).cgPath
        // указываем координаты размещения
        counterClockWiseButton.position = CGPoint(x: view.scene!.frame.minX + 30, y: view.scene!.frame.minY + 30)
        // цвет заливки
        counterClockWiseButton.fillColor = UIColor.gray
        // цвет рамки
        counterClockWiseButton.strokeColor = UIColor.gray
        // толщина рамки
        counterClockWiseButton.lineWidth = 10
        // имя объекта для взаимодействия
        counterClockWiseButton.name = "counterClockWiseButton"
        // добавляем на сцену
        self.addChild(counterClockWiseButton)
        
        // Поворот по часовой стрелки
        let clockWiseButton = SKShapeNode()
        clockWiseButton.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 45, height: 45)).cgPath
        clockWiseButton.position = CGPoint(x: view.scene!.frame.maxX - 80, y: view.scene!.frame.minY + 30)
        clockWiseButton.fillColor = UIColor.gray
        clockWiseButton.strokeColor = UIColor.gray
        clockWiseButton.lineWidth = 10
        clockWiseButton.name = "clockWiseButton"
        self.addChild(clockWiseButton)
        
        // вызовем метод добавления яблока на сцену на старте игры
        createApple()
        
        // Создаем змейку по центру экрана и добавляем ее на сцену
        snake = Snake(atPoin: CGPoint(x: view.scene!.frame.midX, y: view.scene!.frame.midY))
        self.addChild(snake!)
    }
    
    // вызывается при нажатии на экран
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        // перебираем все точки, куда прикоснулся палец
        for touch in touches {
            // опредляем координаты касания для точки
            let touchLocatin = touch.location(in: self)
            // проверяем, если ли объект по этим координатам, и если есть, то не наша ли это кнопка
            guard let touchedNode = self.atPoint(touchLocatin) as? SKShapeNode, touchedNode.name == "counterClockWiseButton" || touchedNode.name == "clockWiseButton" else {
                return
            }
            // если это наша кнопка, заливаем ее зеленым
            touchedNode.fillColor = .green
            // определеяем, какая кнопка нажата, и поворачиваем в нужную сторону
            if touchedNode.name == "counterClockWiseButton" {
                snake!.moveCounterClockWise()
            } else if touchedNode.name == "clockWiseButton" {
                snake!.moveClockWise()
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let touchLocation = touch.location(in: self)
            
            guard let touchNode = self.atPoint(touchLocation) as? SKShapeNode, touchNode.name == "counterClockWiseButton" || touchNode.name == "clockWiseButton" else {
                return
            }
            touchNode.fillColor = .gray
        }
        
    }
    
    // вызывается при прекращении нажатии на экран
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // повторяем все то же самое для действия, когда палец отрывается от экрана
        for touch in touches {
            let touchLocation = touch.location(in: self)
            
            guard let touchedNode = self.atPoint(touchLocation) as? SKShapeNode, touchedNode.name == "counterClockWiseButton" || touchedNode.name == "clockWiseButton" else {
                return
            }
            // но делаем цвет снова серым
            touchedNode.fillColor = .gray
        }
    }
    
    // вызывается при обрыве нажатия на экран, например, если телефон примет звонок и свернет приложение
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    // вызывается при обработке кадров сцены
    override func update(_ currentTime: TimeInterval) {
        snake!.move()
    }
    
    // Создаем яблоко в случайное точке сцены
    func createApple() {
        
        // Случайная точка на экране
        let randX = CGFloat(arc4random_uniform(UInt32(view!.scene!.frame.maxX - 5)) + 1)
        let randY = CGFloat(arc4random_uniform(UInt32(view!.scene!.frame.maxY - 5)) + 1)
        // Создаем яблоко
        let apple = Apple(position: CGPoint(x: randX, y: randY))
        // Добавляем яблоко на сцен
        self.addChild(apple)
    }
}

// Имплементируем протокол
extension GameScene: SKPhysicsContactDelegate {
    // добавляем метод отслеживания начала столкновения
    func didBegin(_ contact: SKPhysicsContact) {
        // логическая сумма масок соприкоснувшихся объектов
        let bodyes = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        // вычитаем из суммы голову змеи, и у нас остается маска второго объекта
        let collisionObject = bodyes ^ CollisionCategories.SnakeHead
        // проверяем, что это за второй объект
        switch collisionObject {
        case CollisionCategories.Apple: // проверяем, что это яблоко
            // яблоко - это один из двух объектов, которые соприкоснулись. Используем тернарный оператор, чтобы вычислить, какой именно
            let apple = contact.bodyA.node is Apple ? contact.bodyA.node : contact.bodyB.node
            // добавляем к змейке еще одну секцию
            snake?.addBodyPart()
            // удаляем съеденное яблоко со сцены
            apple?.removeFromParent()
            // создаем новое яблоко
            createApple()
        case CollisionCategories.EdgeBody: // проверяем, что это стена экрана
            // переберем ноды и удалим змейку и яблоко
            for childNode in self.children {
                if childNode is Snake || childNode is Apple {
                    childNode.removeFromParent()
                }
            }
            // создадим новую змейку и поместим ее в центр сцены
            snake = Snake(atPoin: CGPoint(x: viewGlobal!.scene!.frame.midX, y: viewGlobal!.scene!.frame.midY))
            self.addChild(snake!)
            // создадим яблоко на сцене
            createApple()
        default:
            break
        }
    }
}

// Категории пересечения объектов
struct CollisionCategories {
    // Тело змейки
    static let Snake: UInt32 = 0x1 << 0
    // Голова змейки
    static let SnakeHead: UInt32 = 0x1 << 1
    // Яблоко
    static let Apple: UInt32 = 0x1 << 2
    // Край сцены (экрана)
    static let EdgeBody: UInt32 = 0x1 << 3
}
