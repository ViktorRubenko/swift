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
    var progressView: UIProgressView!
    var websites = ["apple.com", "google.com", "ya.com"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reload))
        
        progressView = UIProgressView(progressViewStyle: .bar)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        let goBackButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(goBack))
        let goForwardButton = UIBarButtonItem(title: "Forward", style: .plain, target: self, action: #selector(goForward))
        
        toolbarItems = [goBackButton, goForwardButton, progressButton, spacer, refresh]
        navigationController?.isToolbarHidden = false
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        let url = URL(string: "https://apple.com")
        webView.load(URLRequest(url: url!))
        webView.allowsBackForwardNavigationGestures = true
        // Do any additional setup after loading the view.
    }
    
    @objc func goBack() {
        webView.goBack()
    }
    
    @objc func goForward() {
        webView.goForward()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    @objc func reload() {
        webView.reload()
    }
    
    @objc func openTapped() {
        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .alert)
        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        self.present(ac, animated: true, completion: nil)
    }
    
    func openPage(action: UIAlertAction) {
        let url = URL(string: "https://" + action.title!)
        webView.load(URLRequest(url: url!))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        
        if let host = url?.host {
            for website in websites {
                if host.contains(website) {
                    decisionHandler(.allow)
                    return
                }
            }
        }
        if url?.host != nil {
            let vc = UIAlertController(title: "URL \(url!) is blocked", message: nil, preferredStyle: .alert)
            vc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(vc, animated: true, completion: nil)
        }
        decisionHandler(.cancel)
    }
    
    override func loadView() {
        super.loadView()
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }


}

