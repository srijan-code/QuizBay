//
//  LeaderBoardModel.swift
//  QuizBay
//
//  Created by Srijan Kumar  on 09/08/22.
//

import Foundation

struct LeaderBoard: Codable{
    var id: String?
    var name: String?
    var type: String?
    var contestId: String?
    var playerId: String?
    var timeTaken: Double?
    var date: String?
    var score: Int?
    var countOfRightAnswers: Int?
}
