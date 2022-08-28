//
//  ContestModel.swift
//  QuizBay
//
//  Created by Srijan Kumar  on 08/08/22.
//

import Foundation
struct ContestModel: Codable {
    let id, startDate, startTime, endDate: String?
    let endTime, contestName: String?
    let  duration:Double?
    let numberOfQuestions, maximumScore, skipAllowed: Int?
    let difficultyLevel, dateAdded: String?
    let time: Double?
    let category, type: String?
    let quizMasterId: String?
    let questionCode: [String]?
    let isEnabled: Bool?
}
