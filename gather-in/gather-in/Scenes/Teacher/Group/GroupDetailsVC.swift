//
//  GroupDetailsVC.swift
//  gather-in
//
//  Created by Ramzy on 07/01/2021.
//

import UIKit
import SkeletonView
import MOLH
import Alamofire

class GroupDetailsVC: BaseView {
    
    // MARK:- IBOutlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var groupTitleLabel: UILabel!
    @IBOutlet weak var membersCountLabel: UILabel!
    @IBOutlet weak var membersTableView: UITableView!
    @IBOutlet weak var groupLinkLabel: UILabel!
    
    // MARK:- Properties
    public var selectedGroupId: String = ""
    public var selectedGroupURL : String = ""
    var studentsArray: [MemberData] = []
    var currentGroup: Groups?
    
    // Constant
    let NETWORK = NetworkingHelper()
    let GROUPS = "GROUPS"

    
    // MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()

    }
    
    override func viewDidAppear(_ animated: Bool) {
//        getGroupDetails()
    }
    
    
    // MARK:- IBActions
    @IBAction func backPressed(_ sender: UIButton) {
        navigationRouter.pop()
    }
    
    
    @IBAction func selectLeaderPressed(_ sender: UIButton) {
        let selectLeaderVC = SelectLeaderVC.instantiate(.selectLeader)
        selectLeaderVC.selectedGroupName = groupTitleLabel.text ?? ""
        selectLeaderVC.selectedGroupId = selectedGroupId
        selectLeaderVC.MemberCountTitle = membersCountLabel.text ?? ""
        selectLeaderVC.leaderId = currentGroup?.leader?.id ?? 0
        selectLeaderVC.studentsArray = currentGroup?.members ?? []
        navigationRouter.push(view: selectLeaderVC)
    }
    
    @IBAction func communicationPressed(_ sender: UIButton) {
        let teacherChatVC = TeacherChatVC.instantiate(.teacherChat)
        navigationRouter.push(view: teacherChatVC)
    }
    @IBAction func copyLinkPressed(_ sender: Any) {
    }
    
}


//MARK:- Helpers
extension GroupDetailsVC{
 
    func initView(){
        setData()
        setupTableView()
        setupTableView()
        requestGetGroupDetailsApi()
        NETWORK.deleget = self
    }
    
    func setData(){
        if let group = currentGroup{
            self.groupTitleLabel.text = group.name ?? ""
            self.membersCountLabel.text = "(\("\(group.members_count ?? 0) " + "Member".localized))"
            self.groupLinkLabel.text = selectedGroupURL
//            self.departmentUrlLabel.text = department.url
        }
    }
    
    func setupTableView() {
        membersTableView.dataSource = self
        membersTableView.delegate = self
        membersTableView.registerCellNib(cellClass: GroupMemberTableCell.self)
    }
    
    fileprivate func setViewsUI() {
        membersTableView.isSkeletonable = true
        if MOLHLanguage.currentAppleLanguage() == "ar"{
                    backButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }
    }
    
}


//MARK:- SkeletonTableViewDataSource, UITableViewDelegate
extension GroupDetailsVC: SkeletonTableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as GroupMemberTableCell
        cell.memberNameLabel.text = studentsArray[indexPath.row].fullName ?? ""
        setImageView(forImageView: cell.memberImage, andURL: (Config.BASEURL + (studentsArray[indexPath.row].picture ?? "")), andPlaceHolderImage: "dummyphoto1")

        if  (currentGroup?.leader?.id ?? 0) == (studentsArray[indexPath.row].id ?? 0) {
            cell.leaderNameLabel.isHidden = false
        } else {
            cell.leaderNameLabel.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "GroupMemberTableCell"
    }
}



//MARK:- Networking
extension GroupDetailsVC: NetworkingHelperDeleget {
    func onHelper(getData data: DataResponse<String>, fromApiName name: String, withIdentifier id: String) {
        if id == GROUPS {handelDEtailsResponse(response: data)}
    }

    func onHelper(getError error: String, fromApiName name: String, withIdentifier id: String) {
        displayAlert(title: "", subTitle: localizedSitringFor(key: "unkwonError"), style: .danger)
    }
    
    func requestGetGroupDetailsApi() {
        membersTableView.showAnimatedSkeleton()
        NETWORK.connectWithHeaderTo(api: ApiNames.GROUP_DETAILSE+"/\(selectedGroupId )", andIdentifier: GROUPS, withLoader: false, forController: self, methodType: .get)
    }

    func handelDEtailsResponse(response: DataResponse<String>){
        switch response.response?.statusCode {
        case 200:
              do{
                let Resp = try JSONDecoder().decode(Groups.self, from: response.data ?? Data())
                DispatchQueue.main.async {
                    self.membersTableView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
                }
                currentGroup = Resp

                setData()
                if (Resp.members?.count ?? 0) > 0 {
                    self.studentsArray = Resp.members ?? []
                    self.membersTableView.reloadData()
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
