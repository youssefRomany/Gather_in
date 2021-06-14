//
//  NetworkingHelper
//  3emala
//
//  Created by YoussefRomany on 2/20/20.
//  Copyright © 2019 HardTask. All rights reserved.
//
import UIKit
import Alamofire
import MobileCoreServices
import SKActivityIndicatorView


public protocol NetworkingHelperDeleget: NSObjectProtocol {
    func onHelper(getData data:DataResponse<String>,fromApiName name:String , withIdentifier id:String)
    func onHelper(getError error:String,fromApiName name:String , withIdentifier id:String)
}


class NetworkingHelper: NSObject {
    
    
    func showActivityIndicator() {
        SKActivityIndicator.show("Loading")
    }
    
    func dismissActivityIndicator() {
        SKActivityIndicator.dismiss()
    }
    
    ///the network deleget , you must set before calling any method it to get the response.
    weak var deleget: NetworkingHelperDeleget?
    
    
    /// to request from server
    ///
    /// - Parameters:
    ///   - api: api name
    ///   - parm: parameter
    ///   - id: api id
    ///   - loader: show loader or not
    ///   - encoding: encoding description
    ///   - controller: controller description
    ///   - method: method description
    func connectWithHeaderTo(api:String , withParameters parm:[String:Any]? = nil , andIdentifier id:String = "",withLoader loader: Bool = false,withEncoding encoding:ParameterEncoding = JSONEncoding.default, forController controller:UIViewController? = nil, methodType method: HTTPMethod) {
        
        showActivityIndicator()
        
        print("parammmm", parm ?? [])
        
        let headers = ["language": L102Language.currentAppleLanguage(),"Authorization": "Bearer " + UserAccount.shared.Token]
        print("headers", headers)
        
        // JSONEncoding.default in body
        // URLEncoding.default if url and xxx
        Alamofire.request(api, method: method, parameters: parm, encoding:  encoding, headers: headers)
            .responseString { (response) in
                
            switch(response.result) {
            case.success(let data):
                print("success",data)
            case.failure(let error):
                print("Not Success",error)
            }
            self.handleResponse(response: response, forApi: api, andIdentifier: id)
        }
    }
    
    /// use this method to connect to any web service and upload files to it
    ///
    /// - Parameters:
    ///   - images: the images you want to upload to server must be in this format [key:image] , the key is the parameter name in the webservice and because it's array you must put [] after the name
    ///   - api: the api name that you want to send/get data , and should be variable in ApiNames struct
    ///   - parm: the parameters that you want to send to the api , default value is ni
    ///   - id: the id of the request to get it back in the deleget , it can be any string , default value is empty string
    func connectToUploadObject(images: [String:[UIImage]] = [:], withParameters parm:[String:String]? = nil , toApi api:String, andIdentifier id:String = "", fromController controller: UIViewController) {
        
        self.showActivityIndicator()
//        showLoaderForController(controller)

        let headers = ["language": L102Language.currentAppleLanguage(),"Authorization": "Bearer " + UserAccount.shared.Token]

        Alamofire.upload(multipartFormData: { (multipart:MultipartFormData) in
            //loop all parameters to convert it to data and append it to the request
            for (_key,_value) in parm ?? [:] {
                multipart.append(_value.data(using: .utf8) ?? Data(), withName: _key)
            }
            
            for (_key,_imgs) in images {
                for img in _imgs {
                    let data = img.jpegData(compressionQuality: 0.2) ?? Data()
                    multipart.append(data, withName: _key, fileName: "image.jpeg", mimeType: "image/jpeg")
                    print("mrmr", _key, img)
                }
            }
            
//            for (_key, _value) in videosThumblain {
//                let data = _value.jpegData(compressionQuality: 1.0) ?? Data()
//                multipart.append(data, withName: _key, fileName: "image.png", mimeType: "image/png")
//               print("mrmr", _key, _value)
//
//            }
            
            
//            for (_Key, _value) in videos {
//                 multipart.append(_value as! URL, withName: _Key, fileName: "video.mp4", mimeType: "video/mp4")
//            }
                        
        },usingThreshold: UInt64.init(), to: api, method: .post, headers: headers) { (result) in

            switch result {

            case .success(let request, _, _):
                request.responseString(completionHandler: { (response) in
                    self.handleResponse(response: response, forApi: api, andIdentifier: id)
                })
            case .failure(let error):
                print(error,"5arbto")
                self.deleget?.onHelper(getError: "failed to send data", fromApiName: api, withIdentifier: id)
            }
        }
        
    }
   
    
    /// use this method to connect to any web service and upload files to it
    ///
    /// - Parameters:
    ///   - images: the images you want to upload to server must be in this format [key:image] , the key is the parameter name in the webservice and because it's array you must put [] after the name
    ///   - api: the api name that you want to send/get data , and should be variable in ApiNames struct
    ///   - parm: the parameters that you want to send to the api , default value is ni
    ///   - id: the id of the request to get it back in the deleget , it can be any string , default value is empty string
    func connectToUploadMultiObject(videos:[String: AnyObject] = [:] , toApi api:String , withParameters parm:[String:String]? = nil, andIdentifier id:String = "", images: [String:[UIImage]]) {
        
        self.showActivityIndicator()

        let headers = ["language": L102Language.currentAppleLanguage(),"Authorization": "Bearer " + UserAccount.shared.Token]

        Alamofire.upload(multipartFormData: { (multipart:MultipartFormData) in
            //loop all parameters to convert it to data and append it to the request
            for (_key,_value) in parm ?? [:] {
                multipart.append(_value.data(using: .utf8) ?? Data(), withName: _key)
            }
            
            //loop all images to convert it to data and append it to the request
            for (_key,_imgs) in images {
                for img in _imgs {
                    let data = img.jpegData(compressionQuality: 0.2) ?? Data()
                    multipart.append(data, withName: _key, fileName: "image.jpeg", mimeType: "image/jpeg")
                    print("mrmr", _key, img)
                }
            }
            
            
            for (_Key, _value) in videos {
                print("Videooooooo",_Key)
                 multipart.append(_value as! URL, withName: _Key, fileName: "video.mp4", mimeType: "video/mp4")
            }
                        
        },usingThreshold: UInt64.init(), to: api, method: .post, headers: headers) { (result) in

            switch result {

            case .success(let request, _, _):
                request.responseString(completionHandler: { (response) in
                    self.handleResponse(response: response, forApi: api, andIdentifier: id)
                })
            case .failure(let error):
                print(error,"5arbto")
                self.deleget?.onHelper(getError: "failed to send data", fromApiName: api, withIdentifier: id)
            }
        }
        
    }
    
