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
    var roundVictory: Bool {get set}
    var roundsCount: Int {get set}
    var gameTimer: Timer? {get set}
    
    func startGameTimer(label: UILabel, nextRoundSucces viewSuccess: UIImageView, nextRoundFail viewFail: UIImageView)
    func checkOreder(correctEventsOrder eventsOrder: [HistoryIvent], currentSetting cardSetting: [GameRoundCards: HistoryIvent]) -> Bool
    func updateCardSettings(cardEvent event: HistoryIvent, gameCard card: GameRoundCards)
    func stopGametimer()
    func finishGameRound(timerLabel label: UILabel, nextRoundSucces viewSuccess: UIImageView, nextRoundFail viewFail: UIImageView)
}

protocol BoutTimeCard {
    var eventFact: HistoryIvent {get set}
    var currentPosition: Int? {get set}
    
    func getCurrentPosition() -> Int?
    func setUpdateEvent(event historyEvent: HistoryIvent)
}

enum GameRoundCards: String, CaseIterable {
    case cardoOne
    case cardoTwo
    case cardoThree
    case cardoFour
}

enum HistoryError: Error {
    case invalidResource
    case conversionFailure
}

// Not used, remove when finsished
enum FooterBarState: String {
    case timerIsOn
    case gameRoundFail
    case gameRoundwin
}

struct FooterBarHandler {
    var failedView: UIView
    var winView: UIView
    var timerView: UIView
    
    func renderFooterBarState(barState state: FooterBarState) -> String {
        switch state {
        case .timerIsOn: return "timer"
        case .gameRoundFail: return "fail"
        case .gameRoundwin: return "win"
    
        }
    }
}

struct NextRoundButton {
    var buttonColor: UIColor
    var buttonLabel: UILabel
    var buttonRadius: CGFloat
    var buttonFrame: CGRect
    
    func create() -> UIView {
        let buttonView = UIView(frame: buttonFrame)
        
        buttonView.backgroundColor = buttonColor
        buttonView.layer.cornerRadius = buttonRadius
        buttonView.addSubview(buttonLabel)
        
        
        return buttonView
    }
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
            formatter.dateStyle = .long
            formatter.timeStyle = .long
            
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
    var factsCollection: [HistoryIvent]
    
    mutating func generate() -> [HistoryIvent] {
        var outputCollection: [HistoryIvent] = []
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
    var cardItems: [BoutTimeCard] = []
    var cardsSetting: [GameRoundCards : HistoryIvent] = [:]
    var roundVictory: Bool
    var roundsCount: Int
    var gameTimer: Timer?
    
    init(cardFacts facts: [HistoryIvent], howManyRounds rounds: Int) {
        self.roundVictory = false
        self.roundsCount = rounds
        
        var factGenerator = RandomFactsGenerator(howManyFacts: 4, factsCollection: facts)
        let randomFacts = factGenerator.generate()
        
        
        for (index, fact) in randomFacts.enumerated() {
            let boutTimeCardItem = BoutTimeCardItem(forFact: fact, position: index)
            self.cardItems.append(boutTimeCardItem)
        }
        
        // Init current cards order positions based on random facts selection
        for (index, event) in randomFacts.enumerated() {
            cardsSetting.updateValue(event, forKey: GameRoundCards.allCases[index])
        }
        
        // Here we set correct card items order e.g.correct answer
        self.cardsCorrectOrder = BoutTimeGameRound.calculateCorrectOrder(ofFacts: randomFacts)
        
        print("GameRound creator CardItems length - \(cardItems.count)")
        
    }
    
    static func calculateCorrectOrder(ofFacts facts: [HistoryIvent]) -> [HistoryIvent] {
        return facts.sorted(by: {$0.eventDate.compare($1.eventDate) == .orderedDescending})
    }
    
    func startGameTimer(label: UILabel, nextRoundSucces viewSuccess: UIImageView, nextRoundFail viewFail: UIImageView) {
        guard gameTimer == nil else { return }
        
        var secondsCount: Int = 30
        label.isHidden = false
        
        // debug purposes:
        print("👏🏻 CORRECT ANSWER")
        for (index, eventFact) in self.cardsCorrectOrder.enumerated() {
            print("This \(index) -> \(eventFact.title) - \(eventFact.eventDate)")
        }
        
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            secondsCount -= 1
            let time = TimeInterval(secondsCount)
            let seconds = Int(time) % 60
            
            label.text = "\(String(format:"%02i", seconds))"
            label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
            if secondsCount < 10 {
                label.textColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
            }
        
            if secondsCount == 0 {
                timer.invalidate()
                label.isHidden = true
                if self.checkOreder(correctEventsOrder: self.cardsCorrectOrder, currentSetting: self.cardsSetting) {
                    print("all correct.. 👏🏻")
                    self.roundVictory = true
                    viewSuccess.isHidden = false
                    
                    // debug purposes:
                    for (index, eventFact) in self.cardsCorrectOrder.enumerated() {
                        print("card \(index) -> \(eventFact.title) - \(eventFact.eventDate)")
                    }
                    
                } else {
                    print("sorry you lost.. try again 👾")
                    viewFail.isHidden = false
                    // debug purposes:
                    for (index, eventFact) in self.cardsCorrectOrder.enumerated() {
                        print("card \(index) -> \(eventFact.title) - \(eventFact.eventDate)")
                    }
                    
                }
            }
        }
    }
    
    func checkOreder(correctEventsOrder eventsOrder: [HistoryIvent], currentSetting cardSetting: [GameRoundCards: HistoryIvent]) -> Bool {
        var itemsMatched: [Int] = []
        
        for (index, event) in eventsOrder.enumerated() {
            if event.title == cardSetting[GameRoundCards.allCases[index]]?.title {
                itemsMatched.append(index)
            }
        }
        
        if itemsMatched.count == eventsOrder.count {
            return true
        }
        
        return false
    }
    
    func updateCardSettings(cardEvent event: HistoryIvent, gameCard card: GameRoundCards) {
        self.cardsSetting.updateValue(event, forKey: card)
    }
    
    func stopGametimer() {
        gameTimer?.invalidate()
        gameTimer = nil
    }
    
    func finishGameRound(timerLabel label: UILabel, nextRoundSucces viewSuccess: UIImageView, nextRoundFail viewFail: UIImageView) {
        stopGametimer()
        print("game stopped on shake device gesture")
        label.text = ""
        label.isHidden = true
        if self.checkOreder(correctEventsOrder: self.cardsCorrectOrder, currentSetting: self.cardsSetting) {
            self.roundVictory = true
            viewSuccess.isHidden = false
        } else {
            viewFail.isHidden = false
        }
    }
}

