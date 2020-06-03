import Foundation

// ЗАДАНИЕ 1
// Придумать класс, методы которого могут создавать непоправимые ошибки. Реализовать их с помощью try/catch.

// Возможные ошибки
enum BarrackError: Error {
    case invalidName
    case notAvailableCount(countAvail: Int)
    case notEnoughtGold(goldNeeded: Int)
}

enum BarrackAvailError: Error {
    case notAvailable
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
    func buyUnits(_ name: String, _ count: Int) throws -> (Unit, Int) {
        
        guard let unit = units[name] else { throw BarrackError.invalidName }
        guard unit.count > 0 && unit.count >= count else { throw BarrackError.notAvailableCount(countAvail: unit.count) }
        guard unit.price * count <= goldAvailable else { throw BarrackError.notEnoughtGold(goldNeeded: unit.price * count - goldAvailable) }
        
        goldAvailable -= unit.price * count
        var curUnit = unit
        curUnit.count -= count
        units[name] = curUnit
        
        return (unit.unit, count)
    }
}

// Протестируем механизм работы try/catch
var barracksOfShtormgrad = Barrack()
barracksOfShtormgrad.goldAvailable = 110000

func action(barrack: Barrack?, nameOfUnit: String, countToBuy: Int) throws -> (Unit, Int) {
    guard let barrackToBuy = barrack else { throw BarrackAvailError.notAvailable }
    return try barrackToBuy.buyUnits(nameOfUnit, countToBuy)
}

func buyUnit(barrack: Barrack?, nameOfUnit: String, countToBuy: Int) {
    
    do {
        let act = try action(barrack: barrack, nameOfUnit: nameOfUnit, countToBuy: countToBuy)
        print("You bought \(act.0.name) (\(act.1))")
    } catch BarrackError.invalidName {
        print("Incorrect name \(nameOfUnit)")
    } catch let BarrackError.notAvailableCount(countAvail) {
        print("Not enought count to sell. You want to buy \(countToBuy), available \(countAvail)")
    } catch let BarrackError.notEnoughtGold(goldNeeded) {
        print("Not enought gold to buy. You need more \(goldNeeded) gold")
    } catch BarrackAvailError.notAvailable {
        print("Barrack has not available")
    } catch let error {
        print(error.localizedDescription)
    }
    
}

buyUnit(barrack: barracksOfShtormgrad, nameOfUnit: "Swordsman", countToBuy: 1000)
buyUnit(barrack: barracksOfShtormgrad, nameOfUnit: "Spearman", countToBuy: 50)
buyUnit(barrack: barracksOfShtormgrad, nameOfUnit: "Assasin", countToBuy: 100)
barracksOfShtormgrad.goldAvailable = 110000
buyUnit(barrack: barracksOfShtormgrad, nameOfUnit: "Magic", countToBuy: 10)
buyUnit(barrack: barracksOfShtormgrad, nameOfUnit: "Mage", countToBuy: 10)
buyUnit(barrack: nil, nameOfUnit: "Swordsman", countToBuy: 2000)
buyUnit(barrack: barracksOfShtormgrad, nameOfUnit: "Swordsman", countToBuy: 2000)
