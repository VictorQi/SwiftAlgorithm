//: Playground - noun: a place where people can play

import UIKit

// MARK: Swift Language

/**
 *  嵌套函数
 */

func chooseStepFunction(backwards: Bool) -> (Int) -> Int {
    func stepForwards(Input: Int) -> Int {return Input+1}
    func stepBackwards(Input: Int) -> Int {return Input-1}
    return backwards ? stepBackwards : stepForwards
}

var currentValue = -4
let moveFunc = chooseStepFunction(currentValue>0)
while currentValue != 0 {
    print("current value is \(currentValue)")
    currentValue = moveFunc(currentValue)
}
print("current value is 0")


/**
 *  函数闭包
 */
let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
//闭包表达式语法
//var reverse = names.sort({ (s1: String, s2: String) -> Bool in return s1 > s2 })
//根据上下文推断类型
//var reverse = names.sort({ s1, s2 in return s1 > s2})
//单表达式隐式返回
//var reverse = names.sort({ s1, s2 in s1 > s2})
//运算符函数
//var reverse = names.sort(>)
//参数名称缩写，in关键字也被省略，因为此时闭包表达式完全由函数体组成
//var reverse = names.sort({ $0 > $1 })
//尾随闭包
var reverse = names.sort() { $0 > $1 }  //或者 var reverse = names.sort { $0 > $1 }
for name in reverse {
    print("\(name)")
}

let digitNames = [
    0: "Zero", 1: "One", 2: "Two", 3: "Three",
    4: "Four", 5: "Five", 6: "Six", 7: "Seven",
    8: "Eight", 9: "Nine"
]

let numbers = [168, 57, 320]

let strings = numbers.map {
    (var number) -> String in
    var outPut = ""
    while number > 0 {
        outPut = digitNames[number % 10]! + outPut
        number /= 10
    }
    return outPut
}

class Vehicle {
    var numberOfWheels = 0
    var description: String {
        return "\(numberOfWheels) wheel(s)";
    }
}

let vehicle = Vehicle()
print("Vehicle: \(vehicle.description)")

class Bicycle: Vehicle {
    override init() {
        super.init()
        numberOfWheels = 2
    }
}

let bycle = Bicycle()
print("Bicycle: \(bycle.numberOfWheels)")

class Food {
    var name: String
    init (name: String) {
        self.name = name
    }
    convenience init () {
        self.init(name: "[Unnamed]")
    }
}

let nameMeat = Food(name: "Bacon")
let mysteryMeat = Food()

class RecipeIngredient: Food {
    var quatity: Int
    init (name: String, quatity: Int) {
        self.quatity = quatity
        super.init(name: name)
    }
    convenience override init(name: String) {
        self.init (name: name, quatity: 1)
    }
}

let oneMeat = RecipeIngredient()
let twoMeat = RecipeIngredient(name: "Pork")
let threeMeat = RecipeIngredient(name: "Eggs", quatity: 6)

class FoodList: RecipeIngredient {
    var purchased = false
    var description: String {
        var output = "\(quatity) x \(name)"
        output += purchased ? "✓" : "𐄂"
        return output
    }
}

var breakfastList = [
    FoodList(),
    FoodList(name: "Bacon"),
    FoodList(name: "Egg", quatity: 5)
]

breakfastList[0].name = "Orange juice"
breakfastList[0].purchased = true
for item in breakfastList {
    print(item.description)
}

struct Animal {
    let species: String
    init?(species: String) {
        if species.isEmpty { return nil }
        self.species = species
    }
}

let someCreature = Animal(species: "Giraffe")
// someCreature 类型是Animal？而不是Animal

if let giraffe = someCreature {
    print("An animal was initialized with a species of \(giraffe.species)")
}

let anonymousCreature = Animal(species: "")
if anonymousCreature == nil {
    print("create species failed")
}

