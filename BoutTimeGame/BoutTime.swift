//
//  BoutTime.swift
//  BoutTimeGame
//
//  Created by hamster1 on 10/7/19.
//  Copyright © 2019 hamster1. All rights reserved.
//

import Foundation
import GameKit

protocol HistoryIvent {
    var title: String {get}
    var description: String {get}
    var eventDate: String {get}
}

protocol GameRound {
    var cardsSetting: [GameRoundCards: HistoryIvent] {get set}
    var cardsCorrectOrder: [HistoryIvent] {get set}
    var cardItems: [BoutTimeCard] {get set}
    
    func startTimer()
    func initCorrectOrder()
    func checkOreder()
}

protocol BoutTimeCard {
    var eventFact: HistoryIvent {get set}
    var currentPosition: Int? {get set}
    
    func getCurrentPosition() -> Int?
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

struct RandomFactsGenerator {
    var howManyFacts: Int
    var factsCollection: [Any]
    
    
    mutating func generate() -> [Any] {
        var outputCollection: [Any] = []
        for _ in 1...howManyFacts {
            let randomIndex = GKRandomSource.sharedRandom().nextInt(upperBound: factsCollection.count)
            outputCollection.append(factsCollection[randomIndex])
        }
        
        return outputCollection
    }
    
}

class BoutTimeCardItem: BoutTimeCard {
    var eventFact: HistoryIvent
    var currentPosition: Int?
    
    init(forFact fact: HistoryIvent, position: Int) {
        self.eventFact = fact
        self.currentPosition = position
    }
    
    func getCurrentPosition() -> Int? {
        return self.currentPosition
    }
    
    func setUpdateEvent(event historyEvent: HistoryIvent) {
        self.eventFact = historyEvent
    }
    
}

class BoutTimeGameRound: GameRound {
    var cardsCorrectOrder: [HistoryIvent]
    var cardItems: [BoutTimeCard]
    var cardsSetting: [GameRoundCards : HistoryIvent]
    
    init(cardFacts facts: [HistoryIvent]) {
        var factGenerator = RandomFactsGenerator(howManyFacts: 4, factsCollection: facts)
        let randomFacts = factGenerator.generate()
        
        for (index, fact) in randomFacts.enumerated() {
            if let historyFact = fact as? HistoryIvent {
                let boutTimeCardItem = BoutTimeCardItem(forFact: historyFact, position: index)
                self.cardItems.append(boutTimeCardItem)
            }
        }
        
        self.cardsCorrectOrder = BoutTimeGameRound.calculateCorrectOrder(ofFacts: facts)
        
        for (index, event) in cardsCorrectOrder.enumerated() {
            cardsSetting.updateValue(event, forKey: GameRoundCards.allCases[index])
        }

    }
    
    static func calculateCorrectOrder(ofFacts facts: [HistoryIvent]) -> [HistoryIvent] {
        return facts.sorted(by: {$0.eventDate.compare($1.eventDate) == .orderedDescending})
    }
    
    func startTimer(label: UILabel) {
        var secondsCount: Int = 30
        var timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { timer in
            
            secondsCount -= 1
            let time = TimeInterval(secondsCount)
            let seconds = Int(time) % 60
            
            label.text = "\(String(format:"%02i", seconds))"
            
            if secondsCount < 10 {
                label.textColor = UIColor.init(named: "red")
            }
        
            if secondsCount == 0 {
                timer.invalidate()
            }
        }
    }
    
    func initCorrectOrder() {
        <#code#>
    }
    
    func checkOreder() {
        <#code#>
    }
}

