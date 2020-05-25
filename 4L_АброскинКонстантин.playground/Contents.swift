import Foundation

/*
ЗАДАНИЕ
1. Описать класс Car c общими свойствами автомобилей и пустым методом действия по аналогии с прошлым заданием.
2. Описать пару его наследников trunkCar и sportСar. Подумать, какими отличительными свойствами обладают эти автомобили. Описать в каждом наследнике специфичные для него свойства.
3. Взять из прошлого урока enum с действиями над автомобилем. Подумать, какие особенные действия имеет trunkCar, а какие – sportCar. Добавить эти действия в перечисление.
4. В каждом подклассе переопределить метод действия с автомобилем в соответствии с его классом.
5. Создать несколько объектов каждого класса. Применить к ним различные действия.
6. Вывести значения свойств экземпляров в консоль.
*/

//Действия над машиной
indirect enum Action{
    case runEngine, stopEngine, openWindows, closeWindows, openDoors, closeDoors
    
    enum SportCar {
        case openHatch, closeHatch, changeColor(Color)
    }
    
    enum TrunkCar {
        case trunkUp, trunkDown, load(Int), unload(Int)
    }
    
    case sportCar(SportCar)
    case trunkCar(TrunkCar)

}

enum Color: String {
    case red = "красный", green = "зеленый", white = "белый", black = "черный", brown = "коричневый", orange = "оранжевый", blue = "синий", silver = "серебряный"
}

enum CurrentLocation: String {
    case city = "город", service = "сервис"
}

//Использование механизма универсальных шаблонов
func checkStates<T: Equatable>(prop: inout T, state: T, objText: String, stateText: String) -> String {
    if prop == state {
        return "\(objText) уже \(stateText)"
    } else {
        prop = state
        return "\(objText) \(stateText)"
    }
}

//Общий класс для всех машин
class Car {
    
    enum WindowsStates: String {
        case opened = "открыты", closed = "закрыты"
    }
    
    enum EngineStates: String {
        case started = "запущен", stopped = "заглушен"
    }
    enum DoorsState: String {
        case opened = "открыты", closed = "закрыты"
    }
    
    enum TransmissionType: String {
        case manual = "ручная", automatic = "автомат", CVT = "робот"
    }
    
    let model: String
    let year: Int
    let transmission: TransmissionType
    var windowsState: WindowsStates = .closed
    var engingeState: EngineStates = .stopped
    var doorsState: DoorsState = .closed
    
    func description() {
        print("Модель машины \(model), \(year) года выпуска. Двигатель \(engingeState.rawValue), коробка передач - \(transmission.rawValue), окна \(windowsState.rawValue), двери \(doorsState.rawValue)")
    }

    func action(_ action: Action) {
        var text = ""
        
        switch action {
        case .openWindows:
            text = checkStates(prop: &windowsState, state: WindowsStates.opened, objText: "Окна", stateText: WindowsStates.opened.rawValue)
        case .closeWindows:
            text = checkStates(prop: &windowsState, state: WindowsStates.closed, objText: "Окна", stateText: WindowsStates.closed.rawValue)
        case .runEngine:
            text = checkStates(prop: &engingeState, state: EngineStates.started, objText: "Двигатель", stateText: EngineStates.started.rawValue)
        case .stopEngine:
            text = checkStates(prop: &engingeState, state: EngineStates.stopped, objText: "Двигатель", stateText: EngineStates.stopped.rawValue)
        case .openDoors:
            text = checkStates(prop: &doorsState, state: DoorsState.opened, objText: "Двери", stateText: DoorsState.opened.rawValue)
        case .closeDoors:
            text = checkStates(prop: &doorsState, state: DoorsState.closed, objText: "Двери", stateText: DoorsState.closed.rawValue)
        default:
            break;
        }
        print(text)
    }
    
    init(model: String, year: Int, transmission: TransmissionType) {
        self.model = model
        self.year = year
        self.transmission = transmission
    }
    
}

//Класс-наследник спортивных машин
class SportCar: Car {
    
    enum HatchState: String {
        case opened = "открыт", closed = "закрыт"
    }

    var color: Color
    let maxSpeed: Int
    let clearance: Double
    private var clearancePrint: String {
        get {
            return String(clearance) + " mm"
        }
    }
    var hatchState: HatchState = .closed
    
    //Местоположение спорткара, такие действия, как изменене цвета требуют, чтобы машина находилась в сервисе
    private var curLocation: CurrentLocation = .city
    var currentLocation: CurrentLocation {
        get {
            print("Текущее положение спорткара \(model) - \(curLocation.rawValue)")
            return curLocation
        }
        set(newLoc) {
            switch newLoc {
            case .city where curLocation != .city:
                curLocation = .city
                print("Спорткар \(model) выехал в город")
            case .service where curLocation != .service:
                curLocation = .service
                print("Спорткар \(model) заехал в сервис")
            default:
                break
            }
        }
    }
    
