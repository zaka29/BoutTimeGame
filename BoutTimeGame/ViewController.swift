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
    @IBOutlet weak var viewFooter: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var imageViewNextRoundSuccess: UIImageView!
    @IBOutlet weak var imageViewNextRoundFail: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Starting  the game
        startGameRound()
        drawBoutGameScreen()
    }
    
    
    @IBAction func moveCardAction(_ sender: UITapGestureRecognizer) {
        guard sender.view != nil else { return }
        
        print(sender.view!.tag)
        
        switch sender.view!.tag {
        case 1:
            if let factIn = self.gameRound?.cardsSetting[.cardoTwo], let factOut = self.gameRound?.cardsSetting[.cardoOne] {
                gameRound?.updateCardSettings(cardEvent: factIn, gameCard: .cardoOne)
                gameRound?.updateCardSettings(cardEvent: factOut, gameCard: .cardoTwo)
                
                let factInText = factIn.title
                let factOutText = factOut.title
                
                updateCardlabelText(forCardView: viewCardOne, labelText: factInText)
                updateCardlabelText(forCardView: viewCardTwo, labelText: factOutText)
                
            }
            
        case 2:
            if let factIn = self.gameRound?.cardsSetting[.cardoOne], let factOut = self.gameRound?.cardsSetting[.cardoTwo] {
                gameRound?.updateCardSettings(cardEvent: factIn, gameCard: .cardoTwo)
                gameRound?.updateCardSettings(cardEvent: factOut, gameCard: .cardoOne)
                
                let factInText = factIn.title
                let factOutText = factOut.title
                
                updateCardlabelText(forCardView: viewCardTwo, labelText: factInText)
                updateCardlabelText(forCardView: viewCardOne, labelText: factOutText)
            }
            
        case 3:
            if let factIn = self.gameRound?.cardsSetting[.cardoThree], let factOut = self.gameRound?.cardsSetting[.cardoTwo] {
                gameRound?.updateCardSettings(cardEvent: factIn, gameCard: .cardoTwo)
                gameRound?.updateCardSettings(cardEvent: factOut, gameCard: .cardoThree)
                
                let factInText = factIn.title
                let factOutText = factOut.title
                
                updateCardlabelText(forCardView: viewCardTwo, labelText: factInText)
                updateCardlabelText(forCardView: viewCardThree, labelText: factOutText)
            }
            
        case 4:
            if let factIn = self.gameRound?.cardsSetting[.cardoTwo], let factOut = self.gameRound?.cardsSetting[.cardoThree] {
                gameRound?.updateCardSettings(cardEvent: factIn, gameCard: .cardoThree)
                gameRound?.updateCardSettings(cardEvent: factOut, gameCard: .cardoTwo)
                
                let factInText = factIn.title
                let factOutText = factOut.title
                
                updateCardlabelText(forCardView: viewCardThree, labelText: factInText)
                updateCardlabelText(forCardView: viewCardTwo, labelText: factOutText)
            }
            
        
        case 5:
            if let factIn = self.gameRound?.cardsSetting[.cardoFour], let factOut = self.gameRound?.cardsSetting[.cardoThree] {
                gameRound?.updateCardSettings(cardEvent: factIn, gameCard: .cardoThree)
                gameRound?.updateCardSettings(cardEvent: factOut, gameCard: .cardoFour)
                
                let factInText = factIn.title
                let factOutText = factOut.title
                
                updateCardlabelText(forCardView: viewCardThree, labelText: factInText)
                updateCardlabelText(forCardView: viewCardFour, labelText: factOutText)
            }
            
        case 6:
            if let factIn = self.gameRound?.cardsSetting[.cardoThree], let factOut = self.gameRound?.cardsSetting[.cardoFour] {
                gameRound?.updateCardSettings(cardEvent: factIn, gameCard: .cardoFour)
                gameRound?.updateCardSettings(cardEvent: factOut, gameCard: .cardoThree)
                
                let factInText = factIn.title
                let factOutText = factOut.title
                
                updateCardlabelText(forCardView: viewCardFour, labelText: factInText)
                updateCardlabelText(forCardView: viewCardThree, labelText: factOutText)
            }
            
        default:
            print("Something went wrong")
        }
        
        if let setting = self.gameRound?.cardsSetting {
            for (key, value) in setting {
                print("key == \(key) \n")
                print("value == \(value)")
            }
        }
    }
    
    func startGameRound() {
        imageViewNextRoundSuccess.isHidden = true
        imageViewNextRoundFail.isHidden = true
        
        do {
            let cardsDataDictionary = try PlistConverter.dictionary(fromFile: "HistoryFacts", ofType: "plist")
            historicalFacts = try BoutGameCardsAdaptor.createCrads(fromDictionary: cardsDataDictionary)
        } catch let error {
            fatalError("\(error)")
        }
        
        if let facts = historicalFacts {
            self.gameRound = BoutTimeGameRound(cardFacts: facts)
            // Pass the next round buttons views here
            self.gameRound?.startGameTimer(label: timerLabel, nextRoundSucces: imageViewNextRoundSuccess, nextRoundFail: imageViewNextRoundFail)
        }
        
        // For debugging  purposes
        if let facts = historicalFacts {
            print("Facts length \(facts.count)")
            for fact in facts {
                print(fact.title)
            }
        }
    }
    
    func drawTextLabel(labeltext text: String?) -> UILabel {
        let rect = CGRect(x: 10, y: 10, width: 200, height: 25)
        let textLabel = UILabel(frame: rect)
        
        textLabel.text = text
        
        return textLabel
    }
    
    func drawBoutGameScreen() {
        
        for cardo in GameRoundCards.allCases {
            switch cardo {
            case .cardoOne:
                let labelTtitle = self.gameRound?.cardsSetting[.cardoOne]?.title
                let labelText = drawTextLabel(labeltext: labelTtitle)
                viewCardOne.addSubview(labelText)
                
            case .cardoTwo:
                let labelTtitle = self.gameRound?.cardsSetting[.cardoTwo]?.title
                viewCardTwo.addSubview(drawTextLabel(labeltext: labelTtitle))
                
            case .cardoThree:
                let labelTtitle = self.gameRound?.cardsSetting[.cardoThree]?.title
                viewCardThree.addSubview(drawTextLabel(labeltext: labelTtitle))
                
            case .cardoFour:
                let labelTtitle = self.gameRound?.cardsSetting[.cardoFour]?.title
                viewCardFour.addSubview(drawTextLabel(labeltext: labelTtitle))
            }
        }
        
    }
    
    func updateCardlabelText(forCardView view: UIView, labelText text: String){
        
        for subview in view.subviews {
            if let label = subview as? UILabel {
                label.text = text
            }
        }
    }
  
    @IBAction func nextRound(_ sender: UITapGestureRecognizer) {
        guard sender.view != nil else { return }
        
        print("Next round tapped")
        
        startGameRound()
        drawBoutGameScreen()
    }
}

