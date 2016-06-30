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
        if err != nil {
            // This has to happen on the main (UI) thread.
            dispatch_async(dispatch_get_main_queue(), {
                self.screen.text = String(err)
            })
        }
    }
    
    private func loginScreen(logged: Bool, err: NSError?) {
        if err != nil {
            // This has to happen on the main (UI) thread.
            dispatch_async(dispatch_get_main_queue(), {
                self.screen.text = String(err)
            })
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        screen.text = "Waiting..."
        emtlService.updateEmotlies(updateScreenWithEmotlies)
        emtlService.login("michelangelo", password: "michelangelo", doneCallback: loginScreen)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

