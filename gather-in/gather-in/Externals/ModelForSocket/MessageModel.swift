//
//  MessageModel.swift
//  gather-in
//
//  Created by Ahmed Muhammed on 3/17/21.
//
import UIKit
import SocketIO
public struct Message: SocketData {
    var chatId : String
    var senderId : String?
    var text: String?
    var questionType:String?

    public func socketRepresentation() throws -> SocketData {
        return ["chatId":chatId,"senderId":senderId,"text":text,"questionType":questionType]
    }

}
struct MessageData:Codable {

    var chatId : String?
    var senderId : String?
    var text: String?
    var questionType:String?
    
}
 
