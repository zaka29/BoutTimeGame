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
    var roundsPlayed: Int = 0
    var guessedCorrectly: Int = 0

    @IBOutlet weak var viewCardOne: UIView!
    @IBOutlet weak var viewCardTwo: UIView!
    @IBOutlet weak var viewCardThree: UIView!
    @IBOutlet weak var viewCardFour: UIView!
    @IBOutlet weak var viewFooter: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var imageViewNextRoundSuccess: UIImageView!
    @IBOutlet weak var imageViewNextRoundFail: UIImageView!
    @IBOutlet weak var underButtonTextlabel: UILabel!
    @IBOutlet weak var cardOneLabel: UILabel!
    @IBOutlet weak var cardTwoLabel: UILabel!
    @IBOutlet weak var cardThreeLabel: UILabel!
    @IBOutlet weak var cardFourLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        startGameRound()
        drawBoutGameScreen()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "segueScore" {
            var scoreText: String = "n/a"
            if let rounds = gameRound?.roundsCount {
               scoreText = "\(self.guessedCorrectly)/\(rounds)"
            }
            if let scoreViewController = segue.destination as? ScoreViewController {
                scoreViewController.scoreLabelValue = scoreText
            }
        }
        
        if segue.identifier == "eventFactSegue" {
            if let webPageViewController = segue.destination as? WebPageViewController {
                let factUrl = sender as? String
                webPageViewController.eventFactUrl = factUrl
            }
        }
    }
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        gameRound?.finishGameRound(timerLabel: timerLabel, nextRoundSucces: imageViewNextRoundSuccess, nextRoundFail: imageViewNextRoundFail)
        
        underButtonTextlabel.text = "Tap events to learn more"
        cardOneLabel.isUserInteractionEnabled = true
        cardTwoLabel.isUserInteractionEnabled = true
        cardThreeLabel.isUserInteractionEnabled = true
        cardFourLabel.isUserInteractionEnabled = true
    }
    
    @IBAction func showFact(_ sender: UIGestureRecognizer) {
        // For the next task add each movements urls to HistoryFacts.plist
        // find the way to disable user interaction when round is still being counting the seconds
        // find how to restart on dismiss
        // cardView.isUserInteractionEnabled = false
        guard let cardView = sender.view else {return}
        
        switch cardView.tag {
        case 1:
            let factUrl = gameRound?.cardsSetting[.cardoOne]?.factUrl
            performSegue(withIdentifier: "eventFactSegue", sender: factUrl)
        case 2:
            let factUrl = gameRound?.cardsSetting[.cardoTwo]?.factUrl
            performSegue(withIdentifier: "eventFactSegue", sender: factUrl)
        case 3:
            let factUrl = gameRound?.cardsSetting[.cardoThree]?.factUrl
            performSegue(withIdentifier: "eventFactSegue", sender: factUrl)
        case 4:
            let factUrl = gameRound?.cardsSetting[.cardoFour]?.factUrl
            performSegue(withIdentifier: "eventFactSegue", sender: factUrl)
        default: return
        }
    }
    
    @IBAction func moveCard(_ sender: UIButton) {
        print("Button tag - \(sender.tag)")
        switch sender.tag {
        case 1:
            if let factIn = self.gameRound?.cardsSetting[.cardoTwo], let factOut = self.gameRound?.cardsSetting[.cardoOne] {
                gameRound?.updateCardSettings(cardEvent: factIn, gameCard: .cardoOne)
                gameRound?.updateCardSettings(cardEvent: factOut, gameCard: .cardoTwo)
                
                let factInText = factIn.title
                let factOutText = factOut.title
                
                cardOneLabel.text = factInText
                cardTwoLabel.text = factOutText
            }
            
        case 2:
            if let factIn = self.gameRound?.cardsSetting[.cardoOne], let factOut = self.gameRound?.cardsSetting[.cardoTwo] {
                gameRound?.updateCardSettings(cardEvent: factIn, gameCard: .cardoTwo)
                gameRound?.updateCardSettings(cardEvent: factOut, gameCard: .cardoOne)
                
                let factInText = factIn.title
                let factOutText = factOut.title
                
                cardTwoLabel.text = factInText
                cardOneLabel.text = factOutText
            }
            
        case 3:
            if let factIn = self.gameRound?.cardsSetting[.cardoThree], let factOut = self.gameRound?.cardsSetting[.cardoTwo] {
                gameRound?.updateCardSettings(cardEvent: factIn, gameCard: .cardoTwo)
                gameRound?.updateCardSettings(cardEvent: factOut, gameCard: .cardoThree)
                
                let factInText = factIn.title
                let factOutText = factOut.title
                
                cardTwoLabel.text = factInText
                cardThreeLabel.text = factOutText
            }
            
        case 4:
            if let factIn = self.gameRound?.cardsSetting[.cardoTwo], let factOut = self.gameRound?.cardsSetting[.cardoThree] {
                gameRound?.updateCardSettings(cardEvent: factIn, gameCard: .cardoThree)
                gameRound?.updateCardSettings(cardEvent: factOut, gameCard: .cardoTwo)
                
                let factInText = factIn.title
                let factOutText = factOut.title
                
                cardThreeLabel.text = factInText
                cardTwoLabel.text = factOutText
            }
            
        
        case 5:
            if let factIn = self.gameRound?.cardsSetting[.cardoFour], let factOut = self.gameRound?.cardsSetting[.cardoThree] {
                gameRound?.updateCardSettings(cardEvent: factIn, gameCard: .cardoThree)
                gameRound?.updateCardSettings(cardEvent: factOut, gameCard: .cardoFour)
                
                let factInText = factIn.title
                let factOutText = factOut.title
                
                cardThreeLabel.text = factInText
                cardFourLabel.text = factOutText
            }
            
        case 6:
            if let factIn = self.gameRound?.cardsSetting[.cardoThree], let factOut = self.gameRound?.cardsSetting[.cardoFour] {
                gameRound?.updateCardSettings(cardEvent: factIn, gameCard: .cardoFour)
                gameRound?.updateCardSettings(cardEvent: factOut, gameCard: .cardoThree)
                
                let factInText = factIn.title
                let factOutText = factOut.title
                
                cardFourLabel.text = factInText
                cardThreeLabel.text = factOutText
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
        gameRound?.stopGametimer()
        underButtonTextlabel.text = "Shake to complete"
        imageViewNextRoundSuccess.isHidden = true
        imageViewNextRoundFail.isHidden = true
        
        viewCardOne.layer.cornerRadius = 3
        viewCardTwo.layer.cornerRadius = 3
        viewCardThree.layer.cornerRadius = 3
        viewCardFour.layer.cornerRadius = 3
        
        cardOneLabel.isUserInteractionEnabled = false
        cardTwoLabel.isUserInteractionEnabled = false
        cardThreeLabel.isUserInteractionEnabled = false
        cardFourLabel.isUserInteractionEnabled = false
        
        self.roundsPlayed += 1
        
        do {
            let cardsDataDictionary = try PlistConverter.dictionary(fromFile: "HistoryFacts", ofType: "plist")
            historicalFacts = try BoutGameCardsAdaptor.createCrads(fromDictionary: cardsDataDictionary)
        } catch let error {
            fatalError("\(error)")
        }
        
        if let facts = historicalFacts {
            self.gameRound = BoutTimeGameRound(cardFacts: facts, howManyRounds: 6)
            // Pass the next round buttons views here
            self.gameRound?.startGameTimer(label: timerLabel, nextRoundSucces: imageViewNextRoundSuccess, nextRoundFail: imageViewNextRoundFail, timerCallBack: timerCallBack)
        }
    }
    
    func drawTextLabel(labeltext text: String?) -> UILabel {
        let rect = CGRect(x: 20, y: 20, width: 200, height: 80)
        let textLabel = UILabel(frame: rect)
        
        textLabel.font = UIFont.systemFont(ofSize: 24.0, weight: .light)
        textLabel.numberOfLines = 3
        textLabel.text = text
        textLabel.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        
        return textLabel
    }
    
    func drawBoutGameScreen() {
        cleanGameRoundCardLabelText()
        
        for cardo in GameRoundCards.allCases {
            switch cardo {
            case .cardoOne:
                let labelTtitle = self.gameRound?.cardsSetting[.cardoOne]?.title
                cardOneLabel.text = labelTtitle
                
            case .cardoTwo:
                let labelTtitle = self.gameRound?.cardsSetting[.cardoTwo]?.title
                cardTwoLabel.text = labelTtitle
                
            case .cardoThree:
                let labelTtitle = self.gameRound?.cardsSetting[.cardoThree]?.title
                cardThreeLabel.text = labelTtitle
                
            case .cardoFour:
                let labelTtitle = self.gameRound?.cardsSetting[.cardoFour]?.title
                cardFourLabel.text = labelTtitle
            }
        }
        
    }
    
    func cleanGameRoundCardLabelText() {
        cardOneLabel.text = ""
        cardTwoLabel.text = ""
        cardThreeLabel.text = ""
        cardFourLabel.text = ""
    }
    
    func timerCallBack() {
        underButtonTextlabel.text = "Tap events to learn more"
        cardOneLabel.isUserInteractionEnabled = true
        cardTwoLabel.isUserInteractionEnabled = true
        cardThreeLabel.isUserInteractionEnabled = true
        cardFourLabel.isUserInteractionEnabled = true
    }
  
    @IBAction func nextRound(_ sender: UITapGestureRecognizer) {
        print("Next round tapped: Correct guesese: \(self.guessedCorrectly)")
        
        guard sender.view != nil else { return }
        
        // Set correct or fail guess
        if let guessedCorrectly = gameRound?.roundVictory {
            if (guessedCorrectly){
                self.guessedCorrectly += 1
            }
        }
        
        if let rounds = gameRound?.roundsCount {
            if(roundsPlayed > rounds) {
                // do some optimisation here: stop kill existing timer and the game
                gameRound?.stopGametimer()
                performSegue(withIdentifier: "segueScore", sender: self)
            } else {
                startGameRound()
                drawBoutGameScreen()
            }
        } else {
            // do some error handling here
            return
        }
    }
    
    @IBAction func startOver(_ sender: UIStoryboardSegue) {
        guard sender.source is ScoreViewController else { return }
        guard sender.source is WebPageViewController else { return }
        self.roundsPlayed = 0
        self.guessedCorrectly = 0
        startGameRound()
        drawBoutGameScreen()
    }
}