// 枚举的可失败构造器
enum TemperatureUnit: Character {
    case Kelvin = "K", Celsius = "C", Fahrenheit = "F"
    //    init?(sysmbol: Character) {
    //        switch sysmbol {
    //        case "K":
    //            self = .Kelvin
    //        case "C":
    //            self = .Celsius
    //        case "F":
    //            self = .Fahrenheit
    //        default:
    //            return nil
    //        }
    //    }
}

let fahrenheitUnit = TemperatureUnit(rawValue: "F")
if let item = fahrenheitUnit {
    print("This is a defined temperature unit, so initialization succeeded")
}
let unknownUnit = TemperatureUnit(rawValue: "X")
if unknownUnit == nil {
    print("This is not a defined temperature unit, so initialization failed")
}

// 可失败构造器的传递
class Product {
    let name: String
    init?(name: String) {
        if name.isEmpty { return nil }
        self.name = name
    }
}

class CarItem: Product {
    let quantity: Int
    init?(name: String, quantity: Int) {
        if quantity < 1 { return nil }
        self.quantity = quantity
        super.init(name: name)
    }
}

if let twoSocks = CarItem(name: "sock", quantity: 2) {
    print("Item: \(twoSocks.name), quantity: \(twoSocks.quantity)")
}


if let zeroShirts = CarItem(name: "shirt", quantity: 0) {
    print("Item: \(zeroShirts.name), quantity: \(zeroShirts.quantity)")
} else {
    print("Unable to initialize zero shirts")
}

if let oneUnnamed = CarItem(name: "", quantity: 1) {
    print("Item:\(oneUnnamed.name),quantity:\(oneUnnamed.quantity)")
} else {
    print("Unable to initialize")
}

class Document {
    var name: String?
    init() {}
    init?(name: String) {
        if name.isEmpty { return nil }
        self.name = name
    }
}

class AutomaticallyNamedDocument: Document {
    override init() {
        super.init()
        self.name = "[Untitled]"
    }
    override init?(name: String) {
        super.init()
        if name.isEmpty {
            self.name = "[Untitled]"
        } else {
            self.name = name
        }
    }
}

struct BlackjackCard {
    enum Suit: Character {
        case Spades = "♠", Hearts = "♡", Diamonds = "♢", Clubs = "♣"
    }
    
    enum Rank: Int {
        case Two = 2, Three, Four, Five, Six, Seven, Eight, Nine, Ten
        case Jack, Queen, King, Ace
        struct Value {
            let first: Int, second: Int?
        }
        var values: Value {
            switch self {
            case .Ace:
                return Value(first: 1, second: 11)
            case .Jack, .Queen, .King:
                return Value(first: 10, second: nil)
            default:
                return Value(first: self.rawValue, second: nil)
            }
        }
    }
    
    // BlackjackCard 的属性和方法
    let rank: Rank, suit: Suit
    var description: String {
        var output = "suit is \(suit.rawValue),"
        output += " value is \(rank.values.first)"
        if let second = rank.values.second {
            output += " or \(second)"
        }
        return output
    }
}

let heartAce = BlackjackCard(rank: .Ace, suit: .Hearts)
print(heartAce.description)
let heartSymbol = BlackjackCard.Suit.Hearts.rawValue

// 扩展
extension Double {
    var km: Double { return self * 1_000.0 }
    var m : Double { return self }
    var cm: Double { return self / 100.0 }
    var mm: Double { return self / 1_000.0 }
    var ft: Double { return self / 3.28084 }
}

let oneInch = 25.4.mm
print("One inch is \(oneInch) meters")

let aMarathon = 42.km + 195.m
print("A marathon is \(aMarathon.m) meters long")

extension Int {
    func repetitions(task: () -> Void) {
        for _ in 0..<self {
            task()
        }
    }
    
    mutating func square() {
        self = self * self
    }
    
    subscript(digitIndex: Int) -> Int {
        var decimalBase = 1
        for _ in 0..<digitIndex {
            decimalBase *= 10
        }
        return (self / decimalBase) % 10
    }
}

