//
//  ViewController.swift
//  CastAnything
//
//  Created by Valay Patel on 2016-09-24.
//  Copyright © 2016 FirstAim. All rights reserved.
//

import UIKit
import GoogleCast
import AVFoundation
import AVKit
import WebKit

class ViewController: UIViewController,GCKSessionManagerListener,UIWebViewDelegate {

    var castButton: GCKUICastButton?
    @IBOutlet var webView: UIWebView?
    private var castSessionManager: GCKSessionManager?
    private var castSession: GCKCastSession?
    
//    override func loadView() {
//        let webConfiguration = WKWebViewConfiguration()
//        webView = WKWebView(frame: .zero, configuration: webConfiguration)
//        view = webView
//    }
    
    func windowDidBecomeVisible(notification: NSNotification) {
//        for mainWindow in UIApplication.shared.windows {
//            for mainWindowSubview in mainWindow.subviews {
//                // this will print:
//                // 1: `WKWebView` + `[WKScrollView]`
//                // 2: `UIView` + `[]`
//                print("\(mainWindowSubview) \(mainWindowSubview.subviews)")
//            }
//        }
        var sorted = UIApplication.shared.windows.sorted { (one, two) -> Bool in
            return one.windowLevel == two.windowLevel
        }
        
        let topWindow = sorted.first
        let controller = topWindow?.rootViewController
        let alert = UIAlertController.init(title: "Cast", message: "Do you want to cast Video", preferredStyle: .actionSheet)
        controller?.dismiss(animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        castSessionManager = GCKCastContext.sharedInstance().sessionManager
        castSessionManager?.add(self)
        castButton = GCKUICastButton.init(frame: CGRect.init(x: 0, y: 0, width: 24, height: 24))
        castButton?.tintColor = UIColor.blue
        
        if let castButton = castButton {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: castButton)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemBecameCurrent(notifcation:)), name: NSNotification.Name(rawValue: "AVPlayerItemBecameCurrentNotification"), object: nil)
        // Do any additional setup after loading the view, typically from a nib.
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(castDeviceDidChange(notification:)), name: NSNotification.Name.gckCastStateDidChange, object: GCKCastContext.sharedInstance())
        
        if let webView = webView {
            if let url = URL.init(string: "https://youtube.com") {
                let request = URLRequest.init(url: url)
                webView.loadRequest(request)
            }
        }
    }
    
    
    func playerItemBecameCurrent(notifcation:NSNotification)
    {
        NotificationCenter.default.addObserver(self, selector: #selector(windowDidBecomeVisible), name: NSNotification.Name.UIWindowDidBecomeVisible, object: nil)
        if let playerItem = notifcation.object as? AVPlayerItem {
            if let asset = playerItem.asset as? AVURLAsset {
                let _ = asset.url
                
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    func castDeviceDidChange(notification:Notification) {
        
    }

}

