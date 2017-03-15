
import Foundation
import Kitura
import KituraNet
import HeliumLogger
import KituraRequest

// Initialize HeliumLogger
HeliumLogger.use()

// Create a new router
let router = Router()

let env = Envionment()

let replyAPI = "https://api.line.me/v2/bot/message/reply"

router.all("/", middleware: BodyParser())

// Handle HTTP GET requests to /
router.get("/") { request, response, next in
    response.send("Hello, World!")
    next()
}

router.post("/") { request, response, next in
    
    guard let parsedBody = request.body else {
        next()
        return
    }
    
    guard case let .json(jsonBody) = parsedBody else  {
        try response.send(status: HTTPStatusCode.unsupportedMediaType).end()
        next()
        return
    }

    guard let lineSignature = request.headers["X-Line-Signature"] else {
        try response.send(status: HTTPStatusCode.forbidden).end()
        return
    }

    // Validate Line Signature
    guard let rawMessage = jsonBody.rawString(), (validateSignature(message: rawMessage, signature: lineSignature, secretKey: env.secretKey) == false)
    else {
        try response.send(status: HTTPStatusCode.forbidden).end()
        return
    }
    
    let _ = response.send(status: HTTPStatusCode.OK)

    // Process Data from Line Webhook
    let lineData = textFromLineWebhook(json: jsonBody)
    
    // Add authorization to reply header
    let lineheader:[String: String] =  ["Authorization": "Bearer {\(env.channelAccessToken)}"]
    
    // Create reply message wit reply token
    let replyDict = reply(text: lineData.text, token: lineData.replyToken)
    
    // Send back to Line Reply API
    KituraRequest.request(.post, replyAPI, parameters:replyDict , encoding: JSONEncoding.default, headers: lineheader).response {
        request, response, data, error in
        
        let message = String(data: data!, encoding: String.Encoding.utf8)
        print("Line response \n \(message)\n\n")
    }
    next()
}

// Add an HTTP server and connect it to the router
Kitura.addHTTPServer(onPort: env.port, with: router)

// Start the Kitura runloop (this call never returns)
Kitura.run()
