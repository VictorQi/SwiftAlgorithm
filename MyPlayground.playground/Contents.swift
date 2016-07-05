//: Playground - noun: a place where people can play

import UIKit

/**
 *  guard 的 happy-path 编程
 */

struct Person {
    let name: String
    var age: Int
}

struct PersonViewModel {
    var name: String?
    var age: String?
    
    enum InputError: ErrorType {
        case InputMiss
        case AgeIncorrect
    }
 
    // happy-path
    func createPerson() throws -> Person {
       
        guard let age = age, let name = name
            where name.characters.count > 0 && age.characters.count > 0 else {
                throw InputError.InputMiss
        }
        
        guard let ageFormatted = Int(age) else {
            throw InputError.AgeIncorrect
        }
        
        return Person(name: name, age: ageFormatted)
    }
}

let personModel = PersonViewModel(name: "Taylor Swift", age: "haha")

do {
    let person = try personModel.createPerson()
    print("success, person created. \(person)")
} catch PersonViewModel.InputError.InputMiss {
    print("Input Missing")
} catch PersonViewModel.InputError.AgeIncorrect {
    print("Age Incorrect!")
} catch {
    print("Sth went wrong, try again")
}


 /// flatMap 处理元素（嵌套数组中$0表示数组） 可选类型（接受一个可选类型的数组并返回一个拆包过的且没有nil值的可选类型组成的数组,或者说 处理一个容器而不是数组）

let nestedArray = [[1,2,3],[4,5,6]]

let flattenedArray = nestedArray.flatMap { $0.map {$0 * 2} }
let newFlattenedArray = nestedArray.flatMap { array in array.map { element in element * 3 } }

let imageName = (1...9).flatMap { String("minionIcon-\($0)") }

let optionalInts: [Int?] = [1, 2, nil, 4, nil, 6, 7]
let ints = optionalInts.flatMap { $0 }
for num in ints {
    print("\(num)")
}



/**
 *  struct的NSCoding
 */

struct newPerson {
    let firstName: String
    let lastName: String
    
    static func encode(person: newPerson) {
        let personClass = HelperClass(person: person)
        NSKeyedArchiver.archiveRootObject(personClass, toFile: HelperClass.path())
    }
    
    static func decode() -> newPerson? {
        let personClass = NSKeyedUnarchiver.unarchiveObjectWithFile(HelperClass.path()) as? HelperClass
        return personClass?.person
    }
}

extension newPerson {
    class HelperClass: NSObject, NSCoding {
        
        var person: newPerson?
        
        init(person: newPerson) {
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
            person = newPerson(firstName: firstName, lastName: lastName)
            
            super.init()
        }
        
        func encodeWithCoder(aCoder: NSCoder) {
            aCoder.encodeObject(person!.firstName, forKey: "firstName")
            aCoder.encodeObject(person!.lastName, forKey: "lastName")
        }
    }
}

let me = newPerson(firstName: "Victor", lastName: "Qi")
newPerson.encode(me)
let myself = newPerson.decode()
print("my name is \(myself!.firstName)-\(myself!.lastName)")

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


// MARK: - Advanced Swift

extension SequenceType {
    func findElement(match: Generator.Element -> Bool) -> Generator.Element? {
        for element in self where match(element) {
            return element
        }
        return nil
    }
    public func allMatch(predicate: Generator.Element -> Bool) -> Bool {
        // every element matches a predicate if no element doesn't match it:
        return !self.contains{ !predicate($0) }
    }
}

//The method above allows us to find all unique elements in a sequence while still maintaining the original order.
extension SequenceType where Generator.Element: Hashable {
    func unique() -> [Generator.Element] {
        var seen: Set<Generator.Element> = [] // inside closre that we pass to filter, we refer to the seen: we can access and modify it within the closure
        return filter {
            if seen.contains($0) {
                return false
            } else {
                seen.insert($0)
                return true
            }
        }
    }
}

extension Array {
    // 累加
    func accumulate<U>(initial: U, combine: (U, Element)  -> U) -> [U] {
        var running = initial
        return self.map { next in
            running = combine(running,next)
            return running
        }
    }
    func myFilter(includeElement: Element -> Bool) -> [Element] {
        var result = [Element]()
        for x in self where includeElement(x) {
            result.append(x)
        }
        return result
    }
    func myReduce<U>(initial: U, combine: (U, Element)->U)->U {
        var result = initial
        for x in self {
            result = combine(result, x)
        }
        return result
    }
    func myMap<U>(transform: Element->U) -> [U] {
        return reduce([]){
            $0 + [transform($1)]
        }
    }
    func myFilter2(includeElement: Element->Bool) -> [Element] {
        return reduce([]){
            includeElement($1) ? $0 + [$1] : $0
        }
    }
    func myFlatMap<U>(transform: Element->[U])->[U] {
        var result = [U]()
        for x in self {
            result.appendContentsOf(transform(x))
        }
        return result
    }
}

