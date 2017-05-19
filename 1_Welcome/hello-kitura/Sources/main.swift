import Kitura
import HeliumLogger




HeliumLogger.use()
let router = Router()

//router.all { (request, response, next) in
//    response.send("Hello World")
//    try response.end()
//}


//router.get("hello") { (request, response, next) in
//    response.send("How are you?")
//    try response.end()
//}


//MARK: working with json
router.get("hello") { (request, response, next) in
    
    let result = [["status": "ok", "message": "hello world"],["status": "ok", "message": "waddup?"]]
    
    response.send(json: ["result": result])
    try response.end()
}


router.post { (request, response, _) in
    
}

//MARK: working with classes
//In this example, the protocol defines a Person struct as being of serializable type. Then an extension is being created for Sequence in the case that its elements conform to the protocol. Finally I can call toDict() on an array of Person objects.

protocol Serializable {
    func toDict() -> [String: Any]
}

struct Person: Serializable {
    var name: String
    var age: Int
    
    func toDict() -> [String: Any] {
        return [ "name": self.name, "age": self.age]
    }
}

extension Sequence where Iterator.Element : Serializable {
 
    func toDict() -> [[String: Any]] {
        return self.map {
            $0.toDict()
        }
    }
}

router.get("people") { (request, response, next) in
    
    let tim = Person(name: "Tim", age: 34)
    let tara = Person(name: "Tara", age: 35)
    
    let personArray: [Person] = [tim, tara]
    
    response.send(json: personArray.toDict())
    try response.end()
}


Kitura.addHTTPServer(onPort: 8090, with: router)
Kitura.run()

