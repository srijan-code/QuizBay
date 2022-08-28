//
//  RegistrationModel.swift
//  QuizBay
//
//  Created by Srijan Kumar  on 09/08/22.
//

import Foundation

struct Registration: Codable {
    let id: String?
    let player: Player?
    let contest: Contest?
    let startTime, endTime: String?
}

struct Contest: Codable {
    let id, startDate, startTime, endDate: String?
    let endTime: String?
    let duration: Int?
    let contestName: String?
    let numberOfQuestions: Int?
    let maximumScore: Int?
    let skipAllowed: Int?
    let difficultyLevel, dateAdded, category, type: String?
    let questionCode: [String]?
    let isEnabled: Bool?
}

struct Player: Codable {
    let id, name, gender, emailId: String?
    let userLevelRating: Double?
    let totalScore: Int?
}
