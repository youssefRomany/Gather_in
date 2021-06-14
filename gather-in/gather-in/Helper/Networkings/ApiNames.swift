//
//  ApiNames
//  3emala
//
//  Created by YoussefRomany on 2/20/20.
//  Copyright © 2019 youssefRomany. All rights reserved.
//


import UIKit


/*
 use this struct to add any api to use it in the project
 */
struct ApiNames {

    //static let EXAMPLE:String = Config.BASEURL + "API_NAME"
    
    // About
    static let SIGN_UP:String = Config.BASEURL + "auth/signup"
    static let SEND_EMAIL:String = Config.BASEURL + "auth/send/email"
    static let SIGN_IN:String = Config.BASEURL + "auth/signin"
    static let FORGET_PASSWORD:String = Config.BASEURL + "auth/forget/password"
    static let CHANGE_PASSWORD:String = Config.BASEURL + "auth/update/password"
    static let UPDATE_INFO:String = Config.BASEURL + "auth/update"
    static let PROFILE_INFO:String = Config.BASEURL + "auth/user"
    static let GET_ALL_DEPARTMENTS:String = Config.BASEURL + "department/get/all"
    static let JOIN_DEPARTMENT:String = Config.BASEURL + "department/user/add"
    static let GET_GROUPS:String = Config.BASEURL + "group/get/department"
    static let ABOUT_US:String = Config.BASEURL + "about"
    static let ALL_NOTIFICATIONS:String = Config.BASEURL + "notification/get"
    static let CREAT_DEPARTMENT:String = Config.BASEURL + "department/create"
    static let UPDATE_DEPARTMENT:String = Config.BASEURL + "department/update"
    static let DELETE_DEPARTMENT:String = Config.BASEURL + "department/delete"
    static let GET_DEPARTMENT:String = Config.BASEURL + "department/get"
    static let CREAT_GROUP:String = Config.BASEURL + "group/create"
    static let DELETE_GROUP:String = Config.BASEURL + "group/delete"
    static let GROUP_DETAILSE:String = Config.BASEURL + "group/get"

}