3.repetitions {
    print("Hello")
}

var someInts = 3
someInts.square()

746381295[5]
746381295[9]

protocol RandomNumberGenerator {
    func random() -> Double
}

class LinearCongruentialGenerator: RandomNumberGenerator {
    var lastRandom = 42.0
    let m = 139968.0
    let a = 3877.0
    let c = 29573.0
    func random() -> Double {
        lastRandom = ((lastRandom * a + c) % m)
        return lastRandom / m
    }
}

let generator = LinearCongruentialGenerator()
print("Here's a random number: \(generator.random())")

protocol Togglable {
    mutating func toggle()
}

enum OnOffSwitch: Togglable {
    case Off, On
    mutating func toggle() {
        switch self {
        case Off:
            self = On
        case On:
            self = Off
        }
    }
}

var lightSwitch = OnOffSwitch.Off
lightSwitch.toggle()

class Dice {
    let side: Int
    let generator: RandomNumberGenerator
    init(side: Int, generator: RandomNumberGenerator) {
        self.side = side
        self.generator = generator
    }
    func roll() -> Int {
        return Int(generator.random() * Double(side)) + 1
    }
}

var d6 = Dice(side: 6, generator: LinearCongruentialGenerator())
for _ in 1...5 {
    print("Random dice roll is \(d6.roll())")
}

protocol DiceGame {
    var dice: Dice { get }
    func play()
}

protocol DiceGameDelegate {
    func gameDidStart(game: DiceGame)
    func game(game: DiceGame, didStartNewTurnWithDiceRoll diceRoll:Int)
    func gameDidEnded(game: DiceGame)
}

class SnakeAndLadders: DiceGame {
    let finalSquares = 25
    let dice = Dice(side: 6, generator: LinearCongruentialGenerator())
    var square = 0
    var board: [Int]
    init() {
        board = [Int](count: finalSquares+1, repeatedValue: 0)
        board[03] = +08; board[06] = +11; board[09] = +09; board[10] = +02
        board[14] = -10; board[19] = -11; board[22] = -02; board[24] = -08
    }
    var delegate: DiceGameDelegate?
    func play() {
        square = 0
        delegate?.gameDidStart(self)
        gameLoop: while square != finalSquares {
            let didRoll = dice.roll()
            delegate?.game(self, didStartNewTurnWithDiceRoll: didRoll)
            switch square+didRoll {
            case finalSquares:
                break gameLoop
            case let newSquare where newSquare > finalSquares:
                continue gameLoop
            default:
                square += didRoll
                square += board[square]
            }
        }
        delegate?.gameDidEnded(self)
    }
}

class DiceGameTracker: DiceGameDelegate {
    var numberOfTurns = 0
    func gameDidStart(game: DiceGame) {
        numberOfTurns = 0
        if game is SnakeAndLadders {
            print("Started a new game of Snakes and Ladders")
        }
        print("The game is using a \(game.dice.side)-sided dice")
    }
    func game(game: DiceGame, didStartNewTurnWithDiceRoll diceRoll: Int) {
        numberOfTurns += 1
        print("Rolled a \(diceRoll)")
    }
    func gameDidEnded(game: DiceGame) {
        print("The game lasted for \(numberOfTurns) turns")
    }
}

let tracker = DiceGameTracker()
let game = SnakeAndLadders()
game.delegate = tracker
game.play()

func swapTwoValues<T>(inout a: T, inout _ b: T) {
    let tempA = a
    a = b
    b = tempA
}

var someInt = 3
var anotherInt = 107
swapTwoValues(&someInt, &anotherInt)

var someString = "hello"
var anotherString = "world"
swapTwoValues(&someString, &anotherString)

struct Stack<Element> {
    var items = [Element]()
    mutating func push(item: Element) {
        items.append(item)
    }
    mutating func pop() -> Element {
        return items.removeLast()
    }
}

