import Foundation

/*
ЗАДАНИЕ
 1. Создать протокол «Car» и описать свойства, общие для автомобилей, а также метод действия.
 2. Создать расширения для протокола «Car» и реализовать в них методы конкретных действий с автомобилем: открыть/закрыть окно, запустить/заглушить двигатель и т.д. (по одному методу на действие, реализовывать следует только те действия, реализация которых общая для всех автомобилей).
 3. Создать два класса, имплементирующих протокол «Car» - trunkCar и sportСar. Описать в них свойства, отличающиеся для спортивного автомобиля и цистерны.
 4. Для каждого класса написать расширение, имплементирующее протокол CustomStringConvertible.
 5. Создать несколько объектов каждого класса. Применить к ним различные действия.
 6. Вывести сами объекты в консоль.
 */

//Локация машины
enum CarLocation: CustomStringConvertible {
    case city, service
    var description: String {
        switch self {
        case .city: return "город"
        case .service: return "сервис"
        }
    }
}

//Свойства машины
indirect enum CarProperty {
    
    enum Color: CustomStringConvertible {
        case red, green, white, black, blue, silver
        var description: String {
            switch self {
            case .red: return "красный"
            case .green: return "зеленый"
            case .white: return "белый"
            case .black: return "черный"
            case .blue: return "синий"
            case .silver: return "серебристый"
            @unknown default: return ""
            }
        }
    }
    
    enum TransmissionType: CustomStringConvertible {
        case manual, automatic, CVT
        var description: String {
            switch self {
            case .manual: return "ручная"
            case .automatic: return "автомат"
            case .CVT: return "робот"
            }
        }
    }
}

//Состояние элементов машины
indirect enum CarStates {
    
    enum EngineStates: CustomStringConvertible {
        case started, stopped
        var description: String {
            switch self {
            case .started: return "запущен"
            case .stopped: return "заглушен"
            }
        }
    }

    enum WindowsStates: CustomStringConvertible {
        case opened, closed
        var description: String {
            switch self {
            case .opened: return "открыты"
            case .closed: return "закрыты"
            }
        }
    }

    enum DoorsStates: CustomStringConvertible {
        case opened, closed
        var description: String {
            switch self {
            case .opened: return "открыты"
            case .closed: return "закрыты"
            }
        }
    }
}

//Действия над машиной
indirect enum CarAction{
    
    enum GeneralCar {
        case runEngine, stopEngine, openWindows, closeWindows, openDoors, closeDoors
    }
    
    enum SportCar {
        case openHatch, closeHatch, changeColor(CarProperty.Color)
    }
    
    enum TrunkCar {
        case trunkUp, trunkDown, load(Int), unload(Int)
    }
    
    case general(GeneralCar)
    case sport(SportCar)
    case trunk(TrunkCar)

}

//Использование механизма универсальных шаблонов
func checkStates<T: Equatable>(prop: inout T, state: T, objText: String, stateText: String) -> String {
    if prop == state {
        return "❗️\(objText) уже \(stateText)"
    } else {
        prop = state
        return "ℹ️ \(objText) \(stateText)"
    }
}

//Протокол для всех машин
protocol Car {
    
    var model: String { get set }
    var year: Int { get set }
    var transmission: CarProperty.TransmissionType { get set }
    var engingeState: CarStates.EngineStates { get set }
    var windowsState: CarStates.WindowsStates { get set }
    var doorsState: CarStates.DoorsStates { get set }
    var distance: UInt { get set }
    var fuelConsumption: Double { get set }
    var fuelLevel: Double { get set }
    var maxFuelLevel: Double { get set }
    
    //Изменить пробег авто
    mutating func addDistance(dist: UInt)
    
    //Заправиться
    mutating func refuel(level: Double)
    
    //Функция убрана из протокола, чтобы потом была возможность вызвать функцию расширения протокола в классах имплементирующих протокол
    //mutating func action(_ action: CarAction)
    
}

