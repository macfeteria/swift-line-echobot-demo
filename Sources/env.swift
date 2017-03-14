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
    init () {

        let defaultPort = 8080
        let defaultChannelAccessToken = "Token"
        
        if let requestedPort = ProcessInfo.processInfo.environment["PORT"] {
            port = Int(requestedPort) ?? defaultPort
        } else {
            port = defaultPort
        }
        
        if let token = ProcessInfo.processInfo.environment["CHANNEL_ACC_TOKEN"] {
            channelAccessToken = String(token) ?? defaultChannelAccessToken
            print("Acc: \(channelAccessToken)")
        } else {
            channelAccessToken = defaultChannelAccessToken
        }

    }
}
