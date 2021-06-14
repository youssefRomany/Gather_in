//
//  GroupResultsVC.swift
//  gather-in
//
//  Created by Ramzy on 08/01/2021.
//

import UIKit
import SkeletonView
import MOLH

class GroupResultsVC: BaseView {
    // MARK:- IBOutlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var resultsTableView: UITableView!
    
    // MARK:- Properties
    var request: GroupResultsRequest?
    var resultsArray: [GroupResultsDataResponse] = []
    
    // MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setViewsUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setViewsData()
    }
    
    // MARK:- IBActions
    @IBAction func backPressed(_ sender: UIButton) {
        navigationRouter.pop()
    }
    
    @IBAction func sendQuestionPressed(_ sender: UIButton) {
        let sendQuestionVC = SendQuestionVC.instantiate(.sendQuestions)
        navigationRouter.push(view: sendQuestionVC)
    }
    
    // MARK:- Functions
    fileprivate func setViewsUI() {
        resultsTableView.isSkeletonable = true
        
        
        if MOLHLanguage.currentAppleLanguage() == "ar"{
            backButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }
    }
    
    fileprivate func setViewsData() {
        getReults()
    }
    
    
    fileprivate func getReults() {
        guard let teacherId = cache.getString(key: .userId) else {return}
        guard let token = cache.getString(key: .token) else {return}
        resultsTableView.showAnimatedSkeleton()
        request = GroupResultsRequest.getResults(teacherId: teacherId, accessToken: token)
        request?.send(GroupResultsResponse.self, completion: {[weak self] (response) in
            self?.handleGetResultsResponse(response)
        })
        
    }
    
    fileprivate func handleGetResultsResponse(_ response: ServerResponse<GroupResultsResponse>) {
        switch response {
        case .success(let value):
            if value.status == true {
                guard let results = value.data else {return}
                self.resultsArray = results
                DispatchQueue.main.async {
                    self.resultsTableView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
                }
            } else {
                self.resultsTableView.stopSkeletonAnimation()
                self.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
            }
        case .failure(let error):
            print(error)
        }
    }
}

