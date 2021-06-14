//
//  Navigator.swift
//  gather-in
//
//  Created by Ramzy on 12/4/20.
//

import UIKit

protocol NavigatorProtocol {
    var presentedView: BaseView! {set get}
    func setAsRoot(view: BaseView)
    func present(view: BaseView)
    func push(view:BaseView, isAnimated: Bool)
    func pop(isAnimated: Bool)
    func dismiss()
}


extension NavigatorProtocol {
    func push(view:BaseView, isAnimated: Bool = true) {
        presentedView.navigationController?.pushViewController(view, animated: isAnimated)
    }
    func pop(isAnimated: Bool = true) {
        presentedView.navigationController?.popViewController(animated: isAnimated)
    }
}

class Navigator: NavigatorProtocol {

    var presentedView: BaseView!
    
    func setAsRoot(view: BaseView) {
        let window = (UIApplication.shared.delegate as! AppDelegate).window
        window?.makeKeyAndVisible()
        let navigationController = UINavigationController(rootViewController: view)
        navigationController.navigationBar.isHidden = true
        window?.rootViewController = navigationController
    }
    
    func present(view: BaseView) {
        presentedView.present(view, animated: true, completion: nil)
    }
    
    func dismiss() {
        presentedView.dismiss(animated: true, completion: nil)
    }

}
