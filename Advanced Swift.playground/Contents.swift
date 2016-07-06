//: Playground - noun: a place where people can play

import UIKit

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
    func myEnumerate() -> AnySequence<(Int, Generator.Element)> {
        // Swift 在这个闭包中需要一个类型推断帮手
        return AnySequence { _ -> AnyGenerator<(Int, Generator.Element)> in
            // 新建一个新的计数器和生成器，并开始枚举
            var i = 0
            var g = self.generate()
            // 在闭包中捕获这些变量并在一个新的生成器中返回他们
            return AnyGenerator {
                //当读到原始序列末尾时返回nil
                guard let next = g.next() else { return nil }
                let result = (i,next)
                i += 1
                return result
            }
        }
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

//所有的push，pop操作只是改变了listStack，aList，bList对于整个链表节点的引用，而链表实际上并没有发生改变
//但是基于ARC的内存管理模式，一旦某一节点不再有变量持有它时，它所占的内存区域就可以被释放。

extension List: SequenceType, ArrayLiteralConvertible {
    func generate() -> AnyGenerator<Element> {
        // 声明一个变量用来捕捉self的状态，通过这个变量进行迭代
        var current = self
        return AnyGenerator {
            // next()方法将会调用pop()，当列表为空时返回nil
            current.pop()
        }
    }
    
    init(arrayLiteral elements: Element...) {
        self = elements.reverse().reduce(.End) {$0.cons($1)}
    }
}

let heheList: List = ["1","2","3"]
for x in heheList {
    print("\(x)", separator: ",", terminator: "")
}

heheList.joinWithSeparator("!")
heheList.contains("2")
heheList.flatMap {Int($0)}
heheList.elementsEqual(["1","2","3"])

/**
 隐藏list集合的实现细节,默认构造器ListIndex(node:tag:)并不能被用户访问
 */
private enum ListNode<Element> {
    case End
    indirect case Node(Element, next: ListNode<Element>)
    
    func cons(x: Element) -> ListNode<Element> {
        // 每次cons都会使tag加1
        return .Node(x, next: self)
    }
}

public struct ListIndex<Element> {
    private let node: ListNode<Element>
    //在同一list中，如果两个index对应的tag值相同，那么他们的index也必定相同。
    private let tag: Int
}

extension ListIndex: ForwardIndexType {
    public func successor() -> ListIndex<Element> {
        switch node {
        case let .Node(_, next: next):
            return ListIndex(node: next, tag: tag.predecessor())
        case .End:
            fatalError("Cannot increment endIndex")
        }
    }
}

public func ==<T>(lhs: ListIndex<T>, rhs: ListIndex<T>) -> Bool {
    return lhs.tag == rhs.tag
}

// MARK - 这部分代码有问题

//public struct NewList<Element>: CollectionType {
//    // index的类型推断出来，但这可以使得剩下的代码更加明了
//    public typealias index = ListNode<Element>
//    
//    public var startIndex: Index
//    public var endIndex: Index
//    
//    public subscript(idx: Index) -> Element {
//        switch idx.node {
//        case .End: fatalError("Subscript out of range")
//        case let .Node(x, _): return x
//        }
//    }
//}
//
//extension NewList: ArrayLiteralConvertible {
//    public init(arrayLiteral elements: Element...) {
//        startIndex = ListIndex(node: elements.reverse().reduce(.End){
//            $0.cons($1)
//            },tag: elements.count)
//        endIndex = ListIndex(node: .End, tag: 0)
//    }
//}
//
//let fuckList: NewList = ["One", "Two", "Three"]
//fuckList.first
//fuckList.indexOf("Two")
