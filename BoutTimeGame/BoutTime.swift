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

enum GameRoundCards: Int, CaseIterable {
    case cardoOne
    case cardoTwo
    case cardoThree
    case cardoFour
}

enum HistoryError: Error {
    case invalidResource
    case conversionFailure
}

struct ArtMovement: HistoryIvent  {
    var title: String
    var description: String
    var eventDate: String
}

class PlistConverter {
    static func dictionary(fromFile name: String, ofType type: String) throws -> [String: AnyObject] {
        guard let path = Bundle.main.path(forResource: name, ofType: type) else {
            throw HistoryError.invalidResource
        }
        
        guard let dictionary = NSDictionary(contentsOfFile: path) as? [String: AnyObject] else {
            throw HistoryError.conversionFailure
        }
        
        return dictionary
    }
}

class BoutGameCardsAdaptor {
    
    static func createCrads(fromDictionary dictionary: [String: AnyObject]) throws -> [HistoryIvent] {
        
        do {
            let dictionary = try PlistConverter.dictionary(fromFile: "HistoryFacts", ofType: "plist")
            let formatter = DateFormatter()
            var cards: [HistoryIvent] = []
            
            for eventItem in dictionary {
                if let item = eventItem.value as? [String: Any], let itemDescription = item["description"] as? String, let itemDate = item["eventDate"] as? Date, let itemName = item["eventName"] as? String {
                    
                    let eventDateString = formatter.string(from: itemDate)
                    let movementItem = ArtMovement(title: itemName, description: itemDescription, eventDate: eventDateString)
            
                    cards.append(movementItem)
                } else {
                    throw HistoryError.conversionFailure
                }
            }
            
            return cards
            
        } catch let error {
            fatalError("\(error)")
        }
    }
}