extension Stack {
    var topItem: Element? {
        return items.isEmpty ? nil : items[items.count - 1]
    }
}

var stackOfStrings = Stack<String>()
stackOfStrings.push("uno")
stackOfStrings.push("dos")
stackOfStrings.push("tres")
stackOfStrings.push("cuatro")
print(stackOfStrings.pop())
print(stackOfStrings.pop())
if let topItem = stackOfStrings.topItem {
    print("The top item on the stack is \(topItem).")
}

func findIndex<T: Equatable>(of valueToFind: T, inArray array: [T]) -> Int? {
    for (index, value) in array.enumerate() {
        if value == valueToFind {
            return index
        }
    }
    return nil
}

let heheStrings = ["cat", "dog", "llama", "parakeet", "terrapin"]
if let foundIndex = findIndex(of: "llama", inArray: heheStrings) {
    print("The index of llama is \(foundIndex)")
}

protocol Container {
    associatedtype ItemType
    mutating func append(item: ItemType)
    var count: Int { get }
    subscript(i: Int) -> ItemType{ get }
}

struct IntStack: Container {
    var items = [Int]()
    mutating func push(item: Int) {
        items.append(item)
    }
    mutating func pop() -> Int {
        return items.removeLast()
    }
    
    // conformance to the Container protocol
    typealias ItemType = Int
    mutating func append(item: ItemType) {
        self.push(item)
    }
    var count: Int {
        return items.count
    }
    subscript(i: Int) -> Int {
        return items[i]
    }
}

struct Person {
    let firstName: String
    let lastName: String
    
    static func encode(person: Person) {
        let personClassObjct = HelperClass(person: person)
        
        NSKeyedArchiver.archiveRootObject(personClassObjct, toFile: HelperClass.path())
    }
    
    static func decode() -> Person? {
        let personObject = NSKeyedUnarchiver.unarchiveObjectWithFile(HelperClass.path()) as? HelperClass
        
        return personObject?.person
    }
}

extension Person {
    class HelperClass: NSObject, NSCoding {
        var person: Person?
        
        init(person: Person) {
            self.person = person
            super.init()
        }
        
        class func path() -> String {
            let documentsPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).first
            let path = documentsPath?.stringByAppendingString("/Person")
            return path!
        }
        
        required init?(coder aDecoder: NSCoder) {
            guard let firstName = aDecoder.decodeObjectForKey("firstName") as? String else {
                person = nil
                super.init()
                return nil
            }
            
            guard let lastName = aDecoder.decodeObjectForKey("lastName") as? String else {
                person = nil
                super.init()
                return nil
            }
            
            person = Person(firstName: firstName, lastName: lastName)
            
            super.init()
        }
        
        func encodeWithCoder(aCoder: NSCoder) {
            aCoder.encodeObject(person!.firstName,forKey: "firstName")
            aCoder.encodeObject(person!.lastName,forKey: "lastName")
        }
    }
}

let me = Person(firstName: "Victor", lastName: "Qi")
Person.encode(me)

let myClone = Person.decode()

print("me \(myClone?.firstName) and \(myClone?.lastName)")

func alignRight(var string: String, totalLength: Int, pad: Character) -> String {
    let amountToPad = totalLength - string.characters.count
    if amountToPad < 1 {
        return string
    }
    let padString = String(pad)
    for _ in 1...amountToPad {
        string = padString + string
    }
    return string
}

let orignString = "hello!"
let padString = alignRight(orignString, totalLength: 10, pad: "-")


func swapTwoInts(inout a: Int, inout _ b: Int) {
    let temp = a
    a = b
    b = temp
}

var someInt = 3
var anotherInt = 5
swapTwoInts(&someInt, &anotherInt)
print("someInt is \(someInt), anotherInt is \(anotherInt)")


/**
 *  非逃逸闭包
 */
func someFunctionWithNoEscapeClosure(@noescape closure: () -> Void) {
    closure()
}

