//
//  Line.swift
//  demo
//
//  Created by Ter on 3/14/17.
//
//

import Foundation
import Cryptor
import SwiftyJSON

public func validateSignature( message: String, signature: String , secretKey: String) -> Bool {
    let key = CryptoUtils.byteArray(from: secretKey)
    let data : [UInt8] = CryptoUtils.byteArray(from: message)
    if let hmac = HMAC(using: HMAC.Algorithm.sha256, key: key).update(byteArray: data)?.final() {
        let hmacData = Data(hmac)
        let hmacHex = hmacData.base64EncodedString(options: .endLineWithLineFeed)
        if signature == hmacHex {
            return true
        } else {
            return false
        }
    }
    return false
}

public func textFromLineWebhook(json: JSON) -> (text:String,replyToken:String) {
    
    let emptyResult = ("","")
    
    guard let eventsJSON = json["events"].arrayValue.first else {
        return emptyResult
    }
    
    if eventsJSON["type"].stringValue == "message" {
        let token = eventsJSON["replyToken"].stringValue
        let messageJson = eventsJSON["message"]
        
        if messageJson["type"].stringValue == "text" {
            let textMessage = messageJson["text"].stringValue
            return (text:textMessage , replyToken: token)
        }
        
        return emptyResult
    }
    
    return emptyResult
}

public func reply(text:String,token:String) -> [String:Any] {
    let message = ["type":"text", "text":text]
    let json:[String:Any] = ["replyToken":token , "messages": [message] ]
    return json
}
