//
//  QuestionModel.swift
//  QuizBay
//
//  Created by Srijan Kumar  on 06/08/22.
//

import Foundation

struct Question: Codable {
    let id, question: String?
    let answerList: [AnswerList]?
    let difficulty, category: String?
    let score: Int?
    let questionType: String?
    let url: String?
    let questionFormat: String?
}

struct AnswerList: Codable {
    let id, value: String?
    let position: Int?
    let isCorrect: Bool?
}
