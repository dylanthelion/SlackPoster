//
//  ViewController.swift
//  SlackPoster
//
//  Created by dillion on 12/17/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    // UI
    
    var timer : Timer?
    
    // UI state
    
    var running = false
    
    // Outlets

    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var postButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // TextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Timer handler
    
    func postToSlack() {
        let url = NSURL(string: "https://slack.com/api/chat.postMessage") as! URL
        let request = NSMutableURLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postMessage = "token=xoxp-118169922019-117558946657-118325747861-07eac3ce84fb7557172f48ccdd88c508&channel=#ios&text=\(inputTextField.text!)&username=dillion256"
        request.httpBody = postMessage.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            
            if let httpStatus = response as? HTTPURLResponse , httpStatus.statusCode != 200 {
                print("response = \(response)")
            }
            
            let responseString = String(data: data!, encoding: String.Encoding.utf8)
            print("responseString = \(responseString)")
        }
        task.resume()
    }
    
    // IBActions

    @IBAction func togglePost(_ sender: AnyObject) {
        if running {
            timer?.invalidate()
            DispatchQueue.main.async {
                self.postButton.setTitle("Post to Slack", for: .normal)
            }
        } else {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(postToSlack), userInfo: nil, repeats: true)
            DispatchQueue.main.async {
                self.postButton.setTitle("Pause", for: .normal)
            }
        }
        running = !running
    }

}

