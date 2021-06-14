//
//  MainTabBarVC.swift
//  gather-in
//
//  Created by Ramzy on 07/01/2021.
//

import UIKit

class MainTabBarVC: UITabBarController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBar.layer.masksToBounds = true
//        self.tabBar.isTranslucent = true
//        self.tabBar.barStyle = .blackOpaque
        self.tabBar.layer.cornerRadius = 20
        self.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        self.tabBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.tabBar.layer.shadowOpacity = 0.5
        self.tabBar.layer.shadowOffset = CGSize.zero
        self.tabBar.layer.shadowRadius = 5
        self.tabBar.layer.borderColor = UIColor.clear.cgColor
        self.tabBar.layer.borderWidth = 0
        self.tabBar.clipsToBounds = false
        self.tabBar.backgroundColor = UIColor.white
        
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().tintColor = UIColor.ui.color5
        
        
        setTabbarViewControllers() 
    }
    
    
    func setTabbarViewControllers() {
        
        let teacherHomeVC = TeacherHomeVC.instantiate(.teacherHome)
        teacherHomeVC.tabBarItem.image = UIImage(named: "home-tabbar-icon")
        
        let communicationVC =  CommunicationVC.instantiate(.communication)
        communicationVC.tabBarItem.image = UIImage(named: "messages-tabbar-icon")
        
        let teacherNotificationsVC =  TeacherNotificationsVC.instantiate(.teacherNotifications)
        teacherNotificationsVC.tabBarItem.image = UIImage(named: "notifications-tabbar-icon")
        
        let teacherProfileVC = TeacherProfileVC.instantiate(.teacherProfile)
        teacherProfileVC.tabBarItem.image = UIImage(named: "profile-tabbar-icon")
        
        viewControllers = [teacherHomeVC,communicationVC,teacherNotificationsVC,teacherProfileVC]
    }



}
