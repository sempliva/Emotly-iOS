//
//  ViewController.swift
//  GreatApp
//
//  Created by Michelangelo De Simone on 6/22/16.
//  Copyright © 2016 Michelangelo De Simone. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private let emtlService = EmotlyService()
    @IBOutlet weak var screen: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        screen.text = "Waiting..."
        
        emtlService.updateEmotlies { (emtl, err) in
            if let emotlies = emtl {
                self.screen.text = String(emotlies)
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

