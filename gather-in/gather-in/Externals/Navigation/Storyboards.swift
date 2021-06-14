//
//  Storyboards.swift
//  gather-in
//
//  Created by Ramzy on 12/4/20.
//

import UIKit

enum OurStoryboards: String{
    // Common
    case typeSelection = "TypeSelection"
    case login = "Login"
    case registration = "Registration"
    case alreadyRegisteredAlert = "AlreadyRegisteredAlert"
    case verfication = "Verfication"
    case aboutUs = "AboutUs"
    case sentSuccessfully = "SentSuccessfully"
    case forgotPassword = "ForgotPassword"
    case changePassword = "ChangePassword"
    
    // Student
    case studentHome = "StudentHome"
    case joinDepartmentAlert = "JoinDepartmentAlert"
    case departmentGroups = "DepartmentGroups"
    case studentGroupDetails = "StudentGroupDetails"
    case studentsChat = "StudentsChat"
    case sendAnswer = "SendAnswer"
    case studentNotifications = "StudentNotifications"
    case studentSettings = "StudentSettings"
    case leaderChats = "LeaderChats"
    case studentProfile = "StudentProfile"
    case studentChangePassword = "StudentChangePassword"
    
    // Teacher
    case teacherHome = "TeacherHome"
    case plans = "Plans"
    case teacherDepartmentDetails = "TeacherDepartmentDetails"
    case createDepartment = "CreateDepartment"
    case editDepartment = "EditDepartment"
    case groupDetails = "GroupDetails"
    case teacherChat = "TeacherChat"
    case createGroup = "CreateGroup"
    case editGroup = "EditGroup"
    case selectLeader = "SelectLeader"
    case groupResults = "GroupResults"
    case resultDetails = "ResultDetails"
    case sendQuestions = "SendQuestions"
    case notificationsAndReports = "NotificationsAndReports"
    case notificationAndReportMessage = "NotificationAndReportMessage"
    case communication = "Communication"
    case communicationDetails = "CommunicationDetails"
    case teacherNotifications = "TeacherNotifications"
    case teacherProfile = "TeacherProfile"
    case teacherSettings = "TeacherSettings"
    case teacherEditProfile = "TeacherEditProfile"
    case teacherChangePassword = "TeacherChangePassword"
}


protocol Storyboarded {
    static func instantiate(_ storyboardId: OurStoryboards) -> Self
}

extension Storyboarded where Self:UIViewController {
    static func instantiate(_ storyboardId: OurStoryboards) -> Self {
        let id = String(describing: self)
        let storyboard = UIStoryboard(name: storyboardId.rawValue ,bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: id) as! Self
    }
}

