//
//  AppDelegate.swift
//  gather-in
//
//  Created by Ramzy on 12/4/20.
//

import UIKit
import MOLH
import UserNotifications
import Firebase
import FirebaseInstanceID
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate, MOLHResetable {

    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    
    let cache = UserDefaultsManager()
    let navigationRouter:NavigatorProtocol =  Navigator()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
      
        handleApplicationMode()
        handleSession()
        localizationSetup()
        if #available(iOS 10.0, *) {
        // For iOS 10 display notification (sent via APNS)
              UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
              UNUserNotificationCenter.current().requestAuthorization(
        options: authOptions,
        completionHandler: {_, _ in })
            } else {
        let settings: UIUserNotificationSettings =
        UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
              application.registerUserNotificationSettings(settings)
            }

        
        FirebaseApp.configure()
           application.registerForRemoteNotifications()
        // [START set_messaging_delegate]
        Messaging.messaging().delegate = self
        Messaging.messaging().isAutoInitEnabled = true
        
        return true
    }
    
    
    
    fileprivate func handleSession() {
        let isLogged = UserAccount.shared.isLoggedIn
        if !isLogged {
            let userTypeVC = TypeSelectionVC.instantiate(.typeSelection)
            navigationRouter.setAsRoot(view: userTypeVC)
        } else {
            let userType = UserAccount.shared.isStudent
            if !userType{
                let mainTabbarVC = UIStoryboard(name: "MainTabBar", bundle: nil).instantiateViewController(withIdentifier: "MainTabBarVC") as! MainTabBarVC
                let navigationController = UINavigationController(rootViewController: mainTabbarVC)
                navigationController.navigationBar.isHidden = true
                self.window?.rootViewController = navigationController
            } else {
                let studentHomeVC = StudentHomeVC.instantiate(.studentHome)
                navigationRouter.setAsRoot(view: studentHomeVC)
            }
        }
    }
    
    fileprivate func handleApplicationMode() {
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        } else {
            //
        }
    }
    
    func localizationSetup() {
        MOLHLanguage.setDefaultLanguage("en")
        MOLH.shared.activate(true)
    }
    
    
    func reset() {
        let userType = cache.getString(key: .userType)
        if userType == "Teacher" {
            let mainTabbarVC = UIStoryboard(name: "MainTabBar", bundle: nil).instantiateViewController(withIdentifier: "MainTabBarVC") as! MainTabBarVC
            let navigationController = UINavigationController(rootViewController: mainTabbarVC)
            navigationController.navigationBar.isHidden = true
            self.window?.rootViewController = navigationController
        } else {
            let studentHomeVC = StudentHomeVC.instantiate(.studentHome)
            navigationRouter.setAsRoot(view: studentHomeVC)
        }
    }
    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        SocketHelper.shared.closeConnection()
        //SocketIOManager.sharedInstance.closeConnection()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        SocketHelper.shared.establishConnection()
        //SocketIOManager.sharedInstance.establishConnection()
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
    // The callback to handle data message received via FCM for devices running iOS 10 or above.
    func applicationReceivedRemoteMessage(_ remoteMessage: MessagingAPNSTokenType) {
        print(remoteMessage)
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        //        print(userInfo)
        //        let title = userInfo["title"] as! String
        //        let body = userInfo["body"] as! String
        //        let image = userInfo["image"] as! String
        //
        //        let notification = UNMutableNotificationContent()
        //        notification.title = title
        //        notification.body.append(contentsOf: body)
        
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        let deviceTokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
//        UserDefaultsManager.setDeviceToken(Token: deviceTokenString)
//        print("deviceTokenString is \(deviceTokenString)")
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        print(userInfo)
        
        if(userInfo.count > 0){
            
        }
        
       
        
    }
}
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.body
        
     
        print(userInfo)
        
        
        // UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
        // Change this to your preferred presentation option
        completionHandler(.alert)
        //completionHandler([userInfo1 as! UNNotificationPresentationOptions])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
            print("The size is : \(userInfo.count)")
        }
        
        // Print full message.
        print(userInfo)
        completionHandler()
    }
    
    
}

extension AppDelegate:MessagingDelegate{
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(fcmToken)")
        cache.saveString(fcmToken, key:.fireBaseToken )
       
        Messaging.messaging().subscribe(toTopic: "global")
        let dataDict:[String: String?] = ["token": fcmToken]
        
        
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
        
        
    }
    private func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingAPNSTokenType) {
        print("Message Data" , remoteMessage)
        
        
    }
    
}
extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}


