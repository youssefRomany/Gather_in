//
//  Config
//  3emala
//
//  Created by YoussefRomany on 2/20/20.
//  Copyright © 2019 youssefRomany. All rights reserved.
//


import UIKit


/*
 here put the statics for all project
 */
struct Config {
    static let MAIN_URL = "https://apis.gathering.host"
    static let BASEURL:String = "\(MAIN_URL)/"
    static let API_TOKEN: String = "Bearer " + UserAccount.shared.Token
    static let APP_STORE_LINK = "https://www.apple.com/ios/app-store/"
    static let PLAY_STORE_LINK = "https://play.google.com/store"
    static let SOCKET_URL:String = "\(MAIN_URL)/hubs/product"

    static let BASIMAGEURL:String = ""
    static let globalLimit = 10
}
