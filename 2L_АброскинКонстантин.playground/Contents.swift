//import UIKit
import Foundation

//ЗАДАНИЕ №1
//Написать функцию, которая определяет, четное число или нет
func evenNumber(_ number: Int) -> Bool {
    if number % 2 == 0 {
        return true
    } else {
        return false
    }
}
let number = 26
print("Ваше число \(number) - \(evenNumber(number) ? "четное": "нечетное")")

//*************************************************************************************************

//ЗАДАНИЕ №2
//Написать функцию, которая определяет, делится ли число без остатка на 3.
func divideNumberBy3(_ number: Int) -> Bool {
    if number % 3 == 0 {
        return true
    } else {
        return false
    }
}
let number2 = 26
print("Ваше число \(number2) \(divideNumberBy3(number2) ? "": "НЕ") делится без остатка на 3")

//*************************************************************************************************

//ЗАДАНИЕ №3
//Создать возрастающий массив из 100 чисел.
var array = [Int] (1...100)

//*************************************************************************************************

//ЗАДАНИЕ №4
//Удалить из этого массива все четные числа и все числа, которые не делятся на 3.

//Самый простой способ это сделать, использовать встроенную функцию
//array.removeAll {(number: Int) -> Bool in number % 2 == 0 || number % 3 == 0}
//array.removeAll {number -> Bool in evenNumber(number) || divideNumberBy3(number)}
//array.removeAll(where: evenNumber)
//array.removeAll(where: divideNumberBy3)

//Интереснее было бы использовать и посмотреть какие еще механизмы есть для решения этого задания

//Этап 1. Удаление четных чисел

//Также существует множество вариантов решения этого этапа, самые простые это использовать встроенные функции массива
/*
 array = array.filter({ (number: Int) -> Bool in
     return !evenNumber(number)
 })
 
 array = array.filter { number in !evenNumber(number) }
 
 array = array.filter { $0 % 2 == 1 }
*/

//Использовал (алиас) свой псевдоним для типа функции, которое получает 1 параметр типа Int, а возвращает Bool
typealias spOp = (Int) -> Bool

//Также можно создать специальную функцию, которая в качестве параметров получает:
//  array - исходный массив
//  operation - функцию обработки этого массив
//  condition - истинность выполнения переданной функции, значение по-умолчанию true
func myFilterArray(array: [Int], operation: spOp, condition: Bool = true) -> [Int]{
    var newArray = [Int]()
    for item in array {
        if condition && operation(item) {
            newArray.append(item)
        } else if !condition && !operation(item) {
            newArray.append(item)
        }
    }
    return newArray
}
array = myFilterArray(array: array, operation: evenNumber, condition: false)

//Этап 2. Удаление всех чисел, которые не делятся на 3

//array = array.filter(divideNumberBy3)
//или
//array = myFilterArray(array: array, operation: divideNumberBy3)
//или
//Используя расширение для типа Array
extension Array {
    func myFilter(_ operation: spOp, _ condition: Bool = true) -> [Int]{
        var newArray = [Int]()
        for item in self {
            if condition && operation(item as! Int) {
                newArray.append(item as! Int)
            } else if !condition && !operation(item as! Int) {
                newArray.append(item as! Int)
            }
        }
        return newArray
    }
}
array = array.myFilter(divideNumberBy3)

//*************************************************************************************************

//ЗАДАНИЕ 5
//Написать функцию, которая добавляет в массив новое число Фибоначчи, и добавить при помощи нее 100 элементов.
//Числа Фибоначчи определяются соотношениями Fn = Fn-1 + Fn-2.

func addFibonachi(array: inout [Double], times: Int = 100) {
    if array.count < 2 {
        print("В массиве недостаточно элементов")
        return
    }
    for _ in 1...times - array.count {
        let newNumer = array[array.count - 1] + array[array.count - 2]
        array.append(newNumer)
    }
}

var newArray: [Double] = [0, 1]
addFibonachi(array: &newArray)
//Последнее число массива:
//newArray.last! = 218_922_995_834_555_169_026

//*************************************************************************************************

//ЗАДАНИЕ 6
/*
 Заполнить массив из 100 элементов различными простыми числами. Натуральное число, большее единицы, называется простым, если оно делится только на себя и на единицу. Для нахождения всех простых чисел не больше заданного числа n, следуя методу Эратосфена, нужно выполнить следующие шаги:
    * a. Выписать подряд все целые числа от двух до n (2, 3, 4, ..., n).
    * b. Пусть переменная p изначально равна двум — первому простому числу.
    * c. Зачеркнуть в списке числа от 2p до n, считая шагами по p (это будут числа, кратные p: 2p, 3p, 4p, ...).
    * d. Найти первое не зачёркнутое число в списке, большее, чем p, и присвоить значению переменной p это число.
    * e. Повторять шаги c и d, пока возможно.
 */

func fillArraySimpleNumbers(maxLength: Int = 100) -> [Int] {
    
    //Выпишем множество целых чисел из массива от 2 до maxLength * 10 (с запасом, т.к. элементы будут удаляться из множества по мере выполнения алгоритма)
    var result = Set<Int>([Int](2...maxLength * 10))
    
    //Пусть переменная p изначально равна двум — первому простому числу.
    var p = 2
    
    //Временное множество, куда мы будем помещать элементы, которые надо будет вычеркнуть из результирующего множества
    var subSet = Set<Int>()

    //Функция, которая найдет первое не зачёркнутое число в списке, большее, чем p, и присвоит значению переменной p это число.
    func nextNumber(_ array: [Int], _ number: inout Int) {
        for item in array {
            if number < item {
                number = item
                return
            }
        }
    }
    
    //Будем повторять шаги c. и d. до тех пор, пока возможно, т.е. пока число p меньше максимального значения результируещго множества
    while p < result.max()! {
        
        subSet.removeAll()
        
        //Получим множество всех чисел от 2p до n, считая шагами по p (это будут числа, кратные p: 2p, 3p, 4p, ...)
        for i in stride(from: 2 * p, through: result.max()!, by: p) {
            subSet.insert(i)
        }
        //Вычеркним из результирующего множества полученные выше числа
        result = result.subtracting(subSet)
        
        //В параметры функции передаётся сортированный массив
        nextNumber(result.sorted(), &p)
        
    }
    
    //Уберем лишние элементы массива
    var resultArray = result.sorted()
    while resultArray.count > maxLength {
        resultArray.removeLast()
    }
    return resultArray
}

let resultArray = fillArraySimpleNumbers()
resultArray.count
print(resultArray)



