//
//  NotesViewController.swift
//  Lau_Campus_App
//
//  Created by Guest User on 5/10/23.
//

    import UIKit
    import WebKit

    class NotesViewController: UIViewController, WKNavigationDelegate {

        @IBOutlet weak var webView: WKWebView!
        var username: String?
        var password: String?

        override func viewDidLoad() {
            super.viewDidLoad()
            
            webView.navigationDelegate = self
            
            let eLearnUrl = URL(string: "https://www.prexams.com/unis")!
            
            webView.load(URLRequest(url: eLearnUrl))
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            if webView.url?.absoluteString == "https://elearn.lau.edu.lb/d2l/home" {
                // Login successful, display the user's dashboard page
                print("Login successful!")
            } else {
                // Login failed, display an error message
                print("Login failed!")
            }
        }
    }
