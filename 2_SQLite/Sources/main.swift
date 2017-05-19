import Kitura
import HeliumLogger
import SwiftyJSON
import SQLite

HeliumLogger.use()

let router = Router()
router.post(middleware: BodyParser())

router.all { (request, response, next) in
    response.status(.OK).send("Welcome to the house of pain")
    next()
}


Kitura.addHTTPServer(onPort: 8090, with: router)
Kitura.run()
