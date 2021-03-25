//1. Реализовать свой тип коллекции «очередь» (queue) c использованием дженериков.
//
//2. Добавить ему несколько методов высшего порядка, полезных для этой коллекции (пример: filter для массивов)
//
//3. * Добавить свой subscript, который будет возвращать nil в случае обращения к несуществующему индексу.

import UIKit
import Foundation

protocol Toys {
    var color: String { get }
    var broken: Bool { get set }
}

class Robot: Toys {
    var color: String
    var name: String
    var numGuns: Int
    var broken: Bool
    
    init(color: String, name: String, numGuns: Int, broken: Bool) {
        self.color = color
        self.name = name
        self.numGuns = numGuns
        self.broken = broken
    }
}

class Car: Toys {
    var color: String
    var name: String
    var broken: Bool
    
    init(color: String, name: String, broken: Bool) {
        self.color = color
        self.name = name
        self.broken = broken
    }
}

class PlushToy: Toys {
    var color: String
    var name: String
    var type: String
    var broken: Bool
    
    init(color: String, name: String, type: String, broken: Bool) {
        self.color = color
        self.name = name
        self.type = type
        self.broken = broken
    }
}

struct ToyGenericQueue <T: Toys> {
    private var elements: [T] = []
    
    mutating func push(_ element: T) {
        elements.append(element)
    }
    
    mutating func pop() -> T? {
        guard elements.count > 0 else { return nil }
        return elements.removeFirst()
    }
    
    func filter(predicate: (T) -> Bool) -> [T] {
        var fixed: [T] = []
        for element in elements {
            if predicate(element) {
                fixed.append(element)
            }
        }
        return fixed
    }
    
    func fixToys() -> [T] {
        for var element in elements {
            if element.broken == true {
                element.broken = false
            }
        }
        return elements
    }
    
    func howMany(color: String) -> Int {
        var count = 0
        for element in elements {
            if color == element.color {
                count += 1
            }
        }
        return count
    }
}

enum MyToys: Toys {
    case robot(Robot)
    case car(Car)
    case plushToy(PlushToy)
    var color: String {
        get {
            switch self {
            case .robot(let robot):
                return robot.color
            case .car(let car):
                return car.color
            case .plushToy(let plushToy):
                return plushToy.color
            }
        }
    }
    var broken: Bool {
        get {
            switch self {
            case .robot(let robot):
                return robot.broken
            case .car(let car):
                return car.broken
            case .plushToy(let plushToy):
                return plushToy.broken
            }
        }
        set {
            switch self {
            case .robot(let robot):
                robot.broken = newValue
            case .car(let car):
                car.broken = newValue
            case .plushToy(let plushToy):
                plushToy.broken = newValue
            }
        }
    }
}

extension MyToys: CustomStringConvertible {
    var description: String{
        switch self {
        case .robot(let robot):
            return """
                    \nРобот.
                    Имя игрушки: \(robot.name), цвет: \(robot.color), сколько пушек: \(robot.numGuns), сломан: \(robot.broken ? ("Да") : ("Нет"))\n
                    """
        case .car(let car):
            return """
                    \nМашинка.
                    Имя игрушки: \(car.name), цвет: \(car.color),  сломан: \(car.broken ? ("Да") : ("Нет"))\n
                    """
        case .plushToy(let plushToy):
            return """
                    \nПлюшевая игрушка.
                    Имя игрушки: \(plushToy.name), цвет: \(plushToy.color), тип: \(plushToy.type), сломан: \(plushToy.broken ? ("Да") : ("Нет"))\n
                    """
        }
    }
}


extension ToyGenericQueue {
    subscript(index: Int) -> T? {
        guard index >= 0 && index < elements.count else {
            return nil
        }
        return elements[index]
    }
}

var toyQueue = ToyGenericQueue<MyToys>()

toyQueue.push(.robot(Robot(color: "red", name: "Bionicle", numGuns: 4, broken: true)))
toyQueue.push(.plushToy(PlushToy(color: "blue", name: "Bobo", type: "elephant", broken: false)))
toyQueue.push(.car(Car(color: "green", name: "Bus", broken: true)))
toyQueue.push(.plushToy(PlushToy(color: "red", name: "Smaug", type: "dragon", broken: true)))
toyQueue.push(.robot(Robot(color: "blue", name: "MegaMan", numGuns: 1, broken: false)))
toyQueue.push(.car(Car(color: "green", name: "RacingCar", broken: false)))
toyQueue.pop()

var redToys = toyQueue.howMany(color: "red")
var blueToys = toyQueue.howMany(color: "blue")
var someColorToys = toyQueue.howMany(color: "someColor")

toyQueue[2]

var toysToFix = toyQueue.filter(){ element in element.broken == true }

print(toysToFix)
print(toyQueue)
