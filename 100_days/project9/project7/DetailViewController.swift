//
//  DetailViewController.swift
//  project7
//
//  Created by Victor Rubenko on 28.02.2021.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    var webView: WKWebView!
    var detailItem: Petition!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let detailItem = detailItem {
            let html = """
                <html>
                <head>
                    <meta name="viewport" content="width=device-width, initial-scale=1">
                    <style> body { font-size: 150%; color: red;} </style>
                </head>
                <body>
                    \(detailItem.body)
                </body>
                </html>
            """
        
            webView.loadHTMLString(html, baseURL: nil)
        }
    }
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
