//
//  env.swift
//  demo
//
//  Created by Ter on 3/13/17.
//
//

import Foundation

struct Envionment {
    let port:Int
    let channelAccessToken:String
    let secretKey:String
    
    init () {

        let defaultPort = 8080
        let defaultChannelAccessToken = "Token"
        let defaultSecretKey = "Secret"
        
        if let requestedPort = ProcessInfo.processInfo.environment["PORT"] {
            port = Int(requestedPort) ?? defaultPort
        } else {
            port = defaultPort
        }
        
        if let token = ProcessInfo.processInfo.environment["CHANNEL_ACC_TOKEN"] {
            channelAccessToken = String(token) ?? defaultChannelAccessToken
        } else {
            channelAccessToken = defaultChannelAccessToken
        }

        
        if let key = ProcessInfo.processInfo.environment["CHANNEL_SECRET_KEY"] {
            secretKey = String(key) ?? defaultChannelAccessToken
        } else {
            secretKey = defaultSecretKey
        }
    }
}
