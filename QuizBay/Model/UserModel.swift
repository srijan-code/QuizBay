//
//  UserModel.swift
//  QuizBay
//
//  Created by Srijan Kumar  on 09/08/22.
//

import Foundation

struct User: Codable{
    var id: String?
    var name: String?
    var emailId: String?
    var gender: String?
    var userLevelRating: Double?
    var totalScore: Int?
}