extension Dictionary {
    mutating func merge<S: SequenceType where S.Generator.Element == (Key, Value)>(other: S) {
        for (k, v) in other {
            self[k] = v
        }
    }
    init<S: SequenceType where S.Generator.Element == (Key, Value)>(_ sequence: S) {
        self = [:]
        self.merge(sequence)
    }
    func mapValues<NewValue>(transform: Value->NewValue) -> [Key: NewValue] {
        return Dictionary<Key, NewValue>(map{(key,value)in
            return (key,transform(value))
            })
    }
}

let fibs = [0,1,1,2,3,5]
let objc = fibs.accumulate(0, combine: +)
let objc2 = fibs.myMap{ $0 * $0 }.myFilter2{ $0 % 2 == 0 }
print(objc2.count)
let heheda = fibs.contains { $0 % 2 == 0 }
let gg = fibs.allMatch{ $0 % 2 == 0 }
gg ? print("nice") : print("gg")
//fibs.reduce(0){total, num in total+num}
fibs.reduce(0, combine: +)
fibs.myReduce(""){str, num in str + "\(num)\n"}

let suits = ["♠︎", "♥︎", "♣︎", "♦︎"]
let ranks = ["J","Q","K","A"]
let allCombinations = suits.flatMap{ suit in
    ranks.map { suitRank in
        (suit, suitRank)
    }
}

[1,2,3,4,5,6,7].forEach {
    element in
    print("\(element)")
}

let defaultSettings: [String: AnyObject] = [
    "Airplane Mode": true,
    "Name": "My iPhone",
]

var localizedSettings = defaultSettings
localizedSettings["Name"] = "Mein iPhone"
localizedSettings["Do Not Disturb"] = true
let oldName = localizedSettings.updateValue("My iPhone", forKey: "Name")

var settings = defaultSettings
settings.merge(localizedSettings)

let defaultAlarms = (1..<5).map{("Alarm\($0)",false)}
let alarmsDictonary = Dictionary(defaultAlarms)
//let keysAndViews = settings.mapValues{$0.settingsView()}

// GeneratorType 我们可以随意去复制generator类型的值，但是生成器是单向访问的，我们只能遍历它一次。
//因此生成器没有值语义，我们通常用类Class而不是结构体Struct来实现它。
class ConstantGenerator: GeneratorType {
//    typealias Element = Int   // specified the Element type explicitly
//    func next() -> Element? {
//        return 1
//    }
    func next() -> Int? { // specified the Element type implicitly
        return 1
    }
}

class FibsGenerator: GeneratorType {
    var state = (0,1)
    func next() -> Int? {
        let upcomingNumber = state.0
        state = (state.1, state.0+state.1)
        return upcomingNumber
    }
}

var HEHfibs = FibsGenerator()
while let x = HEHfibs.next() where x < 100 {
    print(x)
}

class PrefixGenerator: GeneratorType {
    let string: String
    var offset: String.Index
    init(string: String) {
        self.string = string
        offset = string.startIndex
    }
    
    func next() -> String? {
        guard offset < string.endIndex else { return nil }
        offset = offset.successor()
        return string[string.startIndex..<offset]
    }
}

let hehesb = PrefixGenerator(string: "nimendoushidashabi")
while let y = hehesb.next() {
    print(y)
}

// AnyGenerator type, in Swift 2.2,it switched back to being a struct.
// But is a struct that does not have value semantics,because it stores the generator it wraps in a box reference type.
let seq = 0.stride(to: 9, by: 1)
var g1 = seq.generate()
g1.next()
g1.next()
// g1 is now a generator ready to return 2
var g2 = g1   // This is because StrideToGenerator,a pretty simple struct,has value semantics
g1.next() //2
g1.next() //3
g2.next() //2
g2.next() //3

var g3 = AnyGenerator(g1)
g3.next()  //4
g1.next()  // want 5 but 4
g3.next()  // 5
g3.next()  // 6
// try to avoid making copies of generators. Always create a fresh generator when need one.

