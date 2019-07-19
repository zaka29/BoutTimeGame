//
//  ViewController.swift
//  BoutTimeGame
//
//  Created by hamster1 on 8/7/19.
//  Copyright © 2019 hamster1. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
   
    var historicalFacts: [HistoryIvent]? = []
    var gameRound: BoutTimeGameRound?
    
    @IBOutlet weak var viewCardOne: UIView!
    @IBOutlet weak var viewCardTwo: UIView!
    @IBOutlet weak var viewCardThree: UIView!
    @IBOutlet weak var viewCardFour: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    
      override func viewDidLoad() {
       
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Starting  the game
        startGameRound()
        initCardsForGameRound()
    }
    
    
    @IBAction func moveCardAction(_ sender: UITapGestureRecognizer) {
        guard sender.view != nil else { return }
        
        print(sender.view!.tag)
    }
    
    func startGameRound() {
        
        do {
            let cardsDataDictionary = try PlistConverter.dictionary(fromFile: "HistoryFacts", ofType: "plist")
            historicalFacts = try BoutGameCardsAdaptor.createCrads(fromDictionary: cardsDataDictionary)
        } catch let error {
            fatalError("\(error)")
        }
        
        if let facts = historicalFacts {
            self.gameRound = BoutTimeGameRound(cardFacts: facts)
            self.gameRound?.startTimer(label: timerLabel)
        }
        
        // Fore debugging  purposes
//        if let facts = historicalFacts {
//            for fact in facts {
//                print(fact.title)
//            }
//        }
    }
    
    func drawTextLabel(labeltext text: String?) -> UILabel {
        let rect = CGRect(x: 10, y: 10, width: 200, height: 25)
        let textLabel = UILabel(frame: rect)
        
        textLabel.text = text
        
        return textLabel
    }
    
    func initCardsForGameRound() {
        
        for cardo in GameRoundCards.allCases {
            switch cardo {
            case .cardoOne:
                let labelText = drawTextLabel(labeltext: "Cardo one")
                viewCardOne.addSubview(labelText)
            case .cardoTwo:
                viewCardTwo.addSubview(drawTextLabel(labeltext: "Card Two"))
            case .cardoThree:
                viewCardThree.addSubview(drawTextLabel(labeltext: "Card Three"))
            case .cardoFour:
                viewCardFour.addSubview(drawTextLabel(labeltext: "Card Four"))
            }
        }
        
    }

}

