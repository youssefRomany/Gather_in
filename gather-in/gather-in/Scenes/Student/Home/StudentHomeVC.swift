//
//  StudentHomeVC.swift
//  gather-in
//
//  Created by Ramzy on 12/9/20.
//

import UIKit
import SkeletonView
import Alamofire

class StudentHomeVC: BaseView {
    
    // MARK:- IBOutlets
    @IBOutlet weak var studentInfoView: UIView!
    @IBOutlet weak var studentImageView: UIView!
    @IBOutlet weak var studentImage: UIImageView!
    @IBOutlet weak var starImage: UIImageView!
    @IBOutlet weak var studentNameLabel: UILabel!
    @IBOutlet weak var leaderLabel: UILabel!
    @IBOutlet weak var joinGroupView: UIView!
    @IBOutlet weak var departmentsListView: UIView!
    @IBOutlet weak var departmentsTableView: UITableView!
    @IBOutlet weak var joinDepartmentButton: UIButton!
    
    // Properties
    public var departmentslist: [DepartmentRespons] = []
    var currentProfile: ProfileModel?

    // Constant
    let NETWORK = NetworkingHelper()
    let PROFILE_INFO = "PROFILE_INFO"
    let DEPARTMENTS = "DEPARTMENTS"

    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        print("eedwedewdwedwedwedewdwe   student")

    }
    
    override func viewDidAppear(_ animated: Bool) {
        requestGetInfoApi()
        requestDepartmentsApi()

    }
    
    
    // MARK:- IBActions
    @IBAction func settingsPressed(_ sender: UIButton) {
        let studentSettingsVC = StudentSettingsVC.instantiate(.studentSettings)
        navigationRouter.push(view: studentSettingsVC)
        
    }
    
    @IBAction func notificationsPressed(_ sender: UIButton) {
        let studentNotificationsVC = StudentNotificationsVC.instantiate(.studentNotifications)
        navigationRouter.push(view: studentNotificationsVC)
        
    }
    
    @IBAction func joinGroupPressed(_ sender: UIButton) {
        let joinGroupAlert = JoinDepartmentAlertVC.instantiate(.joinDepartmentAlert)
        joinGroupAlert.modalPresentationStyle = .overCurrentContext
        joinGroupAlert.modalTransitionStyle = .crossDissolve
        navigationRouter.present(view: joinGroupAlert)

    }
    
}


//MARK:- Helpers
extension StudentHomeVC{
    
    func initView(){
     
        setViewsUI()
        setupTableView()
        NETWORK.deleget = self
        leaderLabel.isHidden = true
        joinDepartmentButton.isHidden = false
        departmentsListView.isHidden = false


    }
    
    fileprivate func setViewsUI() {
        studentInfoView.layer.cornerRadius = 10
        studentInfoView.clipsToBounds = true
        
        studentImageView.layer.cornerRadius = studentImage.frame.width / 2
        studentImageView.clipsToBounds = true
        
        studentImage.layer.cornerRadius = studentImage.frame.width / 2
        studentImage.clipsToBounds = true
        
        departmentsTableView.isSkeletonable = true
    }
    
    
    
    
    fileprivate func setupTableView() {
        departmentsTableView.dataSource = self
        departmentsTableView.delegate = self
        departmentsTableView.registerCellNib(cellClass: StudentDepartmentCell.self)
    }

}

//MARK:- Skeleton TableView DataSource, Delegate
extension StudentHomeVC: SkeletonTableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return departmentslist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as StudentDepartmentCell
        cell.departmentName.text = "\(localizedSitringFor(key: "Department")) \(departmentslist[indexPath.row].id ?? 0)"
        cell.leaderName.text = departmentslist[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(departmentslist[indexPath.row].Groups ?? [], "lklkuuuuuuuu")
        let departmentGroupsVC = DepartmentGroupsVC.instantiate(.departmentGroups)
        departmentGroupsVC.selectedDepartmentId = "\(departmentslist[indexPath.row].id ?? 0)"
        departmentGroupsVC.selectedDepartmentName = departmentslist[indexPath.row].name ?? ""
//        departmentGroupsVC.groupsArray = departmentslist[indexPath.row].Groups ?? []
        navigationRouter.push(view: departmentGroupsVC)
    }
    
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "StudentDepartmentCell"
    }
}



//MARK:- Networking
extension StudentHomeVC: NetworkingHelperDeleget {
    func onHelper(getData data: DataResponse<String>, fromApiName name: String, withIdentifier id: String) {
        if id == PROFILE_INFO {handelInfoResponse(response: data)}
        else if id == DEPARTMENTS {handelDepartmentResponse(response: data)}
    }

    func onHelper(getError error: String, fromApiName name: String, withIdentifier id: String) {
        displayAlert(title: "", subTitle: localizedSitringFor(key: "unkwonError"), style: .danger)
    }

    func requestGetInfoApi() {
        NETWORK.connectWithHeaderTo(api: ApiNames.PROFILE_INFO, andIdentifier: PROFILE_INFO, withLoader: false, forController: self, methodType: .get)
    }

        
    func handelInfoResponse(response: DataResponse<String>){
        switch response.response?.statusCode {
        case 200:
              do{
                let profileRespons = try JSONDecoder().decode(ProfileModel.self, from: response.data ?? Data())
                    currentProfile = profileRespons
                studentNameLabel.text = currentProfile?.fullName ?? ""
                setImageView(forImageView: studentImage, andURL: (Config.BASEURL + (currentProfile?.picture ?? "")), andPlaceHolderImage: "dummyphoto1")
                
              }catch let error{
                print(error,"joe")
                displayAlert(title: "", subTitle: localizedSitringFor(key: "unknownError"), style: .danger)
            }
        case 401:
            displayAlert(title: "", subTitle: localizedSitringFor(key: "NoEmailFound"), style: .danger)
        default:
            displayAlert(title: "", subTitle: localizedSitringFor(key: "unknownError"), style: .danger)
        }
    }
    
    
    func requestDepartmentsApi() {
        departmentsTableView.showAnimatedSkeleton()
        NETWORK.connectWithHeaderTo(api: ApiNames.GET_ALL_DEPARTMENTS, andIdentifier: DEPARTMENTS, withLoader: false, forController: self, methodType: .get)
    }

    
func handelDepartmentResponse(response: DataResponse<String>){
    switch response.response?.statusCode {
    case 200:
          do{
            let Resp = try JSONDecoder().decode([DepartmentRespons].self, from: response.data ?? Data())
            print("dddddddd", Resp.count)
            DispatchQueue.main.async {
                self.departmentsTableView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
            }
            if Resp.count > 0 {
                joinGroupView.isHidden = true
                joinDepartmentButton.isHidden = false
                departmentsListView.isHidden = false
                self.departmentslist = Resp
 
                self.departmentsTableView.reloadData()
            }
 
          }catch let error{
            print(error,"joe")
            displayAlert(title: "", subTitle: localizedSitringFor(key: "unknownError"), style: .danger)
        }
//    case 401:
//        displayAlert(title: "", subTitle: localizedSitringFor(key: "NoEmailFound"), style: .danger)
    default:
        displayAlert(title: "", subTitle: localizedSitringFor(key: "unknownError"), style: .danger)
    }
}
}