extension Car {
    
    //Описание функции с базовыми действиями для всех машин
    mutating func action(_ action: CarAction) {
        var text = ""
        switch action {
        case let .general(generalAction):
            switch generalAction {
            case .runEngine:
                let curState = CarStates.EngineStates.started
                text = checkStates(prop: &engingeState, state: curState, objText: "Двигатель", stateText: "\(curState)")
            case .stopEngine:
                let curState = CarStates.EngineStates.stopped
                text = checkStates(prop: &engingeState, state: curState, objText: "Двигатель", stateText: "\(curState)")
            case .openWindows:
                let curState = CarStates.WindowsStates.opened
                text = checkStates(prop: &windowsState, state: curState, objText: "Окна", stateText: "\(curState)")
            case .closeWindows:
                let curState = CarStates.WindowsStates.closed
                text = checkStates(prop: &windowsState, state: curState, objText: "Окна", stateText: "\(curState)")
            case .openDoors:
                let curState = CarStates.DoorsStates.opened
                text = checkStates(prop: &doorsState, state: curState, objText: "Двери", stateText: "\(curState)")
            case .closeDoors:
                let curState = CarStates.DoorsStates.closed
                text = checkStates(prop: &doorsState, state: curState, objText: "Двери", stateText: "\(curState)")
            }
        default:
            break;
        }
        print(text)
    }
    
    //Добавить пробег
    mutating func addDistance(dist: UInt) {
        let curFuelLevel = fuelLevel - Double(dist) * fuelConsumption / 100
        if curFuelLevel < 0 {
            let availDist = floor(fuelLevel / fuelConsumption * 100)
            print("‼️ Не хватает топлива для преодоления \(dist) км, можно проехать только \(availDist) км")
        } else if curFuelLevel == 0 {
            print("‼️ Уровень топлива будет равен 0 после преодоления \(dist) км. Необходимо заправиться")
        }
        else {
            distance += dist
            print("ℹ️ Пробег машины \(model) увеличился на \(dist). Текущее показание одометра - \(distance) км")
            fuelLevel = curFuelLevel
            let availDist = floor(fuelLevel / fuelConsumption * 100)
            print("ℹ️ Осталось \(fuelLevel) л топлива. При расход топлива \(fuelConsumption) л/100 км, топлива хватит на \(availDist) км")
        }
    }
    
    //Заправиться
    mutating func refuel(level: Double) {
        if level < 0.0 {
            print("‼️ Нельзя заправиться в минус :)")
        } else if level > 0.0 {
            let curFuelLeve = fuelLevel + level
            let availFuelLevel = maxFuelLevel - fuelLevel
            if curFuelLeve > maxFuelLevel {
                fuelLevel = maxFuelLevel
            } else {
                fuelLevel = curFuelLeve
            }
            print("ℹ️ Заправка на \(availFuelLevel) л. Текущий уровень топлива \(fuelLevel) л из \(maxFuelLevel) л")
        }
    }
    
}

//Класс-наследник спортивных машин
class SportCar: Car, CustomStringConvertible {
    
    enum HatchStates: CustomStringConvertible {
        case opened, closed
        var description: String {
            switch self {
            case .opened: return "открыт"
            case .closed: return "закрыт"
            }
        }
    }

    var model: String
    var year: Int
    var transmission: CarProperty.TransmissionType
    var engingeState: CarStates.EngineStates = .stopped
    var windowsState: CarStates.WindowsStates = .closed
    var doorsState: CarStates.DoorsStates = .closed
    var color: CarProperty.Color
    let maxSpeed: Int
    let clearance: Double
    var hatchState: HatchStates = .closed
    var distance: UInt
    var fuelConsumption: Double
    var fuelLevel: Double = 0
    var maxFuelLevel: Double
    
