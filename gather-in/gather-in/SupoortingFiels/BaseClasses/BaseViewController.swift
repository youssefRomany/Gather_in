//
//  BaseViewController.swift
//  gather-in
//
//  Created by Ramzy on 12/4/20.
//

import UIKit
import NotificationBannerSwift
import SKActivityIndicatorView

class BaseView: UIViewController,Storyboarded {
    internal var cache:UserDefaultsProtocols = UserDefaultsManager()
    internal var navigationRouter:NavigatorProtocol =  Navigator()
    
    
    override func viewDidLoad() {
        navigationRouter.presentedView = self
    }
    
    func displayAlert(title:String , subTitle: String, style: BannerStyle) {
        let banner = NotificationBanner(title: title, subtitle: subTitle,  style: style)
        banner.show()
    }
    
    
    func showActivityIndicator() {
        SKActivityIndicator.show("Loading")
    }
    
    func dismissActivityIndicator() {
        SKActivityIndicator.dismiss()
    }
}