var completionHandlers: [() -> Void] = []
func someFunctionWithEscapeClosure(closure: () -> Void ) {
    completionHandlers.append(closure)
}

class someClass {
    var x = 10
    func doingSomething() {
        print("now we are beyond all closures")
        someFunctionWithEscapeClosure { self.x = 100; print("enter into escape closure")}
        print("we are in the middle of two closures")
        someFunctionWithNoEscapeClosure { x = 200; print("enter into no escape closure")}
        print("we are in the end of functions")
    }
}

let instance = someClass()
instance.doingSomething()
print(instance.x)

completionHandlers.first?()
print(instance.x)

/// 自动闭包 闭包不被调用，则闭包中的表达式将永远不会被执行
var customLine = ["Alex", "Chris", "Betty", "Daniella", "Ewa"]
print(customLine.count)

let customProvider = { customLine.removeAtIndex(0) }
print(customLine.count)

print("\(customProvider()) is been removed")
print(customLine.count)
// @autoclosure自带@noescape特性
func serverCustomer(@autoclosure customerProvider: () -> String) {
    print("\(customerProvider()) is been removed")
}

serverCustomer(customLine.removeAtIndex(0))
print(customLine.count)
// 自动闭包希望能够逃逸 则需要 @autoclosure(escaping)
var customerProviders: [() -> String] = []
func collectionCustomerProviders (@autoclosure(escaping) customerprovider: () -> String) {
    customerProviders.append(customerprovider)
}

collectionCustomerProviders(customLine.removeAtIndex(0))
collectionCustomerProviders(customLine.removeAtIndex(0))
print(customLine.count)

print("colleted \(customerProviders.count) closure")

class SomeClass {
    static var storedProperty = "Some Value"
    static var computedProperty: Int {
        return 1
    }
    class var overrideableComputedProperty: Int {
        return 107
    }
}

struct AudioChannel {
    static let thresholdLevel = 10
    static var maxInputForAllChannel = 0
    var currentLevel: Int {
        didSet {
            if currentLevel > AudioChannel.thresholdLevel {
                currentLevel = AudioChannel.thresholdLevel
            }
            if currentLevel > AudioChannel.maxInputForAllChannel {
                AudioChannel.maxInputForAllChannel = currentLevel
            }
        }
    }
}

var newAudioInput = AudioChannel(currentLevel: 50)
print("current level is \(newAudioInput.currentLevel)")
print("AudioChannel maxInputForAllChannel is \(AudioChannel.maxInputForAllChannel)")

struct MyPoint {
    var x = 0.0, y = 0.0
    mutating func moveByX(deltaX: Double, deltaY: Double) {
        x += deltaX
        y += deltaY
    }
}

var somePoint = MyPoint(x: 1.0, y: 1.0)
somePoint.moveByX(4.0, deltaY: 3.0)
print("x = \(somePoint.x), y = \(somePoint.y)")

enum TriStateSwitch {
    case Off, Low, High
    mutating func next() {
        switch self {
        case Off:
            self = Low
        case Low:
            self = High
        case High:
            self = Off
        }
    }
}

var overLight = TriStateSwitch.Low
overLight.next()
overLight.next()

struct LevelTracker {
    static var highestUnlockedLevel = 1
    static func unlockedLevel(level: Int) {
        if level > highestUnlockedLevel {
            highestUnlockedLevel = level
        }
    }
    static func levelIsUnlocked(level: Int) -> Bool {
        return level <= highestUnlockedLevel
    }
    var currentLevel = 1
    mutating func advanceToLevel(level: Int) -> Bool {
        if LevelTracker.levelIsUnlocked(level) {
            currentLevel = level
            return true
        } else {
            return false
        }
    }
}

class Player {
    var tracker = LevelTracker()
    let playerName: String
    func completedLevel(level: Int) {
        LevelTracker.unlockedLevel(level + 1)
        tracker.advanceToLevel(level + 1)
    }
    init(name: String) {
        playerName = name
    }
}

