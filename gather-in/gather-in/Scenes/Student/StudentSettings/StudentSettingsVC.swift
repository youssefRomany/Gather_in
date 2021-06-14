//
//  StudentSettingsVC.swift
//  gather-in
//
//  Created by Ramzy on 12/12/20.
//

import UIKit
import MOLH


class StudentSettingsVC: BaseView {
    
    //IBOutlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var englishLanguageButton: UIButton!
    @IBOutlet weak var arabicLanguageButton: UIButton!
    @IBOutlet weak var settingsTableView: UITableView!
    
    // variables
    var studentSettingsItemsArray: [StudentSettingsItemsDataModel] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }
    
    
    // MARK:- IBActions
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

}


//MARK:- Helpers
extension StudentSettingsVC{
    
    func initView(){
        
        flip(view: backButton)
        setupTableView()
        getSettingsItems()
        if L102Language.isRTL{
            englishLanguageButton.backgroundColor = hexStringToUIColor(hex: "ffffff")
            arabicLanguageButton.backgroundColor = hexStringToUIColor(hex: "8941D9")
            arabicLanguageButton.setTitleColor(hexStringToUIColor(hex: "ffffff"), for: .normal)
            englishLanguageButton.setTitleColor(hexStringToUIColor(hex: "9B9B9B"), for: .normal)
        }else{
            englishLanguageButton.backgroundColor = hexStringToUIColor(hex: "8941D9")
            arabicLanguageButton.backgroundColor = hexStringToUIColor(hex: "ffffff")
            englishLanguageButton.setTitleColor(hexStringToUIColor(hex: "ffffff"), for: .normal)
            arabicLanguageButton.setTitleColor(hexStringToUIColor(hex: "9B9B9B"), for: .normal)

        }
    }

    private func getSettingsItems() {
        if let url = Bundle.main.url(forResource: "StudentSettings", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let settingItems = try! JSONDecoder().decode(StudentSettingsResponseModel.self, from: data)
                self.studentSettingsItemsArray = settingItems.items!
            } catch {
                print("error")
            }
        }
    }
    
    fileprivate func setViewsUI() {
        if MOLHLanguage.currentAppleLanguage() == "ar"{
                    backButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                }
        
        englishLanguageButton.layer.cornerRadius = 5
        englishLanguageButton.clipsToBounds = true
        
        arabicLanguageButton.layer.cornerRadius = 5
        arabicLanguageButton.clipsToBounds = true
    }
    
    fileprivate func setupTableView() {
        settingsTableView.dataSource = self
        settingsTableView.delegate = self
        settingsTableView.registerCellNib(cellClass: SettingsCell.self)
    }

}


//MARK:- UI TableView Data Source and delegate
extension StudentSettingsVC: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        studentSettingsItemsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as SettingsCell
        
        if MOLHLanguage.currentAppleLanguage() == "en" {
            cell.itemLabel.text = studentSettingsItemsArray[indexPath.row].title
        } else {
            cell.itemLabel.text = studentSettingsItemsArray[indexPath.row].titleAr
        }
        if indexPath.row == 3 {
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
            let studentProfileVC = StudentProfileVC.instantiate(.studentProfile)
            navigationRouter.push(view: studentProfileVC)
            
        case 1:
            let changeVc = ChangePasswordVC.instantiate(.changePassword)
            navigationRouter.push(view: changeVc)
            
        case 2:
            let aboutUsVC = AboutUsVC.instantiate(.aboutUs)
            navigationRouter.push(view: aboutUsVC)

        case 3:
            let leaderChatsVC = LeaderChatsVC.instantiate(.leaderChats)
            navigationRouter.push(view: leaderChatsVC)
            
        case 4:
            let typeSelectionVC = TypeSelectionVC.instantiate(.typeSelection)
            UserAccount.shared.logout()
            UserAccount.shared.storeData()
            navigationRouter.setAsRoot(view: typeSelectionVC)
        default:
            break
        
        }
    }
    
    
}
