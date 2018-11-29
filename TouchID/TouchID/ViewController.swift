//
//  ViewController.swift
//  TouchID
//
//  Created by Sergey Pogrebnyak on 11/29/18.
//  Copyright © 2018 Sergey Pogrebnyak. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet fileprivate weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func buttonAction(_ sender: Any) {
        TouchIdFacade.showTouchIDAlert(localozeReasonForShow: "NEEDD", canAuthorizWithPassword: true) { (response) in
            guard !response.isError else {
                let alert = UIAlertController(title: "Error", message: response.errorDescription?.rawValue, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            if response.isSucces {
                self.resultLabel.text = "мой повелитель)"
            } else {
                self.resultLabel.text = "уходи ты не мой..."
            }
        }
    }
}