// 重写可失败构造器
class Document {
    var name: String?
    init() {}
    init?(name: String) {
        if name.isEmpty { return nil}
        self.name = name
    }
}

class AutomaticallyNamedDocument: Document {
    override init() {
        super.init()
        self.name = "[Untitled]"
    }
    override init?(name: String) {
        super.init()
        if name.isEmpty {
            self.name = "[Untitled]"
        } else {
            self.name = name
        }
    }
}

class UntitledDocument: Document {
    override init() {
        super.init(name: "[Untitled]")!
    }
}

let document = UntitledDocument()
print("\(document.name)")


// 通过闭包或者函数设置属性的默认值
struct Checkerboard {
    let boardColors: [Bool] = {
        var tempBoard = [Bool]()
        var isBlack = false
        for i in 1...8 {
            for j in 1...8 {
                tempBoard.append(isBlack)
                isBlack = !isBlack
            }
            isBlack = !isBlack
        }
        return tempBoard
    }()
    
    func squareIsBlackAtRow(row: Int, column: Int) -> Bool {
        return boardColors[(row * 8) + column]
    }
}

let board = Checkerboard()
print(board.squareIsBlackAtRow(0, column: 1))
print(board.squareIsBlackAtRow(7, column: 1))

// 析构器 析构器是在实例释放发生之前被自动调用的，你不能主动调用析构器。
//       子类继承父类的析构器，并在子类析构器实现的最后，父类的析构器会被自动调用，即使子类没提供析
//       构器 直到实例的析构器被调用之后，实例才被释放，所以析构器能访问实例的所有属性
class Bank {
    static var coinsInBank = 10_000
    static func vendCoins(numberOfCoinsRequested: Int) -> Int {
        let numberOfCoinsToVend = min(numberOfCoinsRequested, coinsInBank)
        coinsInBank -= numberOfCoinsToVend
        return numberOfCoinsToVend
    }
    static func receiveCoins(coins: Int) {
        coinsInBank += coins
    }
}

class BankerPlayer {
    var coinsInPurse: Int
    init(coins: Int) {
        coinsInPurse = Bank.vendCoins(coins)
    }
    func winCoins(coins: Int) {
        coinsInPurse += Bank.vendCoins(coins)
    }
    deinit {
        Bank.receiveCoins(coinsInPurse)
    }
}

var playerOne: BankerPlayer? = BankerPlayer(coins: 100)
print("A new player has joined the game with \(playerOne!.coinsInPurse) coins")
print("There are now \(Bank.coinsInBank) coins left in the bank")
playerOne!.winCoins(2_000)
print("PlayerOne won 2000 coins & now has \(playerOne!.coinsInPurse) coins")
print("There are now \(Bank.coinsInBank) coins left in the bank")
playerOne = nil
print("PlayerOne has left the game")
print("There are now \(Bank.coinsInBank) coins left in the bank")


// 闭包的循环引用
// 在闭包和捕获的实例总是互相引用并且总是同时销毁时，将闭包内的捕获定义为无主引用
// 在被捕获的引用可能会变为nil时，将闭包内的捕获定义为弱引用。弱引用总是可选类型
class HTMLElement {
    let name: String
    let text: String?
    lazy var asHTML: Void -> String =  {
        [unowned self] in
        if let text = self.text {
            return "<\(self.name)>\(text)</\(self.name)>"
        } else {
            return "<\(self.name) />"
        }
    }
    
    init(name: String, text: String? = nil) {
        self.name = name
        self.text = text
    }
    
    deinit {
        print("\(name) is being deinitialized")
    }
}

let heading = HTMLElement(name: "h1")
let defaultText = "some default text"
heading.asHTML = {
    return "<\(heading.name)>\(heading.text ?? defaultText)</\(heading.name)>"
}
print(heading.asHTML())

