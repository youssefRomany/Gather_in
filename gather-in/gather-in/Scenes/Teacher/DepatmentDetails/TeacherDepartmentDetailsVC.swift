//
//  TeacherDepartmentDetailsVC.swift
//  gather-in
//
//  Created by Ahmed Muhammed on 12/21/20.
//

import UIKit
import SkeletonView
import MOLH
import Alamofire

class TeacherDepartmentDetailsVC: BaseView {
    
    // MARK:- IBOutlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var departmentNameLabel: UILabel!
    @IBOutlet weak var groupsCountLabel: UILabel!
    @IBOutlet weak var departmentCodeLabel: UILabel!
    @IBOutlet weak var departmentUrlLabel: UILabel!
    @IBOutlet weak var groupsTableView: UITableView!
    
    
    // Properties
    var selectedDepartmentId: String?
    var groupsArray: [Groups] = []
    var currentDepartment: DepartmentRespons?
    var selectedIndexPath = -1

    // Constant
    let NETWORK = NetworkingHelper()
    let GROUPS = "GROUPS"
    let DELETE_GROUPS = "DELETE_GROUPS"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        requestGetDepartmentDetailsApi()
    }
    
    
    // MARK:- IBActions
    @IBAction func backPressed(_ sender: Any) {
        navigationRouter.pop()
    }
    
    
    @IBAction func copyCodePressed(_ sender: UIButton) {
        UIPasteboard.general.string = departmentCodeLabel.text
    }
    
    @IBAction func copyUrlPressed(_ sender: UIButton) {
        UIPasteboard.general.string = departmentUrlLabel.text
    }
    
    @IBAction func addPressed(_ sender: UIButton) {
        guard let departmentId = selectedDepartmentId else {return}
        let createGroupVC = CreateGroupVC.instantiate(.createGroup)
        createGroupVC.selectedDepartmentId = departmentId
        navigationRouter.push(view: createGroupVC)

    }
}


//MARK:- Helpers
extension TeacherDepartmentDetailsVC{
 
    func initView(){
        setData()
        setupTableView()
        setViewsUI()
        flip(view: backButton)
        NETWORK.deleget = self
        requestGetDepartmentDetailsApi()
    }
    
    func setData(){
        if let department = currentDepartment{
            groupsArray = department.Groups ?? []
            self.departmentNameLabel.text = department.name ?? ""
            self.groupsCountLabel.text = "(\("\(department.Groups?.count ?? 0) " + "groups".localized))"
            self.departmentCodeLabel.text = department.code
//            self.departmentUrlLabel.text = department.url
        }
    }
    
    fileprivate func setViewsUI() {
        if MOLHLanguage.currentAppleLanguage() == "ar"{
            backButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }
        
        groupsTableView.backgroundColor = .clear
        groupsTableView.isSkeletonable = true
    }
    
}

//MARK:- UITableView Delegate, SkeletonTableViewDataSource
extension TeacherDepartmentDetailsVC: UITableViewDelegate,SkeletonTableViewDataSource{
    func setupTableView() {
        groupsTableView.dataSource = self
        groupsTableView.delegate = self
        groupsTableView.registerCellNib(cellClass: TeacherGroupCell.self)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as TeacherGroupCell
        cell.groupName.text = groupsArray[indexPath.row].name
        cell.delegate = self
        cell.backgroundColor = UIColor.clear
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let groupId = groupsArray[indexPath.row].id
        let groupDetailsVC = GroupDetailsVC.instantiate(.groupDetails)
        groupDetailsVC.selectedGroupId = "\(groupId ?? 0)"
        groupDetailsVC.selectedGroupURL = currentDepartment?.code ?? ""
        groupDetailsVC.currentGroup = groupsArray[indexPath.row]
        navigationRouter.push(view: groupDetailsVC)
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "TeacherGroupCell"
    }
    
}


//MARK:- Networking
extension TeacherDepartmentDetailsVC: NetworkingHelperDeleget {
    func onHelper(getData data: DataResponse<String>, fromApiName name: String, withIdentifier id: String) {
        if id == GROUPS {handelDEtailsResponse(response: data)}
        else if id == DELETE_GROUPS {handelDeleteGrouptResponse(response: data)}
    }

    func onHelper(getError error: String, fromApiName name: String, withIdentifier id: String) {
        displayAlert(title: "", subTitle: localizedSitringFor(key: "unkwonError"), style: .danger)
    }
    
    func requestGetDepartmentDetailsApi() {
        groupsTableView.showAnimatedSkeleton()
        NETWORK.connectWithHeaderTo(api: ApiNames.GET_DEPARTMENT+"/\(selectedDepartmentId ?? "")", andIdentifier: GROUPS, withLoader: false, forController: self, methodType: .get)
    }

    func handelDEtailsResponse(response: DataResponse<String>){
        switch response.response?.statusCode {
        case 200:
              do{
                let Resp = try JSONDecoder().decode([DepartmentRespons].self, from: response.data ?? Data())
                print("dddddddd count", Resp.count)
                DispatchQueue.main.async {
                    self.groupsTableView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
                }
                
   
                setData()
                if Resp.count > 0 {
                    self.groupsArray = Resp.first?.Groups ?? []
                    self.groupsTableView.reloadData()
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
    
    func requestDeleteGroupApi() {
        self.showActivityIndicator()
        var paramters: [String: Any] = [:]
        paramters["id"] = groupsArray[selectedIndexPath].id

        NETWORK.connectWithHeaderTo(api: ApiNames.DELETE_GROUP, withParameters: paramters, andIdentifier: DELETE_GROUPS, withLoader: true, forController: self, methodType: .post)
    }
    
    
    func handelDeleteGrouptResponse(response: DataResponse<String>){
        switch response.response?.statusCode {
        case 200:
            displayAlert(title: "", subTitle: localizedSitringFor(key: "deleteGroupDone"), style: .success)
            self.groupsArray.remove(at: selectedIndexPath)
            groupsTableView.reloadData()

        default:
            displayAlert(title: "", subTitle: localizedSitringFor(key: "unknownError"), style: .danger)
        }
    }

}



//MARK:-  cell Delegation
extension TeacherDepartmentDetailsVC: TeacherGroupCellDelegate {
    func deletePressed(_ cell: TeacherGroupCell) {
        selectedIndexPath = self.groupsTableView.indexPath(for: cell)?.row ?? -1
        requestDeleteGroupApi()


    }
    
    func editPressed(_ cell: TeacherGroupCell) {
        let selectedIndexPath = self.groupsTableView.indexPath(for: cell)
        let departmentId = selectedDepartmentId
        let groupId = groupsArray[selectedIndexPath!.row].id
        let groupName = groupsArray[selectedIndexPath!.row].name
        let editGroupVC = EditGroupVC.instantiate(.editGroup)
        editGroupVC.selectedDepartmentId = departmentId
        editGroupVC.selectedGroupId = "\(String(describing: groupId))"
        editGroupVC.selectedGroupName = groupName
        navigationRouter.push(view: editGroupVC)
    }
    

    
}
