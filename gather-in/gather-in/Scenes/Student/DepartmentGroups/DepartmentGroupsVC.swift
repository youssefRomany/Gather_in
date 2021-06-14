//
//  DepartmentGroupsVC.swift
//  gather-in
//
//  Created by Ramzy on 06/02/2021.
//

import UIKit
import SkeletonView
import MOLH
import Alamofire

class DepartmentGroupsVC: BaseView {
    
    // MARK:- IBOutlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var departmentNameLabel: UILabel!
    @IBOutlet weak var groupsTableView: UITableView!
    
    // Properties
    private var request: DepartmentGroupsRequest?
    public var groupsArray: [Groups] = []
    public var selectedDepartmentId: String?
    public var selectedDepartmentName: String?
    public var selectedDeparmentTeacherName: String?
    
    // Constant
    let NETWORK = NetworkingHelper()
    let GROUPS = "GROUPS"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        requestGetGroupsApi()
    }
    
    // MARK:- IBActions
    @IBAction func backPressed(_ sender: UIButton) {
        navigationRouter.pop()
    }
    
}


//MARK:- Helpers
extension DepartmentGroupsVC{
    
    func initView(){
        
        setupTableView()
        setViewsUI()
        flip(view: backButton)
        NETWORK.deleget = self
        departmentNameLabel.text = "\(localizedSitringFor(key: "Department")) \(selectedDepartmentName ?? "")"

    }
    
    // set view design
    fileprivate func setViewsUI() {
//        groupsTableView.isSkeletonable = true
        
        if MOLHLanguage.currentAppleLanguage() == "ar"{
                    backButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                }
    }
    
    // init tableView
    fileprivate func setupTableView() {
        groupsTableView.dataSource = self
        groupsTableView.delegate = self
        groupsTableView.estimatedRowHeight = 1000
        groupsTableView.registerCellNib(cellClass: DepartmentGroupsCell.self)
    }
    
}

//MARK:- TableView DataSource, Delegate
extension DepartmentGroupsVC: SkeletonTableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as DepartmentGroupsCell
        
        cell.groupNameLabel.text = groupsArray[indexPath.row].name
        
         let state = groupsArray[indexPath.row].join ?? false
            if state  {
                cell.groupStateLabel.text = "My Group".localized
                cell.groupStateLabel.textColor = UIColor.green
            } else {
                cell.groupStateLabel.text = "Locked".localized
                cell.groupStateLabel.textColor = UIColor.darkGray
            }
    
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let studentGroupDetailsVC = StudentGroupDetailsVC.instantiate(.studentGroupDetails)
        let state = groupsArray[indexPath.row].join ?? false
        if state == true {
            studentGroupDetailsVC.selectedDepartmentName = selectedDepartmentName ?? ""
            studentGroupDetailsVC.selectedGroupTeacherName = selectedDeparmentTeacherName ?? ""
            studentGroupDetailsVC.selectedGroupId = "\(groupsArray[indexPath.row].id ?? 0)"
            studentGroupDetailsVC.selectedGroupName = groupsArray[indexPath.row].name ?? ""
            studentGroupDetailsVC.currentGroup = groupsArray[indexPath.row]
            navigationRouter.push(view:studentGroupDetailsVC)
        }
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "DepartmentGroupsCell"
    }
    
}


//MARK:- Networking
extension DepartmentGroupsVC: NetworkingHelperDeleget {
    func onHelper(getData data: DataResponse<String>, fromApiName name: String, withIdentifier id: String) {
        if id == GROUPS {handelGroupsResponse(response: data)}
    }

    func onHelper(getError error: String, fromApiName name: String, withIdentifier id: String) {
        displayAlert(title: "", subTitle: localizedSitringFor(key: "unkwonError"), style: .danger)
    }
    
    func requestGetGroupsApi() {
        groupsTableView.showAnimatedSkeleton()
        NETWORK.connectWithHeaderTo(api: ApiNames.GET_GROUPS+"/\(selectedDepartmentId ?? "")", andIdentifier: GROUPS, withLoader: false, forController: self, methodType: .get)
    }

    func handelGroupsResponse(response: DataResponse<String>){
        switch response.response?.statusCode {
        case 200:
              do{
                let Resp = try JSONDecoder().decode([Groups].self, from: response.data ?? Data())
                print("dddddddd", Resp.count)
                DispatchQueue.main.async {
                    self.groupsTableView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
                }
                if Resp.count > 0 {
                    self.groupsArray = Resp
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
}
