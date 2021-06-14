//
//  CommunicationDetailsVC.swift
//  gather-in
//
//  Created by Ramzy on 09/01/2021.
//

import UIKit
import MOLH
import SocketIO
class CommunicationDetailsVC: BaseView {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var memberNameLabel: UILabel!
    @IBOutlet weak var departmentAndGroupLabel: UILabel!
    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
   // let manager = SocketManager(socketURL: URL(string: "https://backend.gathering.host")!, config: SocketIOClientConfiguration(arrayLiteral: .path("/socket.io"),.forceNew(true),.reconnectAttempts(3),.reconnectWait(2000)))
    //SocketManager(socketURL: URL(string: "https://backend.gathering.host")!, config: SocketIOClientConfiguration(arrayLiteral: .path("/socket.io"),.forceNew(true),.reconnectAttempts(3),.reconnectWait(2000)))
    
    
   // var socket : SocketHelper?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        

       
       
        if MOLHLanguage.currentAppleLanguage() == "ar"{
                    backButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                }
        
//        let socketManager = SocketManager(socketURL: URL(string: "https://backend.gathering.host:8080")!)
//        let socket = socketManager.defaultSocket
//
//        socket.on("connect") { _, _ in
//            print("socket connected")
//            socket.emit("ping", "data")
//        }
//
//        socket.on("ping") { _, _ in
//            print("ping received")
//        }
//
//        socketManager.connect()
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        navigationRouter.pop()
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        //SocketIOManager.sharedInstance.emit(message: "hello")
        SocketHelper.shared.sendMessage(message: "hello", withNickname: "Ahmed")
        SocketHelper.shared.getMessage { (Message) in
            print("the message is",Message)
        }
        
       //ConnectToSocket()
//        let manager = SocketManager(socketURL: URL(string: "https://backend.gathering.host:8080")!, config: [.log(true), .compress])
//        let socket = manager.defaultSocket
//
//        socket.on(clientEvent: .connect) {data, ack in
//            print("socket connected")
//        }
//
//        socket.on("currentAmount") {data, ack in
//            guard let cur = data[0] as? Double else { return }
//
//            socket.emitWithAck("canUpdate", cur).timingOut(after: 0) {data in
//                socket.emit("update", ["amount": cur + 2.50])
//            }
//
//            ack.with("Got your currentAmount", "dude")
//        }
//
//        socket.connect()
       // connect()
      

    }
//    func connect() {
//
//        let socket = manager.defaultSocket
//        socket.on(clientEvent: .connect) {data, ack in
//            print("socket connectedddddd")
//        }
//
//        socket.on("getchatmessage") {data, ack in
//            guard let cur = data[0] as? Double else { return }
//            print("the data is ++++++",data)
//            print("the ack is +++++++",ack)
//            let obj =  Message(chatId: "1", senderId: "1", text: "hello", questionType: "text")
//            socket.emitWithAck("addchatmessage", obj).timingOut(after: 1) {result in
////                if data.first as? String ?? "passed" == SocketAckValue.noAck {
////                    // Handle ack timeout
////                }
//               // print("the result is +++++++",result)
//                socket.emit("addchatmessage", ["amount": cur + 2.50])
//            }
//
//            ack.with("Got your currentAmount", "dude")
//        }
//        let obj =  Message(chatId: "1", senderId: "1", text: "hello", questionType: "text")
//        socket.emitWithAck("addchatmessage", obj).timingOut(after: 1) {result in
////                if data.first as? String ?? "passed" == SocketAckValue.noAck {
////                    // Handle ack timeout
////                }
//            print("the result is +++++++",result)
//           // socket.emit("addchatmessage", ["amount": cur + 2.50])
//        }
//
//        socket.connect()
//    }
    
//    func ConnectToSocket() {
//
//     let   manager  = SocketManager(socketURL: URL(string: "ws://echo.websocket.org/")!, config: [.log(true), .compress])
//        let socketIOClient = manager.defaultSocket
//    
//     socketIOClient.on(clientEvent: .connect) {data, ack in
//         print("the data is :",data)
//         print("socket connected")
//
//        socketIOClient.emit("GetData", "dad")
//
//     }
//
//     socketIOClient.on("getchatmessage") { (dataArray, socketAck) -> Void in
//
//         print("the data array is :",dataArray)
//     }
//
//     socketIOClient.on(clientEvent: .error) { (data, eck) in
//         print(data)
//         print("socket error")
//     }
//
//     socketIOClient.on(clientEvent: .disconnect) { (data, eck) in
//         print(data)
//         print("socket disconnect")
//     }
//
//     socketIOClient.on(clientEvent: SocketClientEvent.reconnect) { (data, eck) in
//         print(data)
//         print("socket reconnect")
//     }
//
//     socketIOClient.connect()
//
// }
    
}
