//
//  SnakeBodyPart.swift
//  8L_AbroskinKonstantin
//
//  Created by Sky on 31.05.2020.
//  Copyright © 2020 Aksilont. All rights reserved.
//

import UIKit
import SpriteKit

class SnakeBodyPart: SKShapeNode {
    
    let diametr = 10.0
    // Добавляем конструктор
    init(atPoint point: CGPoint) {
        super.init()
        // Рисуем круглый элемент
        path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: CGFloat(diametr), height: CGFloat(diametr))).cgPath
        // Цвет рамки и заливки - зеленый
        fillColor = .green
        strokeColor = .green
        // Ширина рамки 5 поинтов
        lineWidth = 5
        // Размещаем элемент в переданной точке
        self.position = point
        // Создаем физическое тело
        self.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(diametr - 4), center: CGPoint(x: 5, y: 5))
        // Может перемещаться в пространстве
        self.physicsBody?.isDynamic = true
        // Категория - змея
        self.physicsBody?.categoryBitMask = CollisionCategories.Snake
        // Пересекается с границами экрана и яблоком
        self.physicsBody?.contactTestBitMask = CollisionCategories.EdgeBody | CollisionCategories.Apple
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
