import Foundation

//*******************************************************************************************************************************************************

//ЗАДАНИЕ
//1. Описать несколько структур – любой легковой автомобиль и любой грузовик.
//2. Структуры должны содержать марку авто, год выпуска, объем багажника/кузова, запущен ли двигатель, открыты ли окна, заполненный объем багажника.
//3. Описать перечисление с возможными действиями с автомобилем: запустить/заглушить двигатель, открыть/закрыть окна, погрузить/выгрузить из кузова/багажника груз определенного объема.
//4. Добавить в структуры метод с одним аргументом типа перечисления, который будет менять свойства структуры в зависимости от действия.
//5. Инициализировать несколько экземпляров структур. Применить к ним различные действия.
//6. Вывести значения свойств экземпляров в консоль.

//*******************************************************************************************************************************************************

//Возможные состояния двигателя
enum EngineStates: String {
    case started = "запущен"
    case stopped = "заглушен"
}
//Возможные действия с двигателем
enum EngineAction {
    case run
    case stop
}
//Возможные состояния окон
enum WindowsStates: String {
    case opened = "открыты"
    case closed = "закрыты"
}
//Возможные действия с окнами
enum WindowsAction {
    case open
    case close
}
//Возможные действия с грузом
enum VolumeAction {
    case load(UInt)
    case unload(UInt)
}

//*******************************************************************************************************************************************************

protocol Car {
    
    var model: String { get set }
    var year: Int { get set }
    var engineState: EngineStates { get set }
    var windowsState: WindowsStates { get set }
    
    mutating func switchEngine(engineAction: EngineAction)
    mutating func controlWindows(windowsAction: WindowsAction)
    mutating func changeVolume(volumeAction: VolumeAction)
    
    func description()
    
}

extension Car {
    
    mutating func switchEngine(engineAction: EngineAction){
        switch engineAction {
        case .run:
            self.engineState = .started
        case .stop:
            self.engineState = .stopped
        }
    }
    
    mutating func controlWindows(windowsAction: WindowsAction){
        switch windowsAction {
        case .open:
            self.windowsState = .opened
        case .close:
            self.windowsState = .closed
        }
    }
    
}

//*******************************************************************************************************************************************************

//Структура с описание легкового автомобиля
struct Automobile: Car {
    
    var model: String
    var year: Int
    var engineState: EngineStates
    var windowsState: WindowsStates
    var trunkVolume: UInt
    var trunkVolumeFilled: UInt = 0
    
    mutating func changeVolume(volumeAction: VolumeAction) {
        switch volumeAction {
        case let .load(V):
            trunkVolumeFilled = (trunkVolumeFilled + V >= trunkVolume) ? (trunkVolume) : (trunkVolumeFilled + V)
        case let .unload(V):
            trunkVolumeFilled = (trunkVolumeFilled - V <= 0) ? (0) : (trunkVolumeFilled - V)
        }
    }
    
    func description() {
        print("Модель авто - \(model), \(year) года выпуска. Всего объем багажника = \(trunkVolume), \(trunkVolumeFilled == 0 ? "багажник пустой" : "багажник заполнен на " + String(trunkVolumeFilled)). Двигатель \(engineState.rawValue), окна \(windowsState.rawValue).")
        
    }
    
    init(model: String, year: Int, trunkVolume: UInt, engineState: EngineStates, windowsState: WindowsStates) {
        self.model = model
        self.year = year
        self.trunkVolume = trunkVolume
        self.engineState = engineState
        self.windowsState = windowsState
    }
    
    init(model: String, year: Int, trunkVolume: UInt, engineState: EngineStates, windowsState: WindowsStates, trunkVolumeFilled: UInt) {
        self.model = model
        self.year = year
        self.trunkVolume = trunkVolume
        self.engineState = engineState
        self.windowsState = windowsState
        self.trunkVolumeFilled = trunkVolumeFilled
    }
    
}

// Структура с описанием грузового автомобиля
struct Truck: Car {
    
    var model: String
    var year: Int
    var engineState: EngineStates
    var windowsState: WindowsStates
    var bodyVolume: UInt
    var bodyVolumeFilled: UInt = 0

    mutating func changeVolume(volumeAction: VolumeAction) {
        switch volumeAction {
        case let .load(V):
            bodyVolumeFilled = (bodyVolumeFilled + V >= bodyVolume) ? (bodyVolume) : (bodyVolumeFilled + V)
        case let .unload(V):
            bodyVolumeFilled = (bodyVolumeFilled - V <= 0) ? (0) : (bodyVolumeFilled - V)
        }
    }
    
    func description() {
        print("Модель грузовика - \(model), \(year) года выпуска. Всего объем кузова = \(bodyVolume), \(bodyVolumeFilled == 0 ? "кузов пустой" : "кузов заполнен на " + String(bodyVolumeFilled)). Двигатель \(engineState.rawValue), окна \(windowsState.rawValue).")
    }
    
    init(model: String, year: Int, bodyVolume: UInt, engineState: EngineStates, windowsState: WindowsStates) {
        self.model = model
        self.year = year
        self.bodyVolume = bodyVolume
        self.engineState = engineState
        self.windowsState = windowsState
    }
    
    init(model: String, year: Int, bodyVolume: UInt, engineState: EngineStates, windowsState: WindowsStates, bodyVolumeFilled: UInt) {
        self.model = model
        self.year = year
        self.bodyVolume = bodyVolume
        self.engineState = engineState
        self.windowsState = windowsState
        self.bodyVolumeFilled = bodyVolumeFilled
    }
    
}

//*******************************************************************************************************************************************************

//Экземпляр легкового автомобиля
var myCar = Automobile(model: "Honda", year: 2018, trunkVolume: 2500, engineState: .stopped, windowsState: .opened)
myCar.description()

myCar.changeVolume(volumeAction: .load(1200))
myCar.controlWindows(windowsAction: .close)
myCar.switchEngine(engineAction: .run)
myCar.description()

print()

//Экземпляр легкового автомобиля
var myCar2 = Automobile(model: "Mercedes", year: 2015, trunkVolume: 4000, engineState: .started, windowsState: .closed, trunkVolumeFilled: 3000)
myCar2.description()
myCar2.controlWindows(windowsAction: .open)
myCar2.changeVolume(volumeAction: .unload(2800))
myCar2.description()

print()

//Экземпляр грузового автомобиля
var myTruck = Truck(model: "UAZ", year: 2012, bodyVolume: 10000, engineState: .started, windowsState: .opened)
myTruck.description()

myTruck.controlWindows(windowsAction: .close)
myTruck.switchEngine(engineAction: .stop)
myTruck.changeVolume(volumeAction: .load(5000))
myTruck.description()

myTruck.controlWindows(windowsAction: .open)
myTruck.switchEngine(engineAction: .run)
myTruck.changeVolume(volumeAction: .unload(1400))
myTruck.description()
