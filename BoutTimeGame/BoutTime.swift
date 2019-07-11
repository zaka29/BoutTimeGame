//
//  BoutTime.swift
//  BoutTimeGame
//
//  Created by hamster1 on 10/7/19.
//  Copyright © 2019 hamster1. All rights reserved.
//

import Foundation

protocol HistoryIvent {
    var title: String {get}
    var description: String {get}
    var eventDate: String {get}
}

protocol BoutTimeCard {
    var eventFact: HistoryIvent {get set}
    var currentOrder: Int {get}
    
    func getCurrentOrder() -> Int
    func setUpdateEvent(event historyEvent: HistoryIvent)
}
