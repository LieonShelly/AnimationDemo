//
//  FXUser.swift
//  PgImageProEditUISDK
//
//  Created by lieon on 2020/5/28.
//  用户模型
// swiftlint:disable identifier_name missing_docs

import Foundation
/*
public enum FXGender: Int, Codable {
    case male = 1
    case female = 2
    case none = 0
}

public struct FXUser: Codable {
    static var shared: FXUser = FXUser()
    var userId: String?
    var suid: Int?
    var email: String?
    var mobile: String?
    var cc: Int?
    var forgetPass: Int?
    var setPass: Int?
    var avatar: String?
    var backgroundPic: String?
    var country: String?
    var city: String?
    var lastLoginTime: Double?
    var regDateTime: Double?
    var nickname: String?
    var description: String?
    var desc: String?
    var gender: FXGender = .none
    var birthday: String?
    var language: String?
    var token: String?
    var tokenExpire: Double?
    var tokenEnd: Double?
    var firstLogin: Bool = false
    
    fileprivate let queue = DispatchQueue(label: "userData")
    fileprivate var userDataPath: String {
        let document = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, .userDomainMask, true).first
        let path = "/User"
        let userDocument = document! + path
        var isdir: ObjCBool = ObjCBool(true)
        if !FileManager.default.fileExists(atPath: userDocument, isDirectory: &isdir) {
            try? FileManager.default.createDirectory(at: URL(fileURLWithPath: userDocument), withIntermediateDirectories: true, attributes: nil)
        }
        return userDocument
    }
    
    private init() { }
    
    private enum UserCodingKeys: CodingKey {
        case userId
        case suid
        case email
        case mobile
        case cc
        case forgetPass
        case setPass
        case avatar
        case backgroundPic
        case country
        case city
        case lastLoginTime
        case regDateTime
        case nickname
        case description
        case desc
        case gender
        case birthday
        case language
        case token
        case tokenExpire
        case tokenEnd
        case firstLogin
    }
    
    public init(from decoder: Decoder) throws {
        let container = try? decoder.container(keyedBy: UserCodingKeys.self)
        userId = try? container?.decode(String.self, forKey: UserCodingKeys.userId)
        suid = try? container?.decode(Int.self, forKey: UserCodingKeys.suid)
        email = try? container?.decode(String.self, forKey: UserCodingKeys.email)
        mobile = try? container?.decode(String.self, forKey: UserCodingKeys.mobile)
        cc = try? container?.decode(Int.self, forKey: UserCodingKeys.cc)
        forgetPass = try? container?.decode(Int.self, forKey: UserCodingKeys.forgetPass)
        setPass = try? container?.decode(Int.self, forKey: UserCodingKeys.setPass)
        avatar = try? container?.decode(String.self, forKey: UserCodingKeys.avatar)
        backgroundPic = try? container?.decode(String.self, forKey: UserCodingKeys.backgroundPic)
        country = try? container?.decode(String.self, forKey: UserCodingKeys.country)
        city = try? container?.decode(String.self, forKey: UserCodingKeys.city)
        lastLoginTime = try? container?.decode(Double.self, forKey: UserCodingKeys.lastLoginTime)
        regDateTime = try? container?.decode(Double.self, forKey: UserCodingKeys.regDateTime)
        nickname = try? container?.decode(String.self, forKey: UserCodingKeys.nickname)
        description = try? container?.decode(String.self, forKey: UserCodingKeys.description)
        desc = try? container?.decode(String.self, forKey: UserCodingKeys.desc)
        gender = (try? container?.decode(FXGender.self, forKey: UserCodingKeys.gender)) ?? FXGender.none
        birthday = try? container?.decode(String.self, forKey: UserCodingKeys.birthday)
        language = try? container?.decode(String.self, forKey: UserCodingKeys.language)
        token = try? container?.decode(String.self, forKey: UserCodingKeys.token)
        tokenExpire = try? container?.decode(Double.self, forKey: UserCodingKeys.tokenExpire)
        tokenEnd = try? container?.decode(Double.self, forKey: UserCodingKeys.tokenEnd)
        firstLogin = (try? container?.decode(Bool.self, forKey: UserCodingKeys.firstLogin)) ?? false
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: UserCodingKeys.self)
        try? container.encode(userId, forKey: UserCodingKeys.userId)
        try? container.encode(suid, forKey: UserCodingKeys.suid)
        try? container.encode(email, forKey: UserCodingKeys.email)
        try? container.encode(mobile, forKey: UserCodingKeys.mobile)
        try? container.encode(cc, forKey: UserCodingKeys.cc)
        try? container.encode(forgetPass, forKey: UserCodingKeys.forgetPass)
        try? container.encode(avatar, forKey: UserCodingKeys.avatar)
        try? container.encode(backgroundPic, forKey: UserCodingKeys.backgroundPic)
        try? container.encode(country, forKey: UserCodingKeys.country)
        try? container.encode(city, forKey: UserCodingKeys.city)
        try? container.encode(lastLoginTime, forKey: UserCodingKeys.lastLoginTime)
        try? container.encode(regDateTime, forKey: UserCodingKeys.regDateTime)
        try? container.encode(nickname, forKey: UserCodingKeys.nickname)
        try? container.encode(description, forKey: UserCodingKeys.description)
        try? container.encode(desc, forKey: UserCodingKeys.desc)
        try? container.encode(gender, forKey: UserCodingKeys.gender)
        try? container.encode(birthday, forKey: UserCodingKeys.birthday)
        try? container.encode(language, forKey: UserCodingKeys.language)
        try? container.encode(token, forKey: UserCodingKeys.token)
        try? container.encode(tokenExpire, forKey: UserCodingKeys.tokenExpire)
        try? container.encode(tokenEnd, forKey: UserCodingKeys.tokenEnd)
        try? container.encode(firstLogin, forKey: UserCodingKeys.firstLogin)
    }
}

extension FXUser {
    
    /// 从文件读取用户信息
    public func read() {
        let userDataPath = userDatPath()
        printInFace("user - read - userDataPath:\(userDataPath)")
        guard let jsonData = try? Data(contentsOf: URL(fileURLWithPath: userDataPath)) else {
            return
        }
        let decoder = JSONDecoder()
        guard let user =  try? decoder.decode(FXUser.self, from: jsonData) else {
            return
        }
        FXUser.shared = user
        printInFace("---read:\(FXUser.shared)")
    }
    
    
    /// 写入文件
    public  func write(_ complete: ((Bool) -> Void)?) {
        let jsonEncoder = JSONEncoder()
        guard let json = try? jsonEncoder.encode(FXUser.shared) else {
            return
        }
        let userPath = userDatPath()
        printInFace("userPath - write:\(userPath)")
        queue.async(group: nil, qos: .default, flags: .barrier) {
            do {
                try json.write(to: URL(fileURLWithPath: userPath))
                complete?(true)
            } catch {
                complete?(false)
            }
        }
    }
    
    
    /// 更新用户信息（内存和文件中都会更新），若更新的字段存在，则更新这个值，若更新的字段为nil，则会创建这个字段
    /// - Parameter json: 输入的用户信息JSON
    public func update(_ json: [String: Any]) {
        guard let oldJsonData = try? JSONEncoder().encode(FXUser.shared) else {
            return
        }
        guard var oldJSON = try? JSONSerialization.jsonObject(with: oldJsonData, options: .allowFragments) as? [String: Any] else {
            return
        }
        printInFace("update before JSON: \n \(oldJSON)")
        for inputKey in json.keys {
            oldJSON[inputKey] = json[inputKey]
        }
        printInFace("update after JSON: \n \(oldJSON)")
        guard let newJSONData = try? JSONSerialization.data(withJSONObject: oldJSON, options: .fragmentsAllowed) else {
            return
        }
        do {
            let newUser = try JSONDecoder().decode(FXUser.self, from: newJSONData)
            printInFace("new user Data:\n  \(FXUser.shared)")
            newUser.write { (_) in
                FXUser.shared = newUser
            }
        } catch {
            printInFace("eror:\n\(error.localizedDescription)")
        }
    }
    
    private func userDatPath() -> String {
        let userPath = userDataPath + "/" + "user.data"
        if !FileManager.default.fileExists(atPath: userPath) {
            FileManager.default.createFile(atPath: userPath, contents: nil, attributes: nil)
        }
        return userPath
    }
    
}
*/
