/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct DepartmentRespons : Codable {
	let name : String?
	let code : String?
	let id : Int?
	let Groups : [Groups]?
	let user : UserData?

}

struct Groups : Codable {
    let id : Int?
    let name : String?
    let master : ProfileModel?
    let join : Bool?
    let members_count : Int?
    let members: [MemberData]?
    let leader: LeaderData?
}

struct UserData : Codable {
    let email : String?
    let fullName : String?
}

struct MemberData : Codable {
    var email: String?
    var fullName: String?
    var kind: String?
    var picture: String?
    var id: Int?
}

struct LeaderData : Codable {
    var email: String?
    var fullName: String?
    var id: Int?
}


