//
//  WebPageViewController.swift
//  BoutTimeGame
//
//  Created by hamster1 on 6/11/19.
//  Copyright © 2019 hamster1. All rights reserved.
//

import UIKit
import WebKit

class WebPageViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var eventFactUrl: String!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: eventFactUrl)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
}
