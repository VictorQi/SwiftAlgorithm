//: Playground - noun: a place where people can play

import UIKit

/**
 *  BitSet 位组，小端模式存放，内存高地址保存数据的高字节数据
 */
public struct BitSet {
    private(set) public var size: Int
    
    private let N = 64
    public typealias Word = UInt64
    private(set) public var words: [Word]
    
    public init(size: Int) {
        precondition(size > 0)
        self.size = size
        
        let n = (size + (N-1)) / N
        words = .init(count: n,repeatedValue: 0)
    }
    
    /**
     find which word contains that bit
     
     - parameter i: the index of the bit
     
     - returns: the array index of the word,as well as a "mask" that shows exactly where the bit sits inside that word
     */
    private func indexOf(i: Int) -> (Int, Word) {
        precondition(i>=0)
        precondition(i<size)
        let o = i/N
        let m = Word(i - o*N)
        return (o, 1<<m)
    }
    
    /**
     This looks up the word index and the mask, then performs a bitwise OR between that word and the mask. bit 0 -> 1
     
     - parameter i: the index of the bit
     */
    public mutating func set(i: Int) {
        let (j, m) = indexOf(i)
        words[j] |= m
    }
    
    public mutating func clear(i: Int) {
        let (j, m) = indexOf(i)
        words[j] &= ~m
    }
    
    public func isSet(i: Int) -> Bool {
        let (j, m) = indexOf(i)
        return (words[j] & m) != 0
    }
    
    public subscript(i: Int) -> Bool {
        get {
            return isSet(i)
        }
        set {
            if newValue {
                set(i)
            } else {
                clear(i)
            }
        }
    }
    
    public mutating func flip(i: Int) -> Bool {
        let (j, m) = indexOf(i)
        words[j] ^= m
        return (words[j] & m) != 0
    }
    
    private func lastWordMask() -> Word {
        let diff = words.count*N - size  // leftover bits
        if diff > 0 {
            let mask = 1 << Word(63 - diff) //a mask is all 0's, except the highest bit
            return mask | (mask - 1)  //mask最高位之后全变为1，最高位变0
        } else {
            return ~Word()
        }
    }
    
    private mutating func clearUnusedBits() {
        words[words.count - 1] &= lastWordMask()
    }
}
