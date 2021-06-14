//
//  SocketManager.swift
//  gather-in
//
//  Created by Ahmed Muhammed on 3/23/21.
//

import SocketIO

class SocketIOManager: NSObject {
    static let sharedInstance = SocketIOManager()

    let manager = SocketManager(socketURL: URL(string: "https://backend.gathering.host")!, config: SocketIOClientConfiguration(arrayLiteral: .path("/socket.io"),.forceNew(true),.reconnectAttempts(3),.reconnectWait(2000)))
//    let manager = SocketManager(socketURL: URL(string: "https://backend.gathering.host")!, config: [.log(true), .compress])

    var socket: SocketIOClient!

    override init() {
    super.init()

        socket = manager.defaultSocket

        //Listener to capture any message that your server emits for "emitMessage" key. You can add multiple listeners to capture various emits from your server.
        socket.on("getchatmessage") { (data, ack) in
            print("Socket Ack: \(ack)")
            print("Emitted Data: \(data)")
            //Do something with the data you got back from your server.
        }
    }

    //Function for your app to emit some information to your server.
    func emit(message: String){
        print("Sending Message: \(message)")
        socket.emit("addchatmessage", message)
        //socket.emit("addchatmessage",message)
    }

    //Function to establish the socket connection with your server. Generally you want to call this method from your `Appdelegate` in the `applicationDidBecomeActive` method.
    func establishConnection() {
        socket.connect()
        print("Connected to Socket !")
    }

    //Function to close established socket connection. Call this method from `applicationDidEnterBackground` in your `Appdelegate` method.
    func closeConnection() {
        socket.disconnect()
        print("Disconnected from Socket !")
    }
}
