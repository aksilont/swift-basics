import Foundation

// ЗАДАНИЕ 2
// Придумать класс, методы которого могут завершаться неудачей. Реализовать их с использованием Error.

// Возможные ошибки
enum BarrackError: Error {
    case invalidName
    case notAvailableCount
    case notEnoughtGold(goldNeeded: Int)
}

// Структура Юнита
struct Unit {
    var name: String
}

// Структура позиции Юнита в бараках
struct UnitState {
    var price: Int
    var count: Int
    let unit: Unit
}

//Барак, где мы можем нанимать (покупать) юнитов для нашей армии
class Barrack {
    
    // Доступные варианты для рекрутинга юниты
    var units = [
        "Swordsman": UnitState(price: 110, count: 2300, unit: Unit(name: "Swordsman")),
        "Spearman": UnitState(price: 120, count: 1400, unit: Unit(name: "Spearman")),
        "Archer": UnitState(price: 150, count: 1800, unit: Unit(name: "Archer")),
        "Assasin": UnitState(price: 250, count: 15, unit: Unit(name: "Assasin")),
        "Mage": UnitState(price: 200, count: 25, unit: Unit(name: "Mage"))
    ]
    
    // доступно золота
    var goldAvailable: Int = 0
    
    // нанять (купить) заданное количество юнитов нужного типа
    func buyUnits(_ name: String, _ count: Int) -> (Unit?, Int?, BarrackError?) {
        
        guard let unit = units[name] else { return (nil, nil, BarrackError.invalidName) }
        guard unit.count > 0 && unit.count >= count else { return (nil, nil, BarrackError.notAvailableCount) }
        guard unit.price * count <= goldAvailable else { return (nil, nil, BarrackError.notEnoughtGold(goldNeeded: unit.price * count - goldAvailable)) }
        
        goldAvailable -= unit.price * count
        var curUnit = unit
        curUnit.count -= count
        units[name] = curUnit
        
        return (unit.unit, count, nil)
    }
}

// Протестируем механизм работы Error

var barracksOfShtormgrad = Barrack()
barracksOfShtormgrad.goldAvailable = 110000

func buyUnits(barrack: Barrack, nameOfUnit: String, countToBuy: Int) {
    let act = barrack.buyUnits(nameOfUnit, countToBuy)
    if let unit = act.0 {
        print("You bought \(unit.name) (\(act.1!))")
    } else if let error = act.2 {
        print("Try to buy \(nameOfUnit) (\(countToBuy)): Error: \(error)")
    }
}

buyUnits(barrack: barracksOfShtormgrad, nameOfUnit: "Swordsman", countToBuy: 1000)
buyUnits(barrack: barracksOfShtormgrad, nameOfUnit: "Spearman", countToBuy: 50)
buyUnits(barrack: barracksOfShtormgrad, nameOfUnit: "Assasin", countToBuy: 100)
buyUnits(barrack: barracksOfShtormgrad, nameOfUnit: "Saber", countToBuy: 2000)