    //Местоположение спорткара, такие действия, как изменене цвета требуют, чтобы машина находилась в сервисе
    private var curLocation: CarLocation = .city
    var currentLocation: CarLocation {
        get {
            print("ℹ️ Текущее положение спорткара \(model) - \(curLocation)")
            return curLocation
        }
        set(newLoc) {
            switch newLoc {
            case .city where curLocation != .city:
                curLocation = .city
                print("ℹ️ Спорткар \(model) выехал в город")
            case .service where curLocation != .service:
                curLocation = .service
                print("ℹ️ Спорткар \(model) заехал в сервис")
            default:
                break
            }
        }
    }
    
    //Возможные действия с авто
    func action(_ action: CarAction) {
        
        switch action {
        //Проверим возможные действия для спорткара
        case let .sport(sportCarAction):
            switch sportCarAction {
            //Открыть люк
            case .openHatch:
                hatchState = .opened
                print("ℹ️ Люк \(hatchState)")
            //Закрыть люк
            case .closeHatch:
                hatchState = .closed
                print("ℹ️ Люк \(hatchState)")
            //Изменить цвет машины, машина должна находиться в сервисе
            case let .changeColor(color):
                if curLocation != .service {
                    print("‼️ Машина должна находиться в сервисе, чтобы поменять цвет")
                } else {
                    self.color = color
                    print("ℹ️ Цвет машины изменен на \(self.color)")
                }
            }
        //Вызов функции из расширения протокола для обработки базовых действий с авто
        default:
            var generalCar: Car = self
            generalCar.action(action)
        }
    }
    
    var description: String {
        return """
        📝Описание авто:
        Спорткар \(model), год выпуска - \(year), коробка передач - \(transmission)
        Максимальная скорость - \(maxSpeed) км/ч, клиренс - \(clearance) мм, цвет авто - \(color)
        Двигатель \(engingeState), окна \(windowsState), двери \(doorsState), люк \(hatchState)
        Уровень топлива - \(fuelLevel) л из \(maxFuelLevel) л, расход топлива - \(fuelConsumption) л на 100 км
        При текущем расходе топлива хвтати на \(floor(fuelLevel / fuelConsumption * 100)) км
        Текущая локация - \(curLocation), текущий пробег - \(distance) км
        """
    }
    
    init(model: String, year: Int, transmission: CarProperty.TransmissionType, color: CarProperty.Color, maxSpeed: Int, clearance: Double, distance: UInt, maxFuelLevel: Double, fuelLevel: Double, fuelConsumption: Double) {
        self.model = model
        self.year = year
        self.transmission = transmission
        self.maxSpeed = maxSpeed
        self.clearance = clearance
        self.color = color
        self.distance = distance
        self.fuelLevel = fuelLevel
        self.maxFuelLevel = maxFuelLevel
        self.fuelConsumption = fuelConsumption
    }
}

//Класс-наследник грузовых машин
class TrunkCar: Car, CustomStringConvertible {
    
    enum TrunkState: String {
        case raised = "поднимается", lowered = "опускается"
    }
    
    var model: String
    var year: Int
    var transmission: CarProperty.TransmissionType
    var engingeState: CarStates.EngineStates = .stopped
    var windowsState: CarStates.WindowsStates = .closed
    var doorsState: CarStates.DoorsStates = .closed
    var distance: UInt
    let maxLoad: Int
    let liftingTrunk: Bool
    var trunkState: TrunkState = .lowered
    var trunkVolume: Int = 0
    var fuelConsumption: Double
    var fuelLevel: Double
    var maxFuelLevel: Double
    
