//
//  CreateGroupVC.swift
//  gather-in
//
//  Created by Ramzy on 08/01/2021.
//

import UIKit
import SkeletonView
import Alamofire

class CreateGroupVC: BaseView {
    
    // MARK:- IBOutlets
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var groupNameTextField: UITextField!
    @IBOutlet weak var memberTextField: UITextField!
    @IBOutlet weak var membersTableView: UITableView!
    
    
    // Properties
    var request: CreateGroupRequest?
    var selectedDepartmentId: String?
    var membersArray: [GetDepartmentMembersDataResponse] = []
    
    //MARK:- Constant
    let NETWORK = NetworkingHelper()
    let CREAT = "CREAT"


    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setViewsUI()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        setViewsData()
        NETWORK.deleget = self
    }
    
    
    // MARK:- IBActions
    @IBAction func closePressed(_ sender: UIButton) {
        navigationRouter.pop()
    }
    
    
    @IBAction func donePressed(_ sender: UIButton) {
        
        if ValidateField(){
            requestCreateApi()
        }
//        guard let departmentId = selectedDepartmentId else {return}
//        guard let name = groupNameTextField.text, !name.isEmpty else {return}
//        let members = membersArray.filter({$0.isSelected == true}).map({$0.id})
//        guard let token = cache.getString(key: .token) else {return}
//
//        request = CreateGroupRequest.addGroup(departmentId: departmentId, name: name, members: members, token: token)
//        request?.send(BaseResponseModel.self, completion: )
    }
    
    
    // MARK:- Functions

    
    fileprivate func getDepartmentMembers() {
        guard let departmentId = selectedDepartmentId else {return}
        guard let token = cache.getString(key: .token) else {return}
        
        membersTableView.showAnimatedSkeleton()
        request = CreateGroupRequest.getDepartmentMembers(departmentId: departmentId, token: token)
        request?.send(GetDepartmentMembersResponse.self, completion: {[weak self] (response) in
            self?.handleGetDepartmentMembersResponse(response)
        })
    }
    
    
    fileprivate func handleGetDepartmentMembersResponse(_ response: ServerResponse<GetDepartmentMembersResponse>) {
        self.dismissActivityIndicator()
        switch response {
        case .success(let value):
            if value.status == true {
                guard let members = value.data else {return}
                self.membersArray = members
                DispatchQueue.main.async {
                    self.membersTableView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
                }
            } else {
                self.membersTableView.stopSkeletonAnimation()
                self.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
            }
        case .failure(let error):
            print(error)
        }
    }
    
    
    
    fileprivate func handleCreateGroupResponse(_ response: ServerResponse<BaseResponseModel>) {
        self.dismissActivityIndicator()
        switch response {
        case .success(let value):
            guard let message = value.message else {return}
            if value.status == true {
                self.displayAlert(title: "", subTitle: message, style: .success)
                navigationRouter.pop()
            } else {
                self.displayAlert(title: "", subTitle: message, style: .danger)
                navigationRouter.pop()
            }
        case .failure(let error):
            print(error)
        }
    }
    
    
}


//MARK:- helpers
extension CreateGroupVC{
    
    fileprivate func setViewsUI() {
        membersTableView.isSkeletonable = true
    }
    
    fileprivate func setViewsData() {
        
        getDepartmentMembers()
    }
    
     /// validate Fields
    ///
    /// - Returns: true or false
    func ValidateField() -> Bool{

        if groupNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true{
            displayAlert(title: "", subTitle: localizedSitringFor(key: "EmptyGroupName"), style: .danger)

                return false
        }
         return true
    }
}


//MARK:- tableView
extension CreateGroupVC: SkeletonTableViewDataSource,UITableViewDelegate {
    
    func setupTableView() {
        membersTableView.dataSource = self
        membersTableView.delegate = self
        membersTableView.registerCellNib(cellClass: SelectMemberCell.self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return membersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as SelectMemberCell
        cell.memberNameLabel.text = membersArray[indexPath.row].username
        if membersArray[indexPath.row].isSelected == true {
            cell.selectButton.backgroundColor = UIColor.ui.color8
        } else {
            cell.selectButton.backgroundColor = UIColor.white
        }
        cell.delegate = self
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "SelectMemberCell"
    }
}


extension CreateGroupVC: SelectMemberCellDelegate {
    func selectPressed(_ cell: SelectMemberCell) {
        let selectedIndexPath = self.membersTableView.indexPath(for: cell)
        if membersArray[selectedIndexPath!.row].isSelected == true {
            cell.selectButton.backgroundColor = UIColor.white
            membersArray[selectedIndexPath!.row].isSelected = false
        } else {
            cell.selectButton.backgroundColor = UIColor.ui.color8
            membersArray[selectedIndexPath!.row].isSelected = true
        }
    }
    
    
}



//MARK:- Networking
extension CreateGroupVC: NetworkingHelperDeleget {
    func onHelper(getData data: DataResponse<String>, fromApiName name: String, withIdentifier id: String) {
         if id == CREAT {handelCreatResponse(response: data)}

    }

    func onHelper(getError error: String, fromApiName name: String, withIdentifier id: String) {
        displayAlert(title: "", subTitle: localizedSitringFor(key: "unkwonError"), style: .danger)
    }

    func requestCreateApi() {
        self.showActivityIndicator()
        var paramters: [String: String] = [:]
        paramters["name"] = groupNameTextField.text ?? ""
        paramters["departmentId"] = selectedDepartmentId ?? ""

        NETWORK.connectWithHeaderTo(api: ApiNames.CREAT_GROUP, withParameters: paramters, andIdentifier: CREAT, withLoader: true, forController: self, methodType: .post)
    }
        
    func handelCreatResponse(response: DataResponse<String>){
        switch response.response?.statusCode {
        case 200:
                displayAlert(title: "", subTitle: localizedSitringFor(key: "GrouptAdded"), style: .success)
                navigationController?.popViewController(animated: true)
        case 201:
                displayAlert(title: "", subTitle: localizedSitringFor(key: "GrouptAdded"), style: .success)
                navigationController?.popViewController(animated: true)

        default:
            do{
              let resp = try JSONDecoder().decode(GlobalErrorRespons.self, from: response.data ?? Data())
                displayAlert(title: "", subTitle: resp.data?.first?.msg ?? "", style: .danger)

            }catch let error{
              print(error,"joe")
              displayAlert(title: "", subTitle: localizedSitringFor(key: "unknownError"), style: .danger)
          }

        }
    }

}
