import Kitura
import HeliumLogger

HeliumLogger.use()
let router = Router()

//If you uncomment this, then none of the other requests will work.
//router.all { (request, response, next) in
//    response.send("Hello World")
//    try response.end()
//}

//MARK: working with json
router.get("hello") { (request, response, next) in
    
    let result = [["status": "ok", "message": "hello world"],["status": "ok", "message": "waddup?"]]
    
    response.send(json: ["result": result])
    try response.end()
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

//MARK: working with parameters

//localhost:8090/people/Tim
router.get("people/:name") { (request, response, next) in
    
    guard let name = request.parameters["name"] else {
        try response.status(.badRequest).end()
        return
    }
    
    response.send("The person is called \(name)")
    next()
}
//Prints: The person is called Tim
//Note that with this example you don't have to have a record in the database. You are simply echoing the argument passed into :name


//MARK: Reading URL Encoded Form Parameters
router.post(middleware: BodyParser())


//pull the name value out of json in the body of a request
router.post("people") { (request, response, next) in
    
    guard let body = request.body,
    let json = body.asJSON,
    let name = json["name"].string else {
        try response.status(.badRequest).end()
        return
    }
    
    response.status(.OK).send("The person's name is \(name)")
    try response.end()
}

router.post("peopleFormEncoded") { (request, response, next) in
    
    guard let body = request.body,
        let values = body.asURLEncoded,
        let name = values["name"]
        else {
            response.status(.badRequest)
            return
    }

    response.status(.OK).send("You sent the name \(name)")
    try response.end()
}



Kitura.addHTTPServer(onPort: 8090, with: router)
Kitura.run()