    //Возможные действия с авто
    func action(_ action: CarAction) {
        switch action {
        case let .trunk(trunkAction):
            switch trunkAction {
            //Поднять кузов, при условии, что кузов оборудован подъемниками
            case .trunkUp where liftingTrunk:
                trunkState = .raised
                print("ℹ️ Кузов \(trunkState.rawValue). Машина разгружается!")
                print("ℹ️ Было выгружено \(trunkVolume)")
                trunkVolume = 0
            //Опустить кузов, при условии, что кузов оборудован подъемниками
            case .trunkDown where liftingTrunk:
                trunkState = .lowered
                print("ℹ️ Кузов \(trunkState.rawValue)")
            //Погрузить
            case let .load(V):
                if trunkVolume + V > maxLoad {
                    print("‼️ Перегруз. Попытка погрузить груз весом \(V), всего доступно \(maxLoad)")
                } else {
                    trunkVolume += V
                    print("ℹ️ Погрузка на \(V) завершена. Доступно еще \(maxLoad - trunkVolume)")
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
                print("‼️ Кузов не оборудован подъемником")
            }
        //Вызов функции из расширения протокола для обработки базовых действий с авто
        default:
            var generalCar: Car = self
            generalCar.action(action)
        }
    }
    
    var description: String {
        let trunkDescription = liftingTrunk ? "кузов оборудован подъемниками" : "кузов не оборудован подъемниками"
        return """
        📝Описание авто:
        Грузовик \(model), год выпуска - \(year), коробка передач - \(transmission)
        Двигатель \(engingeState), окна \(windowsState), двери \(doorsState)
        Текущий пробег - \(distance) км
        Уровень топлива - \(fuelLevel) л из \(maxFuelLevel) л, расход топлива - \(fuelConsumption) л на 100 км
        При текущем расходе топлива хватит на \(floor(fuelLevel / fuelConsumption * 100)) км
        Загруженность - \(trunkVolume) из \(maxLoad), \(trunkDescription)
        """
    }
    
    init(model: String, year: Int, transmission: CarProperty.TransmissionType, maxLoad: Int, liftingTrunk: Bool, distance: UInt, maxFuelLevel: Double, fuelLevel: Double, fuelConsumption: Double) {
        self.model = model
        self.year = year
        self.transmission = transmission
        self.distance = distance
        self.maxLoad = maxLoad
        self.liftingTrunk = liftingTrunk
        self.maxFuelLevel = maxFuelLevel
        self.fuelLevel = fuelLevel
        self.fuelConsumption = fuelConsumption
    }
    
}

//Экземпляр легкового автомобиля
var myCar = SportCar(model: "BMW", year: 2020, transmission: .CVT, color: .red, maxSpeed: 350, clearance: 12, distance: 1800, maxFuelLevel: 80, fuelLevel: 70, fuelConsumption: 9.5)
print(myCar)
myCar.action(.general(.runEngine))
myCar.action(.sport(.changeColor(.blue)))
myCar.currentLocation = .service
myCar.action(.sport(.changeColor(.blue)))
myCar.action(.general(.openDoors))
myCar.action(.sport(.openHatch))
myCar.addDistance(dist: 1000)
myCar.refuel(level: 300)
print(myCar)

print("-------------------------------------------------------------------------------------------------")

//Экземпляр грузового автомобиля
var myTruck = TrunkCar(model: "Kamaz", year: 2019, transmission: .manual, maxLoad: 20000, liftingTrunk: true, distance: 20000, maxFuelLevel: 200, fuelLevel: 150.0, fuelConsumption: 15.0)
print(myTruck)
myTruck.action(.general(.openWindows))
myTruck.action(.trunk(.trunkDown))
print(myTruck)

print("-------------------------------------------------------------------------------------------------")

//Экземпляр грузового автомобиля
var myTruck2 = TrunkCar(model: "UAZ", year: 2015, transmission: .manual, maxLoad: 5000, liftingTrunk: false, distance: 150000, maxFuelLevel: 100, fuelLevel: 80.0, fuelConsumption: 13.0)
print(myTruck2)
myTruck2.action(.general(.runEngine))
myTruck2.action(.trunk(.load(3000)))
myTruck2.action(.general(.openWindows))
myTruck2.action(.trunk(.trunkDown))
myTruck2.addDistance(dist: 300)
myTruck2.addDistance(dist: 400)
myTruck2.refuel(level: 200)
myTruck2.addDistance(dist: 300)
print(myTruck2)
