//
//  SocketHelper.swift
//  gather-in
//
//  Created by Ahmed Muhammed on 3/11/21.
//

//import SocketIO
//
//class SocketHelper {
//
//    static let shared = SocketHelper()
//    var socket: SocketIOClient!
//
//    let manager = SocketManager(socketURL: URL(string: "https://backend.gathering.host")!, config: [.log(true), .compress])
//
//    private init() {
//        socket = manager.defaultSocket
//    }
//
//    func connectSocket(completion: @escaping(Bool) -> () ) {
//        disconnectSocket()
//        socket.on(clientEvent: .connect) {[weak self] (data, ack) in
//            print("socket connected")
//            self?.socket.removeAllHandlers()
//            completion(true)
//        }
//        socket.connect()
//    }
//
//    func disconnectSocket() {
//        socket.removeAllHandlers()
//        socket.disconnect()
//        print("socket Disconnected")
//    }
//
//    func checkConnection() -> Bool {
//        if socket.manager?.status == .connected {
//            return true
//        }
//        return false
//
//    }
//
//    enum Events {
//
//        case search
//
//        var emitterName: String {
//            switch self {
//            case .search:
//                return "emt_search_tags"
//            }
//        }
//
//        var listnerName: String {
//            switch self {
//            case .search:
//                return "filtered_tags"
//            }
//        }
//
//        func emit(params: [String : Any]) {
//            SocketHelper.shared.socket.emit(emitterName, params)
//        }
//
//        func listen(completion: @escaping (Any) -> Void) {
//            SocketHelper.shared.socket.on(listnerName) { (response, emitter) in
//                completion(response)
//            }
//        }
//
//        func off() {
//            SocketHelper.shared.socket.off(listnerName)
//        }
//    }
//}
import UIKit
import Foundation
import SocketIO

let kHost = "https://backend.gathering.host"
let kConnectUser = "connectUser"
let kUserList = "userList"
let kExitUser = "exitUser"



final class SocketHelper: NSObject {
    
    static let shared = SocketHelper()
    
    private var manager: SocketManager?
    private var socket: SocketIOClient?
    //public protocol SocketData
    override init() {
        super.init()
        configureSocketClient()
    }
    
    private func configureSocketClient() {
        
        guard let url = URL(string: kHost) else {
            return
        }
        
        //manager = SocketManager(socketURL: url, config: [.log(true), .compress])
        manager = SocketManager(socketURL: url, config: SocketIOClientConfiguration(arrayLiteral: .path("/socket.io"),.forceNew(true),.reconnectAttempts(3),.reconnectWait(2000)))
        
        guard let manager = manager else {
            return
        }
        
        socket = manager.socket(forNamespace: "/**********")
    }
    
    func establishConnection() {
        
        guard let socket = manager?.defaultSocket else{
            return
        }
        
        socket.connect()
    }
    
    func closeConnection() {
        
        guard let socket = manager?.defaultSocket else{
            return
        }
        
        socket.disconnect()
    }
    
    func joinChatRoom(nickname: String, completion: () -> Void) {
        
        guard let socket = manager?.defaultSocket else {
            return
        }
        
        socket.emit(kConnectUser, nickname)
        completion()
    }
        
    func leaveChatRoom(nickname: String, completion: () -> Void) {
        
        guard let socket = manager?.defaultSocket else{
            return
        }
        
        socket.emit(kExitUser, nickname)
        completion()
    }
    
    func participantList(completion: @escaping (_ userList: [User]?) -> Void) {
        
        guard let socket = manager?.defaultSocket else {
            return
        }
        
        socket.on(kUserList) { [weak self] (result, ack) -> Void in
            
            guard result.count > 0,
                let _ = self,
                let user = result.first as? [[String: Any]],
                let data = UIApplication.jsonData(from: user) else {
                    return
            }
            
            do {
                let userModel = try JSONDecoder().decode([User].self, from: data)
                completion(userModel)
                
            } catch let error {
                print("Something happen wrong here...\(error)")
                completion(nil)
            }
        }
        
    }
    
    func getMessage(completion: @escaping (_ messageInfo: MessageData?) -> Void) {
        
        guard let socket = manager?.defaultSocket else {
            return
        }
        
        socket.on("getchatmessage") { (dataArray, socketAck) -> Void in
  
            var messageInfo = [String: Any]()
            if let arr = dataArray as? [[String: Any]] {
                guard let chatId = arr[0]["chatId"] as? String,
                    let senderId = arr[0]["senderId"] as? String,
                    let text = arr[0]["text"] as? String,
                    let questionType = arr[0]["questionType"] as? String
                else{
                        return
                }
                
                messageInfo["chatId"] = chatId
                messageInfo["senderId"] = senderId
                messageInfo["text"] = text
                messageInfo["questionType"] = questionType
                
            }

            guard let data = UIApplication.jsonData(from: messageInfo) else {
                return
            }

            do {
                let messageModel = try JSONDecoder().decode(MessageData.self, from: data)
                completion(messageModel)


            } catch let error {
                print("Something happen wrong here...\(error)")
                completion(nil)
            }
        }
    }
    
    func sendMessage(message: String, withNickname nickname: String) {
        
        guard let socket = manager?.defaultSocket else {
            return
        }
       // let obj = TestClass(ChatId: "1", SenderId: "2", Text: "Hello", QuestionType: "text")
       // let coordinate = Coordinate(latitude: 34.05222, longitude: -118.242) // set this however you want
      let obj =  Message(chatId: "6064dfa86bacb975e14096ca", senderId: "tech-41", text: "hello", questionType: "text")
        
        print("the object is " ,obj)
        
        socket.emit("addchatmessage", obj)
        
        
//        socket.once(clientEvent: .connect) {data, ack in
//
//        socket.emitWithAck("getUserPoints", obj).timingOut(after: 10) {data in
//
//            print("the data in ACK is ++++ ",data)
//         }
//          }
       // socket.emit("addchatmessage", obj)
        
//        do {
////            let data = try JSONEncoder().encode(obj)
////            let jsonString = String(data: data, encoding: .utf8)!
////            print("the object is " ,jsonString)
//
//            //ocket.emit("addchatmessage", with: [jsonString])
//            socket.emitWithAck("addchatmessage", obj).timingOut(after: 1) {data in
//                 print("the data is +++++",data)
//
//               }
//            //socket.emitWithAck("addchatmessage", with: ["Any"])
//            // use data here
//        } catch {
//            print(error)
//        }


        //let object = MessageData.init(chatId: "1", senderId: "1", text: "hello", questionType: "text")
        
        //print(obj)
        //socket.emit("chat message", obj)
    }
    func json(from object: [String]) throws -> String {
        let data = try JSONSerialization.data(withJSONObject: object)
        return String(data: data, encoding: .utf8)!
    }
}
