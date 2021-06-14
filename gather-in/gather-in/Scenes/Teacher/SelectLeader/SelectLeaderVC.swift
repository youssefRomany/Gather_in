//
//  SelectLeaderVC.swift
//  gather-in
//
//  Created by Ramzy on 08/01/2021.
//

import UIKit
import MOLH
import SkeletonView

class SelectLeaderVC: BaseView {
    // MARK:- IBOutlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var groupTitleLabel: UILabel!
    @IBOutlet weak var membersCountLabel: UILabel!
    @IBOutlet weak var membersTableView: UITableView!

    // MARK:- Properties
    public var request: SelectLeaderRequests?
    public var selectedGroupId: String = ""
    public var leaderId: Int = 0
    public var selectedGroupName: String = ""
    public var MemberCountTitle: String = ""
    var studentsArray: [MemberData] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        initView()
    }
    
    
    // MARK:- IBActions
    @IBAction func backPressed(_ sender: UIButton) {
        navigationRouter.pop()
    }
        
}


//MARK:- Helpers
extension SelectLeaderVC{
    
    func initView(){
        setViewsUI()
        setViewsData()
        setupTableView()

    }
    
    func setupTableView() {
        membersTableView.dataSource = self
        membersTableView.delegate = self
        membersTableView.registerCellNib(cellClass: SelectLeaderCell.self)
    }
    
    fileprivate func setViewsUI() {
        if MOLHLanguage.currentAppleLanguage() == "ar"{
                    backButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                }
        
        membersTableView.isSkeletonable = true
    }
    
    fileprivate func setViewsData() {
        groupTitleLabel.text = selectedGroupName
        membersCountLabel.text = MemberCountTitle
    }
    
}


//MARK:- SkeletonTableViewDataSource, UITableViewDelegate
extension SelectLeaderVC: SkeletonTableViewDataSource, UITableViewDelegate {

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as SelectLeaderCell
        cell.memberNameLabel.text = studentsArray[indexPath.row].fullName ?? ""
        setImageView(forImageView: cell.memberImage, andURL: (Config.BASEURL + (studentsArray[indexPath.row].picture ?? "")), andPlaceHolderImage: "dummyphoto1")
        print(((studentsArray[indexPath.row].id ?? 0) == leaderId),"isLeaderyaprinse")
        cell.handleSelectButtonApperance(state: (studentsArray[indexPath.row].id ?? -1) == leaderId)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "SelectLeaderCell"
    }
}


extension SelectLeaderVC: SelectLeaderCellDelegate {
    func selectPressed(_ cell: SelectLeaderCell) {
        let selectedIndexPath = self.membersTableView.indexPath(for: cell)
        let studentId = studentsArray[selectedIndexPath!.row].id
//        guard let groupId = selectedGroupId else {return}
//        if isLeader != true || isLeader == nil {
//            self.showActivityIndicator()
//            request = SelectLeaderRequests.setLeader(groupId: groupId, leaderId: studentId, accessToken: token)
//            request?.send(BaseResponseModel.self, completion: {[weak self] (response) in
//                self?.handleSelectLeaderResponse(response)
//            })
//        }
    }
    
    
}
