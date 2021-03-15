//
//  DetailWebController.swift
//  Project16
//
//  Created by Victor Rubenko on 16.03.2021.
//

import UIKit
import WebKit

class DetailWebController: UIViewController, WKNavigationDelegate {
    
    var placeName: String!
    var url: URL!
    var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = placeName
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        webView.load(URLRequest(url: url))

    }

}
