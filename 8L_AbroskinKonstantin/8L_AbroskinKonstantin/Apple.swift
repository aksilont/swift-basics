//
//  Apple.swift
//  8L_AbroskinKonstantin
//
//  Created by Sky on 31.05.2020.
//  Copyright © 2020 Aksilont. All rights reserved.
//

import UIKit
import SpriteKit

// Яблоко
class Apple: SKShapeNode {
    
    // Определеяем, как оно будет рисоваться
    convenience init(position: CGPoint){
        self.init()
        // Рисуем круг
        path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 10, height: 10)).cgPath
        // Заливаем красным
        fillColor = UIColor.red
        // Рамка тоже красная
        strokeColor = .red
        // Ширина рамки 5 поинтов
        lineWidth = 5
        self.position = position
        // Добавляем физическое тело, совпадающее с изображением яблока
        self.physicsBody = SKPhysicsBody(circleOfRadius: 10.0, center: CGPoint(x: 5, y: 5))
        // Категория - яблоко
        self.physicsBody?.categoryBitMask = CollisionCategories.Apple
    }
}
