/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct NotificatioRespons : Codable {
	let notifications : [Notifications]?
	let currentPage : Int?
	let hasNextPage : Bool?
	let hasPreviousPage : Bool?
	let nextPage : Int?
	let previousPage : Int?
	let lastPage : Int?
	let count_un_seen : Int?

	enum CodingKeys: String, CodingKey {

		case notifications = "notifications"
		case currentPage = "currentPage"
		case hasNextPage = "hasNextPage"
		case hasPreviousPage = "hasPreviousPage"
		case nextPage = "nextPage"
		case previousPage = "previousPage"
		case lastPage = "lastPage"
		case count_un_seen = "count_un_seen"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		notifications = try values.decodeIfPresent([Notifications].self, forKey: .notifications)
		currentPage = try values.decodeIfPresent(Int.self, forKey: .currentPage)
		hasNextPage = try values.decodeIfPresent(Bool.self, forKey: .hasNextPage)
		hasPreviousPage = try values.decodeIfPresent(Bool.self, forKey: .hasPreviousPage)
		nextPage = try values.decodeIfPresent(Int.self, forKey: .nextPage)
		previousPage = try values.decodeIfPresent(Int.self, forKey: .previousPage)
		lastPage = try values.decodeIfPresent(Int.self, forKey: .lastPage)
		count_un_seen = try values.decodeIfPresent(Int.self, forKey: .count_un_seen)
	}

}

struct Notifications : Codable {
    let id : Int?
    let title_ar : String?
    let title_en : String?
    let body_ar : String?
    let body_en : String?
    let userId : Int?
    let status : Int?
    let createdAt : String?
    let updatedAt : String?
    
    var title: String{
        if L102Language.isRTL{
            return title_ar ?? ""
        }else{
            return title_en ?? ""
        }
    }

    var body: String{
        if L102Language.isRTL{
            return body_ar ?? ""
        }else{
            return body_en ?? ""
        }
    }
    enum CodingKeys: String, CodingKey {

        case id = "id"
        case title_ar = "title_ar"
        case title_en = "title_en"
        case body_ar = "body_ar"
        case body_en = "body_en"
        case userId = "userId"
        case status = "status"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        title_ar = try values.decodeIfPresent(String.self, forKey: .title_ar)
        title_en = try values.decodeIfPresent(String.self, forKey: .title_en)
        body_ar = try values.decodeIfPresent(String.self, forKey: .body_ar)
        body_en = try values.decodeIfPresent(String.self, forKey: .body_en)
        userId = try values.decodeIfPresent(Int.self, forKey: .userId)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
    }

}