    //Переопределение функции с обработкой дополнительных действий над под-классом спортивных машин
    override func action(_ action: Action) {
        switch action {
        case let .sportCar(sportCarAction):
            switch sportCarAction {
            //Открыть люк
            case .openHatch:
                hatchState = .opened
                print("Люк \(hatchState.rawValue)")
            //Закрыть люк
            case .closeHatch:
                hatchState = .closed
                print("Люк \(hatchState.rawValue)")
            //Изменить цвет машины, машина должна находиться в сервисе
            case let .changeColor(color):
                if curLocation != .service {
                    print("Внимание! Машина должна находится в сервисе, чтобы поменять цвет")
                } else {
                    self.color = color
                    print("Цвет машины - \(color.rawValue)")
                }
            }
        default:
            super.action(action)
        }
    }
    
    override func description() {
        super.description()
        print("Тип машины - спорткар, цвет - \(color.rawValue), максимальная скорость - \(maxSpeed), клиренс = \(clearancePrint), люк \(hatchState.rawValue)")
    }
    
    init(model: String, year: Int, transmission: TransmissionType, color: Color, maxSpeed: Int, clearance: Double) {
        self.maxSpeed = maxSpeed
        self.clearance = clearance
        self.color = color
        super.init(model: model, year: year, transmission: transmission)
    }
}

//Класс-наследник грузовых машин
class TrunkCar: Car {
    
    enum TrunkState: String {
        case raised = "поднимается", lowered = "опускается"
    }
    
    let maxLoad: Int
    let liftingTrunk: Bool
    var trunkState: TrunkState = .lowered
    var trunkVolume: Int = 0
    
    //Переопределение функции с обработкой дополнительных действий над под-классом грузовых машин
    override func action(_ action: Action) {
        switch action {
        case let .trunkCar(trunkAction):
            switch trunkAction {
            //Поднять кузов, при условии, что кузов оборудован подъемниками
            case .trunkUp where liftingTrunk:
                trunkState = .raised
                print("Кузов \(trunkState.rawValue). Машина разгружается!")
                print("Было выгружено \(trunkVolume)")
                trunkVolume = 0
            //Опустить кузов, при условии, что кузов оборудован подъемниками
            case .trunkDown where liftingTrunk:
                trunkState = .lowered
                print("Кузов \(trunkState.rawValue)")
            //Погрузить
            case let .load(V):
                if trunkVolume + V > maxLoad {
                    print("Перегруз. Попытка погрузить груз весом \(V), всего доступно \(maxLoad)")
                } else {
                    trunkVolume += V
                    print("Погрузка на \(V) завершена. Доступно еще \(maxLoad - trunkVolume)")
                }
            //Выгрзить
            case let .unload(V):
                if trunkVolume - V < 0 {
                    print("Выгрузка завершена, всего доступно \(maxLoad)")
                } else {
                    trunkVolume -= V
                    print("Выгрузка на \(V) завершена. Доступно еще \(maxLoad - trunkVolume)")
                }
            default:
                print("Кузов не оборудован подъемником")
            }
        default:
            super.action(action)
        }
    }
    
    override func description() {
        super.description()
        let trunkDescription = liftingTrunk ? "кузов " + trunkState.rawValue : "кузов не поднимается"
        print("Тип машины - грузовик, загруженность - \(trunkVolume) из \(maxLoad), \(trunkDescription)")
    }
    
    init(model: String, year: Int, transmission: TransmissionType, maxLoad: Int, liftingTrunk: Bool) {
        self.maxLoad = maxLoad
        self.liftingTrunk = liftingTrunk
        super.init(model: model, year: year, transmission: transmission)
    }
    
}

//Экземпляр легкового автомобиля
var myCar = SportCar(model: "BMW", year: 2020, transmission: .CVT, color: .red, maxSpeed: 350, clearance: 12)
myCar.description()
myCar.action(.sportCar(.openHatch))
myCar.action(.closeDoors)
myCar.action(.openWindows)
myCar.action(.sportCar(.changeColor(.blue)))
myCar.currentLocation = .service
myCar.action(.sportCar(.changeColor(.blue)))
myCar.description()

print()

//Экземпляр грузового автомобиля
var myTruck = TrunkCar(model: "Kamaz", year: 2019, transmission: .manual, maxLoad: 20000, liftingTrunk: true)
myTruck.description()
myTruck.action(.openWindows)
myTruck.action(.trunkCar(.trunkDown))
myTruck.description()

print()

//Экземпляр грузового автомобиля
var myTruck2 = TrunkCar(model: "UAZ", year: 2015, transmission: .manual, maxLoad: 5000, liftingTrunk: false)
myTruck2.description()
myTruck2.action(.runEngine)
myTruck2.action(.trunkCar(.load(3000)))
myTruck2.action(.openWindows)
myTruck2.action(.trunkCar(.trunkDown))
myTruck2.description()

print()

var testCar: Car

testCar = SportCar(model: "Test", year: 2000, transmission: .automatic, color: .blue, maxSpeed: 220, clearance: 200)
testCar.description()
testCar.action(.sportCar(.changeColor(.green)))
testCar.action(.sportCar(.openHatch))

print()

testCar = TrunkCar(model: "NewTest", year: 2004, transmission: .manual, maxLoad: 30000, liftingTrunk: true)
testCar.description()
testCar.action(.trunkCar(.load(5000)))
testCar.action(.trunkCar(.unload(2000)))
testCar.action(.runEngine)
testCar.action(.trunkCar(.trunkUp))
testCar.description()
