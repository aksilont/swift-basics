import Foundation

// ЗАДАНИЕ
// 1. Реализовать свой тип коллекции «очередь» (queue) c использованием дженериков.
// 2. Добавить ему несколько методов высшего порядка, полезных для этой коллекции (пример: filter для массивов)
// 3. *Добавить свой subscript, который будет возвращать nil в случае обращения к несуществующему индексу.

// Принцип очереди - первый пришел, первый ушел
struct Queue<Element: CustomStringConvertible>: CustomStringConvertible {
    
    private var elements: [Element] = []
    
    // Первый элемент в очереди
    var first: Element? {
        return elements.first
    }
    
    // Последний элемент в очереди
    var last: Element? {
        return elements.last
    }
    
    // Добавить элемент в конец очереди
    mutating func push(_ element: Element) {
        elements.append(element)
    }
    
    // Извлечь из очереди первый элемент
    mutating func pop() -> Element? {
        guard !elements.isEmpty else {
            return nil
        }
        return elements.remove(at: 0)
    }
    
    // Вывод всех элементов в очереди
    var description: String {
        guard elements.count != 0 else {
            return ""
        }
        var text = ""
        for item in elements {
            text += text == "" ? item.description : ", " + item.description
        }
        return "[" + text + "]"
    }
    
    // Сабскрипт по индексу элемента в очереди
    subscript(element: Int) -> Element? {
        get {
            guard !elements.isEmpty && element < elements.count else {
                return nil
            }
            return elements[element]
        }
        set {
            guard !elements.isEmpty && element < elements.count else { return }
            elements[element] = newValue!
        }
    }
    
}

extension Queue where Element: Equatable {
    
    // Отфильтровать очередь, по заданному алгоритму
    mutating func filter(_ closure: (Element) -> Bool) {
        var newElements = [Element]()
        for item in elements {
            if closure(item) {
                newElements.append(item)
            }
        }
        elements = newElements
    }
    
    // Перебрать каждый элемент очереди и вызвать замыкание для каждого элемента
    mutating func forEach(_ closure: (Element) -> Void) {
        for item in elements {
            closure(item)
        }
    }
    
    // Найти индекс по значению элемента
    func findIndex(of valueToFind: Element) -> Int? {
        for (index, value) in elements.enumerated() {
            if valueToFind == value {
                return index
            }
        }
        return nil
    }
    
    // Найти первый элемент, удовлетворяющий условию
    func first(where predicate: (Element) -> Bool) -> Element? {
        guard !elements.isEmpty else { return nil }
        for item in elements {
            if predicate(item) { return item }
        }
        return nil
    }
    
}

// Протестируем механизм Очередь

// Создадим очередь из целых чисел
var testing: Queue<Int> = Queue<Int>()
testing.push(12)
testing.push(3)
testing.push(23)

// Получим первый элемент и удалим его из стэка
if let deletedElement = testing.pop() {
    print("Из очереди извлечен элемент \(deletedElement)")
}

//Отфильтруем только те элементы, которые равны 3
testing.filter {$0 == 3}
testing.pop()
// Попробуем извлечь элемент из пустой очереди
testing.pop()

//Добавим несколько значений в очередь
testing.push(12)
testing.push(3)
testing.push(23)
testing.push(13)
testing.push(31)
testing.push(24)
testing.push(19)

// Извлекем пару элементов очереди
testing.pop()
testing.pop()

// Получим элементы стэка по позиции
testing[0]
testing[4]
testing[10]
// Элемента с позицией 20 не существует, поэтому ничего не произойдет
testing[20] = 42

// Изменим элемент позиции 4 на 9999
testing[4] = 9999
print(testing)

// Добавим еще элементов в стэк
print("Добавим еще элементов в конец очереди")
testing.push(33)
testing.push(54)
testing.push(14)
testing.push(4)
print(testing)

// Отфильтруем только четные элементы
print("Отфильтруем только четные элементы")
testing.filter {$0 % 2 == 0}
print(testing)

// Последний элемент стэка без удаления
if let lastElement = testing.last {
    print("Последний элемент очереди без удаления - \(lastElement)")
}

// Первый элемент стэка без удаления
if let firstElement = testing.first {
    print("Первый элемент очереди без удаления - \(firstElement)")
}

// Первый найденный элемент, удовлетворяющий условию
if let firstElement = testing.first(where: { $0 > 50 }) {
    print("Первый найденный элемент, который больше 50 - \(firstElement)")
}

// Переберем элементы стэка и применим к ним замыкание
print("Переберем очередь и выведем значение каждого элемента умноженное на 2:")
testing.forEach { print($0 * 2) }

// Найдем индекс элемента в стэка по значению
let findedValue = 14
if let findedIndex = testing.findIndex(of: findedValue) {
    print("Значение \(findedValue) находится под индексом \(findedIndex)")
}
