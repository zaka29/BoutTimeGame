//
//  ScoreViewController.swift
//  BoutTimeGame
//
//  Created by hamster1 on 23/10/19.
//  Copyright © 2019 hamster1. All rights reserved.
//

import UIKit

class ScoreViewController: UIViewController {
    
    @IBOutlet weak var scoreTextLabel: UILabel!
    @IBOutlet weak var playAgainButtonView: UIImageView!
    
    var scoreLabelValue: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreTextLabel.text = scoreLabelValue
    }
    
    @IBAction func playAgainAction(_ sender: UITapGestureRecognizer) {
        guard sender.view != nil else { return }
        
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