var paragraph: HTMLElement? = HTMLElement(name: "p", text: "hello, world")
print(paragraph!.asHTML())
paragraph = nil


// 可选链式调用
class Prisoner {
    var residence: Residence?
}

class Residence {
    var rooms = [Room]()
    var numberOfRooms: Int {
        return rooms.count
    }
    subscript(i: Int) -> Room {
        get {
            return rooms[i]
        }
        set {
            rooms[i] = newValue
        }
    }
    func printNumberOfRooms() {
        print("The number of rooms is \(numberOfRooms)")
    }
    var address: Address?
}

class Room {
    let name: String
    init(name: String) { self.name = name }
}

class Address {
    var buildingName: String?
    var buildingNumber: String?
    var street: String?
    func buildingIdentifier() -> String? {
        if buildingName != nil {
            return buildingName
        } else if buildingNumber != nil && street != nil {
            return "\(buildingNumber) \(street)"
        } else {
            return nil
        }
    }
}

let jhon = Prisoner()
if let roomCount = jhon.residence?.numberOfRooms {
    print("John's residence has \(roomCount) room(s).")
} else {
    print("Unable to retrieve the number of rooms.")
}

func createAddress() -> Address {
    print("Create Address")
    
    let someAddress = Address()
    someAddress.buildingNumber = "29"
    someAddress.street = "Zhongshan Road"
    
    return someAddress
}

//jhon.residence?.address = createAddress()

if jhon.residence?.printNumberOfRooms() != nil {
    print("It was possible to print the number of rooms.")
} else {
    print("It was not possible to print the number of rooms.")
}

if (jhon.residence?.address = createAddress()) != nil {
    print("It was possible to set the address.")
} else {
    print("It was not possible to set the address.")
}

let johnsHouse = Residence()
johnsHouse.rooms.append(Room(name: "Living Room"))
johnsHouse.rooms.append(Room(name: "Kitchen"))
jhon.residence = johnsHouse

if let firstRoomName = jhon.residence?[0].name {
    print("The first room name is \(firstRoomName).")
} else {
    print("Unable to retrieve the first room name.")
}

// 访问可选类型的下标
var testStores = ["Dave": [82,88,87], "Bev": [79, 94, 81]]
testStores["Dave"]?[0] = 91
testStores["Bev"]?[0] += 8
testStores["Vic"]?[0] = 53

// 错误处理
enum VendingMachineError: ErrorType {
    case InvalidSelection                       //选择无效
    case InsufficientFunds(coinsNeeded: Int)    //金额不足
    case OutOfStock                             // 缺货
}


struct Item {
    var price: Int
    var count: Int
}

class VendingMachine {
    var inventory = [
        "Candy Bar": Item(price: 12, count: 7),
        "Chips": Item(price: 10, count: 4),
        "Pretzels": Item(price: 7, count: 11)
    ]
    var coinsInDeposited = 0
    func dispenseSnack(snack: String) {
        print("Dispensing \(snack)")
    }
    func vend(itemName name: String) throws {
        guard let item = inventory[name] else {
            throw VendingMachineError.InvalidSelection
        }
        guard item.count > 0 else {
            throw VendingMachineError.OutOfStock
        }
        guard item.price <= coinsInDeposited else {
            throw VendingMachineError.InsufficientFunds(coinsNeeded: item.price - coinsInDeposited)
        }
        
        coinsInDeposited -= item.price
        
        var newItem = item
        newItem.count = 1
        inventory[name] = newItem
        
        dispenseSnack(name)
    }
    
}

let favoriteSnacks = [
    "Alice": "Chips",
    "Bob": "Licorice",
    "Eve": "Pretzels"
]

func buyFavoriteSnack(person: String, vendingMachine: VendingMachine) throws {
    let snackName = favoriteSnacks[person] ?? "Candy Bar"
    try vendingMachine.vend(itemName: snackName)
}

struct PurchasedSnack {
    let name: String
    init(name: String, vendingMachine: VendingMachine) throws {
        try vendingMachine.vend(itemName: name)
        self.name = name
    }
}

