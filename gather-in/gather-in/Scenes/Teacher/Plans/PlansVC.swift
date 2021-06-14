//
//  ListOfSubscriptionsVC.swift
//  gather-in
//
//  Created by Ahmed Muhammed on 12/21/20.
//

import UIKit

class PlansVC: BaseView {
    
    // MARK:- IBOutlets
    @IBOutlet weak var plansTableView: UITableView!
    
    
    // MARK:- Properties
    private var request: PlansRequest?
    private var requestEditPlans : UpdatePlansRequest?
    public var plansArray: [GetPlansDataResponse] = []
    public var planID = ""
    
    // MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewsUI()
        setupTableView()
        getPlans()
    }
    
    // MARK:- IBActions
    @IBAction func closePressed(_ sender: Any) {
        navigationRouter.pop()
    }
    
    
    @IBAction func donePressed(_ sender: Any) {
        if planID == ""{
            displayAlert(title: "", subTitle: "Please select any plan", style: .warning)
        }else{
            guard let teacherId = cache.getString(key: .userId) else {return}
            guard let token = cache.getString(key: .token) else {return}
            self.showActivityIndicator()
            requestEditPlans = UpdatePlansRequest.updatePlans(teacherId: teacherId, planId: planID, token: token)
            requestEditPlans?.send(BaseResponseModel.self, completion: {[weak self] (response) in
                self?.handleUpdatePlansResponse(response)
            })
        }
    }
    
    // MARK:- Functions
    fileprivate func setViewsUI() {
        plansTableView.backgroundColor = .clear
        plansTableView.isSkeletonable = true
    }
    
    fileprivate func getPlans() {
        guard let token = cache.getString(key: .token) else {return}
        plansTableView.showAnimatedSkeleton()
        request = PlansRequest.getPlans(token: token)
        request?.send(GetPlansResponse.self, completion: {[weak self] (response) in
            self?.handleGetPlansResponse(response)
        })
    }
    
    fileprivate func handleGetPlansResponse(_ response: ServerResponse<GetPlansResponse>) {
        self.dismissActivityIndicator()
        switch response {
        case .success(let value):
            if value.status == true {
                guard let plans = value.data else {return}
                self.plansArray = plans
                DispatchQueue.main.async {
                    self.plansTableView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
                }
            } else {
                self.plansTableView.stopSkeletonAnimation()
                self.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
            }
        case .failure(let error):
            print(error)
        }
    }
    
    fileprivate func handleUpdatePlansResponse(_ response: ServerResponse<BaseResponseModel>) {
        self.dismissActivityIndicator()
        switch response {
        case .success(let value):
            guard let message = value.message else {return}
            if value.status == true {
              
                displayAlert(title: "", subTitle: "Now you upgrade your plan", style: .success)
            } else {
                displayAlert(title: "", subTitle: message, style: .danger)
            }
        case .failure(let error):
            print(error)
        }
    }
}

