//
//  Line.swift
//  demo
//
//  Created by Ter on 3/14/17.
//
//

import Foundation
import SwiftyJSON

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
