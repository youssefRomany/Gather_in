//
//  StudentsChatVC.swift
//  gather-in
//
//  Created by Ramzy on 12/10/20.
//

import UIKit
import MOLH

class StudentsChatVC: BaseView {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var departmentNameLabel: UILabel!
    @IBOutlet weak var membersCountLabel: UILabel!
    @IBOutlet weak var sendAnswerView: UIView!
    @IBOutlet weak var membersCollectionView: UICollectionView!

    @IBOutlet weak var chatTableView: UITableView!
    
    
    var messagesCount = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        setupTableView()
        handleSendAnswerViewApperance()
        
        if MOLHLanguage.currentAppleLanguage() == "ar"{
                    backButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                }
    }
    
    fileprivate func setupCollectionView() {
        membersCollectionView.dataSource = self
        membersCollectionView.delegate = self
        membersCollectionView.registerCell(cellClass: MemberCollectionCell.self)
    }
    
    
    fileprivate func setupTableView() {
        chatTableView.dataSource = self
        chatTableView.delegate = self
        chatTableView.registerCellNib(cellClass: ChatCell.self)
    }
    
    fileprivate func handleSendAnswerViewApperance() {
        // hide if the user is not the leader
        
        sendAnswerView.isHidden = false
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        navigationRouter.pop()
        
    }
    
    @IBAction func sendAnswerPressed(_ sender: UIButton) {
        let sendAnswerVC = SendAnswerVC.instantiate(.sendAnswer)
        navigationRouter.push(view: sendAnswerVC)
    }
}

extension StudentsChatVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(indexPath: indexPath) as MemberCollectionCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
}


extension StudentsChatVC: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let topview = UIView()
//        topview.heightAnchor.constraint(equalToConstant: 70).isActive = true
                
        let image = UIImageView(image: UIImage(named: "empty_messages"))
        image.contentMode = .scaleAspectFit
//        image.heightAnchor.constraint(equalToConstant: 150).isActive = true
        image.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        let label = UILabel()
        label.text = "There is no messages yet ....".localized
        label.textColor = UIColor.ui.color2
        label.textAlignment = .center
        label.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        let middleStackView = UIStackView(arrangedSubviews: [image,label])
        middleStackView.alignment = .center
        middleStackView.axis = .vertical
        middleStackView.distribution = .fill
        
        let bottomView = UIView()
        
        let stackView = UIStackView(arrangedSubviews: [topview,middleStackView,bottomView])
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
//        stackView.heightAnchor.constraint(equalToConstant: 200).isActive = true
//

        return stackView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as ChatCell
        
        if indexPath.row % 2 == 0 {
            cell.setChatBubbleType(type: .incoming)
        } else {
            cell.setChatBubbleType(type: .outgoing)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return messagesCount  > 0 ? 0 : tableView.frame.height
    }
}