struct PrefixSequence: SequenceType {
    let string: String
    func generate() -> PrefixGenerator {
        return PrefixGenerator(string: string)
    }
}

//for prefix in PrefixSequence(string: "Hello") {
//    print(prefix)
//}
let generat = PrefixSequence(string: "Hello").generate()
while let prefix = generat.next() {
    print(prefix)
}

func fibGenerator_1() -> AnyGenerator<Int> {
    var state = (0,1)
    return AnyGenerator{
        let result = state.0
        state = (state.0, state.0+state.1)
        return result
    }
}
/**
 *  Enqueue and dequeue that both should operate in constant(O(1))time.
 */
protocol QueueType {
    associatedtype Element
    mutating func enqueue(newElement: Element)
    mutating func dequeue() -> Element?
}

struct Queue<Element>: QueueType {
    private var left: [Element]
    private var right: [Element]
    init() {
        left = []
        right = []
    }
    /**
     Add an element to the back of the queue in O(1)
     */
    mutating func enqueue(newElement: Element) {
        right.append(newElement)
    }
    /**
     Removes front of the queue in amortized O(1)
     
     - returns: nil in case of an empty queue or element
     */
    mutating func dequeue() -> Element? {
        guard !(left.isEmpty && right.isEmpty) else { return nil }
        
        if left.isEmpty {
            left = right.reverse()
            right.removeAll(keepCapacity: true)
        }
        
        return left.removeLast()
    }
}

extension Queue: CollectionType {
    var startIndex: Int { return 0 }
    var endIndex: Int { return left.count + right.count }
    
    subscript(idx: Int) -> Element {
        precondition((0..<endIndex).contains(idx), "Index out of bounds")
        if idx < left.endIndex {
            return left[left.count - idx.successor()]
        } else {
            return right[idx - left.count]
        }
    }
}

extension Queue: ArrayLiteralConvertible {
    init(arrayLiteral elements: Element...) {
        self.left = elements.reverse()
        self.right = []
    }
}

extension Queue: RangeReplaceableCollectionType {
    mutating func reserveCapacity(n: Int) {
        return
    }
    mutating func replaceRange<C : CollectionType where C.Generator.Element == Element>(subRange: Range<Int>, with newElements: C) {
        right = left.reverse() + right
        left.removeAll(keepCapacity: true)
        right.replaceRange(subRange, with: newElements)
    }
}

var q = Queue<String>()
for x in ["1","2","foo","3"] {
    q.enqueue(x)
}

for s in q { print(s) }
q.joinWithSeparator(",")
let a = Array(q)
q.map { $0.uppercaseString }
q.flatMap{ Int($0) }
q.dequeue()
print("queue index 2 is \(q[2])")
q.isEmpty
q.count
q.first
q.last
q.startIndex


/**
 *  forward-only access collection -- singlely linked list.We use an indirect enum.
 *  递归枚举
 */
enum List<Element> {
    case End
    indirect case Node(Element, next: List<Element>)  // indirect means this value here is a reference
}

protocol StackType {
    associatedtype Element
    /**
     Pushes 'x' onto the top of 'self'
     
     - Complexity: Amortized O(1)
     */
    mutating func push(x: Element)
    /**
     Removes the topmost element of 'self' and returen it,
     or 'nil' if 'self' is empty.
     
     - Complexity: O(1)
     */
    mutating func pop() -> Element?
}

extension List: StackType {
    // return a new list by prepending(前置) a node with value 'x' to 
    // the front of a list.
    func cons(x: Element) -> List {
        return .Node(x, next: self)
    }
    
    // These mutaing method don't change the list.They just change the part of the list the variables refer to.
    mutating func push(x: Element) {
        self = self.cons(x)
    }
    
    mutating func pop() -> Element? {
        switch self {
        case .End: return nil
        case let .Node(x, next: xs):
            self = xs
            return x
        }
    }
}

// a 3-element list, of (3,2,1) 
// it is "persistent".Nodes are immutable - once create, you can not change them.
// Consing another element onto list doesn't copy the list; it just gives you a new node 
// that links onto the front of the existing list.
// This means two lists can share a tail.
let l = List<Int>.End.cons(1).cons(2).cons(3)

var listStack = List<Int>.End.cons(1).cons(2).cons(3)
var aList = listStack
var bList = listStack

aList.pop()
aList.pop()
aList.pop()

listStack.pop()
listStack.push(4)

bList.pop()
bList.pop()
bList.pop()

listStack.pop()
listStack.pop()
listStack.pop()


