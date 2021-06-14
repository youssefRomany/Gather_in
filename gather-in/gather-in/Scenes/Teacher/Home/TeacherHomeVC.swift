//
//  TeacherHomeVC.swift
//  gather-in
//
//  Created by Ahmed Muhammed on 12/20/20.
//

import UIKit
import SkeletonView
import Alamofire

class TeacherHomeVC: BaseView {
    
    // MARK:- IBOutlets
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var viewOfLeader: UIView!
    @IBOutlet weak var teacherName: UILabel!
    @IBOutlet weak var departmentsTableView: UITableView!
    @IBOutlet weak var teacherImageView: UIImageView!

    // MARK:- Properties
    public var departmentslist: [DepartmentRespons] = []
    var currentProfile: ProfileModel?
    var selectedIndexPath = -1

    // Constant
    let NETWORK = NetworkingHelper()
    let PROFILE_INFO = "PROFILE_INFO"
    let DEPARTMENTS = "DEPARTMENTS"
    let DELETE_DEPARTMENT = "DELETE_DEPARTMENT"

    // MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        print("eedwedewdwedwedwedewdwe   teacher")

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        requestDepartmentsApi()
        requestGetInfoApi()
        print("eedwedewdwedwedwedewdwe   teacher did")

    }

    
    // MARK:- IBActions
    @IBAction func upgradePressed(_ sender: Any) {
        let plansVC = PlansVC.instantiate(.plans)
        navigationRouter.push(view: plansVC)
    }
    
    @IBAction func groupResultPressed(_ sender: Any) {
        let groupResults = GroupResultsVC.instantiate(.groupResults)
        navigationRouter.push(view: groupResults)
    }
    
    @IBAction func sendNotificationPressed(_ sender: Any) {
        let notificationsAndReportsVC = NotificationsAndReportsVC.instantiate(.notificationsAndReports)
        navigationRouter.push(view: notificationsAndReportsVC)
    }
    
    
    @IBAction func addDepartmentPressed(_ sender: UIButton) {
        if departmentslist.count<3{
            let createDepartmentVC = CreateDepartmentVC.instantiate(.createDepartment)
            navigationRouter.push(view: createDepartmentVC)
        }else{
            displayAlert(title: "", subTitle: localizedSitringFor(key: "cantAddMoreDepartment"), style: .warning)

        }
    }
    
}


//MARK:- Helpers
extension TeacherHomeVC{
    
    func initView(){
     
        setViewsUI()
        setupTableView()
        NETWORK.deleget = self
        
//        leaderLabel.isHidden = true
//        joinDepartmentButton.isHidden = false
//        departmentsListView.isHidden = false


    }
    
    fileprivate func setViewsUI() {
        headerImageView.layer.cornerRadius = 25
        headerImageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        departmentsTableView.isSkeletonable = true
        
        teacherImageView.layer.cornerRadius = teacherImageView.frame.width / 2
        teacherImageView.clipsToBounds = true

    }
    
    func setupTableView() {
        departmentsTableView.dataSource = self
        departmentsTableView.delegate = self
        departmentsTableView.registerCellNib(cellClass: TeacherDepartmentCell.self)
    }
    
}

//MARK:- Skeleton TableView DataSource, Delegate
extension TeacherHomeVC: SkeletonTableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return departmentslist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as TeacherDepartmentCell
        
        
        cell.departmentName.text = departmentslist[indexPath.row].name
        cell.numberOfGroups.text = "( \(departmentslist[indexPath.row].Groups?.count ?? 0) \("groups".localized) )"
        
        cell.backgroundColor = UIColor.clear
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let id = departmentslist[indexPath.row].id else {return}
        let teacherDepartmentDetailsVC = TeacherDepartmentDetailsVC.instantiate(.teacherDepartmentDetails)
        teacherDepartmentDetailsVC.selectedDepartmentId = "\(id)"
        teacherDepartmentDetailsVC.currentDepartment = departmentslist[indexPath.row]
        navigationRouter.push(view: teacherDepartmentDetailsVC)
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "TeacherDepartmentCell"
    }
    
}



//MARK:- Networking
extension TeacherHomeVC: NetworkingHelperDeleget {
    func onHelper(getData data: DataResponse<String>, fromApiName name: String, withIdentifier id: String) {
        if id == PROFILE_INFO {handelInfoResponse(response: data)}
        else if id == DEPARTMENTS {handelDepartmentResponse(response: data)}
        else if id == DELETE_DEPARTMENT {handelDeleteDepartmentResponse(response: data)}
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
                teacherName.text = currentProfile?.fullName ?? ""
                setImageView(forImageView: teacherImageView, andURL: (Config.BASEURL + (currentProfile?.picture ?? "")), andPlaceHolderImage: "dummyphoto1")
                
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
        //                joinGroupView.isHidden = true
        //                joinDepartmentButton.isHidden = false
        //                departmentsListView.isHidden = false
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
    
    func requestDeleteDepartmentApi() {
        self.showActivityIndicator()
        var paramters: [String: Any] = [:]
        paramters["id"] = departmentslist[selectedIndexPath].id

        NETWORK.connectWithHeaderTo(api: ApiNames.DELETE_DEPARTMENT, withParameters: paramters, andIdentifier: DELETE_DEPARTMENT, withLoader: true, forController: self, methodType: .post)
    }
    
    
    func handelDeleteDepartmentResponse(response: DataResponse<String>){
        switch response.response?.statusCode {
        case 200:
            displayAlert(title: "", subTitle: localizedSitringFor(key: "deleteDepartmentDone"), style: .success)
            self.departmentslist.remove(at: selectedIndexPath)
            departmentsTableView.reloadData()

        case 401:
            displayAlert(title: "", subTitle: localizedSitringFor(key: "NoEmailFound"), style: .danger)
        default:
            displayAlert(title: "", subTitle: localizedSitringFor(key: "unknownError"), style: .danger)
        }
    }
}


//MARK:-  cell Delegation
extension TeacherHomeVC: TeacherDepartmentCellDelegate {
    func deletePressed(_ cell: TeacherDepartmentCell) {
        selectedIndexPath = self.departmentsTableView.indexPath(for: cell)?.row ?? -1
        requestDeleteDepartmentApi()
    }
    
    func editPressed(_ cell: TeacherDepartmentCell) {
        let selectedIndexPath = self.departmentsTableView.indexPath(for: cell)
        guard let departmentId = departmentslist[selectedIndexPath!.row].id else {return}
        guard let departmentName = departmentslist[selectedIndexPath!.row].name else {return}
        guard let departmentCode = departmentslist[selectedIndexPath!.row].code else {return}
        
        let editDepartmentVC = EditDepartmentVC.instantiate(.editDepartment)
        editDepartmentVC.selectedDepartmentId = "\(departmentId)"
        editDepartmentVC.selectedDeparmentName = departmentName
        editDepartmentVC.selectedDepartmentCode = departmentCode
        navigationRouter.push(view: editDepartmentVC)
    }
    
    
}
