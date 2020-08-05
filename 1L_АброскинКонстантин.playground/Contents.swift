//import UIKit
import Foundation

//ЗАДАНИЕ №1
//Решить квадратное уравнение
//Общий вид квадратного уравнения:
//ax² + bx + c = 0

print("ЗАДАНИЕ №1")

//Зададим коэффициенты квадратного уравнения:
let a: Double = 4
let b: Double = 2
let c: Double = 0

print("Нужно решить квадратное уравнение")
//ax² + bx + c = 0
print("\(a)x² \(b < 0 ? "- " + String(-b): "+ " + String(b))x \(c < 0 ? "- " + String(-c): "+ " + String(c)) = 0")

//Определим дескриминант
let d = b * b - 4 * a * c

if(d.isNaN){
    print("Ошибка вычисления Дискриминанта!")
}else if (d >= 0) {
    let x1 = (-b + sqrt(d)) / 2
    let x2 = (-b - sqrt(d)) / 2
    print("Решения уровнения: \(x1) и \(x2)")
} else {
    print("В квадратном уравнении нет корней")
}

//*******************************************************************************************
 
//ЗАДАНИЕ №2
//Даны катеты прямоугольного треугольника. Найти площадь, периметр и гипотенузу треугольника

print("\nЗАДАНИЕ №2")

let katet1: Double = 3
let katet2: Double = 4

//По теореме Пифагора найдем Гипотенузу
let gipotenuza = sqrt(katet1 * katet1 + katet2 * katet2)
//Площадь прямоугольного треугольника
let s = katet1 * katet2 / 2
//Периметр
let p = katet1 + katet2 + gipotenuza

print("Гипотенуза = \(gipotenuza)\nПлощадь = \(s)\nПериметр = \(p)")
//*******************************************************************************************

//ЗАДАНИЕ №3
//Пользователь вводит сумму вклада в банк и годовой процент. Найти сумму вклада через 5 лет

print("\nЗАДАНИЕ №3")

let sum: Double = 1_000_000
let percent: Double = 6.7
let years = 5

var curSum = sum
for _ in 1...5 {
    curSum += curSum * percent / 100
}
curSum = round(curSum * 100) / 100
let percentSum = round((curSum - sum) * 100) / 100

print("Вы положили на счет \(sum) руб. под \(percent)% на \(years) лет.")
print("Через \(years) лет на вкладе будет \(curSum) руб.\nПроценты составили \(percentSum) руб.")
 
 
