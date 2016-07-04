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
    
    private func updateScreenWithEmotlies(emtl: Emotlies?, err: NSError?) {
        if let emotlies = emtl {
            // This has to happen on the main (UI) thread.
            dispatch_async(dispatch_get_main_queue(), {
                self.screen.text = String(emotlies)
            })
        }
        
        // TODO: Report the eventual error here.
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        screen.text = "Waiting..."
        emtlService.updateEmotlies(updateScreenWithEmotlies)
        emtlService.login("michelangelo", password: "michelangelo")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

