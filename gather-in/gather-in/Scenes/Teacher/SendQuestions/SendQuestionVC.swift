//
//  SendQuestionVC.swift
//  gather-in
//
//  Created by Ramzy on 09/01/2021.
//

import UIKit
import MOLH

class SendQuestionVC: BaseView {
    // MARK:- IBOutlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var groupsTableView: UITableView!
    @IBOutlet weak var textQuestionButton: UIButton!
    @IBOutlet weak var textQuestionTextView: UITextView!
    @IBOutlet weak var multipleChoiceButton: UIButton!
    @IBOutlet weak var multipleChoiceTextView: UITextView!
    @IBOutlet weak var optionsStackView: UIStackView!
    @IBOutlet weak var optionOneTextField: UITextField!
    @IBOutlet weak var optionTwoTextField: UITextField!
    @IBOutlet weak var optionThreeTextField: UITextField!
    @IBOutlet weak var optionFourTextField: UITextField!
    @IBOutlet weak var addOptionsView: UIView!
    
    // MARK:- Properties
    var request: SendQuestionRequest?
    var groupsArray: [TeacherGroupsDataResponse] = []
    private var selectedQuestionType: String = ""
    private var currentNumberOfOptions = 2
    
    
    // MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewsUI()
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setViewsData()
    }
    
    // MARK:- IBActions
    @IBAction func backPressed(_ sender: UIButton) {
        navigationRouter.pop()
        
    }
    
    @IBAction func textQuestionPressed(_ sender: UIButton) {
        textQuestionButton.backgroundColor = UIColor.ui.color8
        multipleChoiceButton.backgroundColor = UIColor.white
        selectedQuestionType = "essay"
        
        textQuestionTextView.isUserInteractionEnabled = true
        
        multipleChoiceTextView.text = ""
        multipleChoiceTextView.isUserInteractionEnabled = false
        
        optionOneTextField.text = ""
        optionOneTextField.isUserInteractionEnabled = false
        optionTwoTextField.text = ""
        optionTwoTextField.isUserInteractionEnabled = false
        optionThreeTextField.text = ""
        optionThreeTextField.isUserInteractionEnabled = false
        optionFourTextField.text = ""
        optionFourTextField.isUserInteractionEnabled = false
    }
    
    @IBAction func multipleChoicePressed(_ sender: UIButton) {
        multipleChoiceButton.backgroundColor = UIColor.ui.color8
        textQuestionButton.backgroundColor = UIColor.white
        selectedQuestionType = "mcq"
        
        multipleChoiceTextView.isUserInteractionEnabled = true
        optionOneTextField.isUserInteractionEnabled = true
        optionTwoTextField.isUserInteractionEnabled = true
        optionThreeTextField.isUserInteractionEnabled = true
        optionFourTextField.isUserInteractionEnabled = true
        
        textQuestionTextView.text = ""
        textQuestionTextView.isUserInteractionEnabled = false
        
        
    }
    
    @IBAction func addOptionsPressed(_ sender: UIButton) {
        if currentNumberOfOptions == 2 {
            currentNumberOfOptions = 3
            optionThreeTextField.isHidden = false
        } else {
            optionFourTextField.isHidden = false
        }
    }
    @IBAction func sendPressed(_ sender: UIButton) {
        guard let userId = cache.getString(key: .userId) else {return}
        guard let token = cache.getString(key: .token) else {return}
        
        let groups = groupsArray.filter(){$0.id != "All"}
        let selectedGroups = groups.filter({$0.isSelected == true}).map({$0.id})
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month, .day, .year, .hour, .minute], from: Date())
        let year = String(components.year!)
        let month = String(components.month!)
        let day = String(components.day!)
        let hour = String(components.hour!)
        let minute = String(components.minute!)
        let sender = "Teachers/" + userId
        if selectedQuestionType == "essay" {
            guard let question = textQuestionTextView.text , !question.isEmpty else {return}
            request = SendQuestionRequest.sendQuestion(groups: selectedGroups, year: year, month: month, day: day, hour: hour, minute: minute, sender: sender, questionBody: question, type: selectedQuestionType, choices: nil, accessToken: token)
        } else {
            guard let question = multipleChoiceTextView.text , !question.isEmpty else {return}
            guard let firstChoice = optionOneTextField.text else {return}
            guard let secondChoice = optionTwoTextField.text else{return}
            guard let thirdChoice = optionThreeTextField.text else {return}
            guard let fourthChoice = optionFourTextField.text else {return}
            let choices: [String] = [firstChoice,secondChoice,thirdChoice,fourthChoice].filter({$0 != ""})
            request = SendQuestionRequest.sendQuestion(groups: selectedGroups, year: year, month: month, day: day, hour: hour, minute: minute, sender: sender, questionBody: question, type: selectedQuestionType, choices: choices, accessToken: token)
        }
        self.showActivityIndicator()
        request?.send(BaseResponseModel.self, completion: {[weak self] (response) in
            self?.handleSendQuestionResponse(response)
        })
    }
    
    // MARK:- Functions
    fileprivate func setViewsUI() {
        if MOLHLanguage.currentAppleLanguage() == "ar"{
            backButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }
        
        textQuestionButton.layer.borderWidth = 1
        textQuestionButton.layer.borderColor = UIColor.lightGray.cgColor
        textQuestionButton.layer.cornerRadius = textQuestionButton.frame.width / 2
        textQuestionButton.clipsToBounds = true
        
        multipleChoiceButton.layer.borderWidth = 1
        multipleChoiceButton.layer.borderColor = UIColor.lightGray.cgColor
        multipleChoiceButton.layer.cornerRadius = multipleChoiceButton.frame.width / 2
        multipleChoiceButton.clipsToBounds = true
        
        addOptionsView.layer.borderWidth = 1
        addOptionsView.layer.borderColor = UIColor.lightGray.cgColor
        
        groupsTableView.isSkeletonable = true
    }
    
    fileprivate func setViewsData() {
        getTeacherGroups()
    }
    
    
    fileprivate func getTeacherGroups() {
        guard let teacherId = cache.getString(key: .userId) else {return}
        guard let token = cache.getString(key: .token) else {return}
        groupsArray.removeAll()
        
        groupsTableView.showAnimatedSkeleton()
        request = SendQuestionRequest.getTeacherGroups(teacherId: teacherId, accessToken: token)
        request?.send(TeacherGroupsResponse.self, completion: {[weak self] (response) in
            self?.handleGetTeacherGroupsResponse(response)
        })
    }
    
    fileprivate func handleGetTeacherGroupsResponse(_ response: ServerResponse<TeacherGroupsResponse>) {
        //        groupsArray.append(TeacherGroupsDataResponse(id: "All", name: "Select all", leader: nil, students: [],isSelected: false))
        switch response {
        case .success(let value):
            if value.status == true {
                guard let groups = value.data else {return}
                groupsArray.append(contentsOf: groups)
                DispatchQueue.main.async {
                    self.groupsTableView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
                }
            } else {
                self.groupsTableView.stopSkeletonAnimation()
                self.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
            }
        case .failure(let error):
            print(error)
        }
    }
    
    fileprivate func handleSendQuestionResponse(_ response: ServerResponse<BaseResponseModel>) {
        self.dismissActivityIndicator()
        switch response {
        case .success(let value):
            if value.status == true {
                let sentSuccessfullyVC = SentSuccessfullyVC.instantiate(.sentSuccessfully)
                sentSuccessfullyVC.pageName = "Send Questions To Groups".localized
                navigationRouter.push(view: sentSuccessfullyVC)
            } else {
                guard let message = value.message else {return}
                self.displayAlert(title: "Something went wrong...".localized , subTitle: message, style: .danger)
            }
        case .failure(let error):
            print(error)
        }
    }
    
}