    /// use this method to connect to any web service and upload files to it
    ///
    /// - Parameters:
    ///   - images: the images you want to upload to server must be in this format [key:image] , the key is the parameter name in the webservice and because it's array you must put [] after the name
    ///   - api: the api name that you want to send/get data , and should be variable in ApiNames struct
    ///   - parm: the parameters that you want to send to the api , default value is ni
    ///   - id: the id of the request to get it back in the deleget , it can be any string , default value is empty string
    func connectToUpload(image: UIImage , toApi api:String , withParameters parm:[String:String]? = nil, andIdentifier id:String = "",forController controller:UIViewController) {
        print(parm ?? "noParam")
        let headers = ["language": L102Language.currentAppleLanguage(),"Authorization": "Bearer " + UserAccount.shared.Token]
        // text/html

        self.showActivityIndicator()
        Alamofire.upload(multipartFormData: { (multipart:MultipartFormData) in
            //loop all parameters to convert it to data and append it to the request
            for (_key,_value) in parm ?? [:] {
                multipart.append(_value.data(using: .utf8) ?? Data(), withName: _key)
            }
            
            let data = image.jpegData(compressionQuality: 0.6) ?? Data()
            multipart.append(data, withName: "file", fileName: "image.png", mimeType: "image/png")
            
        }, to: api,method: .post, headers: headers) { (result) in
            switch result {
            case .success(let request, _, _):
                request.responseString(completionHandler: { (response) in
                    self.handleResponse(response: response, forApi: api, andIdentifier: id)
                })
            case .failure:
                mainQueue {
                    hideLoaderForController(controller)
                }
                self.deleget?.onHelper(getError: "failed to send data", fromApiName: api, withIdentifier: id)
            }
        }
    }
    
    
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    //this method handle the response to check if the request has succeeded or not
    fileprivate func handleResponse(response:DataResponse<String> , forApi api:String , andIdentifier id:String){
        print("Response from api : \(api) , with Identifier : \(id)")
        print(response.response?.statusCode ?? 0 , "hwkqhskjqwhskqjwhskqwjsqkjws")
        mainQueue {
            self.dismissActivityIndicator()
        }
        print("responseStatus==",response.response?.statusCode)
        
        switch response.result {
        case .success:
                self.deleget?.onHelper(getData: response, fromApiName: api, withIdentifier: id)

        case .failure:
            self.deleget?.onHelper(getError: "request failed", fromApiName: api, withIdentifier: id)
        }
    }
}

//
//class RegisterationModelAPI {
//    static let instance = RegisterationModelAPI()
//   
//    func getRegisterationData(url: String, phone: String, email: String,password: String, completion: @escaping (RegisterationModel?, RegisterationError?, Error?)->()) {
//        let parameters = [ "customer": ["name": " ","phone": phone, "email": email, "password": password,"role_ids": [3]]
//            ]
//        
//        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: Globalheaders).responseJSON { (response) in
//            switch response.result {
//            case .success(let value):
//                guard let data = response.data else { return }
//                do {
//                    let regData = try JSONDecoder().decode(RegisterationModel.self, from: data)
//                    let regErrorMessage = try JSONDecoder().decode(RegisterationError.self, from: data)
//                    completion(regData, regErrorMessage, nil)
//                } catch let jsonError {
//                    print(jsonError)
//                }
//                
//            case .failure(let error):
//               completion(nil, nil, error)
//            }
//        }
//    }
//}