var vendingMachine = VendingMachine()
vendingMachine.coinsInDeposited = 12
do {
    try buyFavoriteSnack("Alice", vendingMachine: vendingMachine)
} catch VendingMachineError.InvalidSelection {
    print("Invalid Selection")
} catch VendingMachineError.OutOfStock {
    print("Out Of Stock")
} catch VendingMachineError.InsufficientFunds(let coinsNeeded) {
    print("Insufficient funds. Please insert an additional \(coinsNeeded) coins.")
}

// 类型转换
class MediaItem {
    var name: String
    init(name: String) {
        self.name = name
    }
}

class Movie: MediaItem {
    var director: String
    init(name: String, director: String) {
        self.director = director
        super.init(name: name)
    }
}

class Song: MediaItem {
    var artist: String
    init(name: String, artist: String) {
        self.artist = artist
        super.init(name: name)
    }
}

let library = [
    Movie(name: "Casablanca", director: "Michael Curtiz"),
    Song(name: "Blue Suede Shoes", artist: "Elvis Presley"),
    Movie(name: "Citizen Kane", director: "Orson Welles"),
    Song(name: "The One And Only", artist: "Chesney Hawkes"),
    Song(name: "Never Gonna Give You Up", artist: "Rick Astley")
]

var movieCount = 0, songCount = 0
for item in library {
    if item is Movie {
        movieCount += 1
    } else if item is Song {
        songCount += 1
    }
}
print("Media library contains \(movieCount) movies and \(songCount) songs")

for item in library {
    if let movie = item as? Movie {
        print("Movie: '\(movie.name)', dir. \(movie.director)")
    } else if let song = item as? Song {
        print("Song: '\(song.name)', by \(song.artist)")
    }
}

var things = [Any]()

things.append(0)
things.append(0.0)
things.append(42)
things.append(3.14159)
things.append("hello")
//let purple: (Double, Double) = (3.0, 5.0)
//things.append(purple)
things.append(Movie(name: "Ghostbusters", director: "Ivan Reitman"))
things.append({ (name: String) -> String in "Hello, \(name)" })
for thing in things {
    switch thing {
    case 0 as Int:
        print("zero as an Int")
    case 0 as Double:
        print("zero as a Double")
    case let someInt as Int:
        print("an integer value of \(someInt)")
    case let someDouble as Double where someDouble > 0:
        print("a positive double value of \(someDouble)")
    case is Double:
        print("some other double value that I don't want to print")
    case let someString as String:
        print("a string value of \"\(someString)\"")
    case let (x, y) as (Double, Double):
        print("an (x, y) point at \(x), \(y)")
    case let movie as Movie:
        print("a movie called '\(movie.name)', dir. \(movie.director)")
    case let stringConverter as String -> String:
        print(stringConverter("Michael"))
    default:
        print("something else")
    }
}

@objc protocol CounterDataSource {
    optional func incrementForCount(count: Int) -> Int
    optional var fixedIncrement: Int { get }
}

class Counter {
    var count = 0
    var dataSource: CounterDataSource?
    func increment() {
        if let amount = dataSource?.incrementForCount?(count) {
            count += amount
        } else if let amount = dataSource?.fixedIncrement {
            count += amount
        }
    }
}

class ThreeSource: NSObject, CounterDataSource {
    let fixedIncrement = 3
}

@objc class TowardsZeroSource: NSObject, CounterDataSource {
    func incrementForCount(count: Int) -> Int {
        if count == 0 {
            return 0
        } else if count < 0 {
            return 1
        } else {
            return -1
        }
    }
}

var counter = Counter()
counter.dataSource = ThreeSource()
for _ in 1...4 {
    counter.increment()
    print(counter.count)
}

counter.count = -4
counter.dataSource = TowardsZeroSource()
for _ in 1...5 {
    counter.increment()
    print(counter.count)
}