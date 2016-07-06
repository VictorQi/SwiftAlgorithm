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





