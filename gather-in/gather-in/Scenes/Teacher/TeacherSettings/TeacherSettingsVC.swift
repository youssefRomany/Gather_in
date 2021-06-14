//
//  TeacherSettingsVC.swift
//  gather-in
//
//  Created by Ramzy on 10/01/2021.
//

import UIKit
import MOLH

class TeacherSettingsVC: BaseView {
    
    //IBOutlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var englishLanguageButton: UIButton!
    @IBOutlet weak var arabicLanguageButton: UIButton!
    @IBOutlet weak var settingsTableView: UITableView!
    
    var teacherSettingsItemsArray: [TeacherSettingsItemsDataModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        getSettingsItems()
    }
    
    
    // MARK:- IBACtions
    @IBAction func backPressed(_ sender: UIButton) {
        navigationRouter.pop()
    }
    
    @IBAction func englishPressed(_ sender: UIButton) {
        MOLH.setLanguageTo("en")
        MOLH.reset()
    }
    
    @IBAction func arabicPressed(_ sender: UIButton) {
        MOLH.setLanguageTo("ar")
        MOLH.reset()
    }
    
    
    // MARK:- Functions

}


//MARK:- Heleprs
extension TeacherSettingsVC{
    
    
    fileprivate func setViewsUI() {
        if MOLHLanguage.currentAppleLanguage() == "ar"{
                    backButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                }
        
        englishLanguageButton.layer.cornerRadius = 5
        englishLanguageButton.clipsToBounds = true
        
        arabicLanguageButton.layer.cornerRadius = 5
        arabicLanguageButton.clipsToBounds = true
    }

    private func getSettingsItems() {
        if let url = Bundle.main.url(forResource: "TeacherSettings", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let settingItems = try! JSONDecoder().decode(TeacherSettingsResponseModel.self, from: data)
                self.teacherSettingsItemsArray = settingItems.items!
            } catch {
                print("error")
            }
        }
    }
}


// MARK:- UITableView Data Source, UITableView Delegate
extension TeacherSettingsVC: UITableViewDataSource,UITableViewDelegate {
    
    func setupTableView() {
        settingsTableView.dataSource = self
        settingsTableView.delegate = self
        settingsTableView.registerCellNib(cellClass: SettingsCell.self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        teacherSettingsItemsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as SettingsCell
        
        if MOLHLanguage.currentAppleLanguage() == "en" {
            cell.itemLabel.text = teacherSettingsItemsArray[indexPath.row].title
        } else {
            cell.itemLabel.text = teacherSettingsItemsArray[indexPath.row].titleAr
        }
        
        if indexPath.row == 2 {
            cell.itemLabel.textColor = UIColor.ui.color7
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let teacherProfileVC = TeacherEditProfileVC.instantiate(.teacherEditProfile)
            navigationRouter.push(view: teacherProfileVC)
        case 1:
            let changeVc = ChangePasswordVC.instantiate(.changePassword)
            navigationRouter.push(view: changeVc)

        case 2:
            let aboutUsVC = AboutUsVC.instantiate(.aboutUs)
            navigationRouter.push(view: aboutUsVC)
            
        case 3:
            let plansVC = PlansVC.instantiate(.plans)
            navigationRouter.push(view: plansVC)
            
        case 4:
            let typeSelectionVC = TypeSelectionVC.instantiate(.typeSelection)
            cache.removeObject(key: .token)
            cache.removeObject(key: .userId)
            cache.removeObject(key: .userEmail)
            cache.removeObject(key: .username)
            cache.removeObject(key: .isLeader)
            cache.removeObject(key: .userType)
            navigationRouter.setAsRoot(view: typeSelectionVC)
        default:
            break
        
        }
    }
    
    
}
