//
//  ViewController.swift
//  project4
//
//  Created by Victor Rubenko on 27.02.2021.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reload))
        
        toolbarItems = [spacer, refresh]
        navigationController?.isToolbarHidden = false
        
        let url = URL(string: "https://pals-geo.ru")
        webView.load(URLRequest(url: url!))
        webView.allowsBackForwardNavigationGestures = true
        // Do any additional setup after loading the view.
    }
    
    @objc func reload() {
        webView.reload()
    }
    
    @objc func openTapped() {
        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "apple.com", style: .default, handler: openPage))
        ac.addAction(UIAlertAction(title: "google.com", style: .default, handler: openPage))
        ac.addAction(UIAlertAction(title: "ya.com", style: .default, handler: openPage))
        self.present(ac, animated: true, completion: nil)
    }
    
    func openPage(action: UIAlertAction) {
        let url = URL(string: "https://" + action.title!)
        webView.load(URLRequest(url: url!))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    override func loadView() {
        super.loadView()
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }


}

