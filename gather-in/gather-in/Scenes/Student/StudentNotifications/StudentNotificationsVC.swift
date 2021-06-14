//
//  StudentsNotificationsVC.swift
//  gather-in
//
//  Created by Ramzy on 12/11/20.
//

import UIKit
import SkeletonView
import Alamofire

class StudentNotificationsVC: BaseView {
    
    // MARK:- IBOutlets
    @IBOutlet weak var notificationsTableView: UITableView!
    @IBOutlet var emptyView: UIView!

    // Properties
    public var notificationsArray: [Notifications] = []
    var limit = 10
    var page = 1
    var isPaging = true

    // Constant
    let NETWORK = NetworkingHelper()
    let NOTIFICATIONS = "NOTIFICATIONS"


    override func viewDidLoad() {
        super.viewDidLoad()

        initview()
    }
    
    
    // MARK:- IBActions
    @IBAction func closePressed(_ sender: UIButton) {
        navigationRouter.pop()
    }
    
}


//MARK:- Helpers
extension StudentNotificationsVC{
    
    func initview(){
        setViewsUI()
        setupTableView()
        NETWORK.deleget = self
        requestGetInfoApi()
//        notificationsTableView.isSkeletonable = true
    }
    
    fileprivate func setViewsUI() {
        notificationsTableView.isSkeletonable = true
    }
    
    fileprivate func setupTableView() {
        notificationsTableView.dataSource = self
        notificationsTableView.delegate = self
        notificationsTableView.registerCellNib(cellClass: BasicNotificationCell.self)
    }
    
    // get next page
    func getNextPageIfNeeded(fromIndex index: IndexPath) {
        if index.row == notificationsArray.count - 1 &&  isPaging{
            page += 1
            
            requestGetInfoApi()

        }
    }

}

//MARK:- Skeleton TableView DataSource, Delegate
extension StudentNotificationsVC: SkeletonTableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as BasicNotificationCell
        cell.notifcationTitle.text = notificationsArray[indexPath.row].body
        
        let date = setupDateFromat(date: notificationsArray[indexPath.row].createdAt ?? "", withDateFormat: "dd/MM/YYYY hh:mm a")
        
        cell.notificationDate.text = date
        getNextPageIfNeeded(fromIndex: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let topview = UIView()
//
//        let image = UIImageView(image: UIImage(named: "empty_notification"))
//        image.contentMode = .scaleAspectFit
//        image.widthAnchor.constraint(equalToConstant: 150).isActive = true
//
//        let label = UILabel()
//        label.text = "There is no notifications yet ..."
//        label.textColor = UIColor.ui.color2
//        label.textAlignment = .center
//        label.heightAnchor.constraint(equalToConstant: 30).isActive = true
//
//        let middleStackView = UIStackView(arrangedSubviews: [image,label])
//        middleStackView.alignment = .center
//        middleStackView.axis = .vertical
//        middleStackView.distribution = .fill
//
//        let bottomView = UIView()
//
//        let stackView = UIStackView(arrangedSubviews: [topview,middleStackView,bottomView])
//        stackView.alignment = .center
//        stackView.axis = .vertical
//        stackView.distribution = .fillEqually
//
//        return stackView
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return notificationsArray.count  > 0 ? 0 : tableView.frame.height
//    }
    
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "BasicNotificationCell"
    }
    
}



//MARK:- Networking
extension StudentNotificationsVC: NetworkingHelperDeleget {
    func onHelper(getData data: DataResponse<String>, fromApiName name: String, withIdentifier id: String) {
        if id == NOTIFICATIONS {handelInfoResponse(response: data)}
    }

    func onHelper(getError error: String, fromApiName name: String, withIdentifier id: String) {
        displayAlert(title: "", subTitle: localizedSitringFor(key: "unkwonError"), style: .danger)
    }

    func requestGetInfoApi() {
        NETWORK.connectWithHeaderTo(api: ApiNames.ALL_NOTIFICATIONS+"?page=\(page)", andIdentifier: NOTIFICATIONS, withLoader: false, forController: self, methodType: .get)
    }

        
    func handelInfoResponse(response: DataResponse<String>){
        switch response.response?.statusCode {
        case 200:
              do{
                let resp = try JSONDecoder().decode(NotificatioRespons.self, from: response.data ?? Data())
                DispatchQueue.main.async {
                    self.notificationsTableView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
                }
                
                notificationsArray += resp.notifications ?? []
                
                if notificationsArray.count == 0{
                    emptyView.isHidden = false
                }
                
                self.isPaging = resp.hasNextPage ?? false
                
                mainQueue {
                    self.notificationsTableView.reloadData()
                }
                
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

    
}
