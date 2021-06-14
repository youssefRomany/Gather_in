//
//  StudentDepartmentsDetailsvC.swift
//  gather-in
//
//  Created by Ramzy on 12/9/20.
//

import UIKit
import SkeletonView
import MOLH

class StudentGroupDetailsVC: BaseView {
    
    // MARK:- IBOutlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var departmentNameAndMembersCountLabel: UILabel!
    @IBOutlet weak var moderatorImageView: UIView!
    @IBOutlet weak var moderatorImage: UIImageView!
    @IBOutlet weak var moderatorNameLabel: UILabel!
    @IBOutlet weak var membersTableView: UITableView!
    
    // Properties
    private var request: StudentGroupDetailsRequest?
    public var studentsArray: [GroupStudentData] = []
    public var selectedGroupName: String = ""
    public var selectedDepartmentName: String = ""
    public var selectedGroupId: String = ""
    public var selectedGroupTeacherName: String = ""
    public var currentGroup: Groups?
    
    // MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()

    }

    
    // MARK:- IBActions
    @IBAction func backPressed(_ sender: UIButton) {
        navigationRouter.pop()
    }
    
    @IBAction func communicationPressed(_ sender: UIButton) {
        let studentsChat = StudentsChatVC.instantiate(.studentsChat)
        navigationRouter.push(view: studentsChat)
    }

}


//MARK:- Helpers
extension StudentGroupDetailsVC{
    
    func initView(){
        
        setViewsUI()
        setupTableView()
        setViewsData()
        flip(view: backButton)
    }
    
    //
    fileprivate func setViewsUI() {
        moderatorImageView.layer.cornerRadius = moderatorImageView.frame.width / 2
        moderatorImageView.clipsToBounds = true
        moderatorImageView.layer.borderWidth = 1.5
        moderatorImageView.layer.borderColor = UIColor.ui.color3?.cgColor
        
        membersTableView.isSkeletonable = true
        
        if MOLHLanguage.currentAppleLanguage() == "ar"{
                    backButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                }
    }
    
    fileprivate func setupTableView() {
        membersTableView.dataSource = self
        membersTableView.delegate = self
        membersTableView.registerCellNib(cellClass: GroupMemberTableCell.self)
    }
    
    fileprivate func setViewsData() {
        groupNameLabel.text = "\(localizedSitringFor(key: "Department")) \(selectedDepartmentName)"
        departmentNameAndMembersCountLabel.text = "\(localizedSitringFor(key: "Group")) \(selectedGroupName) \(currentGroup?.members_count ?? 0) \(localizedSitringFor(key: "Member"))"
        moderatorNameLabel.text = currentGroup?.master?.fullName ?? ""
        setImageView(forImageView: moderatorImage, andURL: (Config.BASEURL + (currentGroup?.master?.picture ?? "")), andPlaceHolderImage: "dummyphoto1")

        }
}


//MARK:- Skeleton TableView DataSource, Delegate
extension StudentGroupDetailsVC: SkeletonTableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as GroupMemberTableCell
        cell.memberNameLabel.text = studentsArray[indexPath.row].username
        if let isLeader = studentsArray[indexPath.row].leader {
            if isLeader == true {
                cell.leaderNameLabel.isHidden = false
            }else {
                cell.leaderNameLabel.isHidden = true
            }
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
