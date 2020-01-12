//
//  ExportVC.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 01.07.19.
//  Copyright © 2019 Martin Mangold. All rights reserved.
//

import UIKit
import WebKit

class ExportVC: UIViewController, WKNavigationDelegate {

    public var htmlText : String?
    public var url : URL?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.navigationDelegate = self
        if(htmlText != nil)
        {
            //let request = URLRequest(url: url!)
            webView.loadHTMLString(htmlText!, baseURL: Bundle.main.bundleURL)
           // url = PDFCreator.generatePDFfromHTML(html: htmlText!)
            
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("didfinish")
        
        if(webView.isLoading){
            return
        }
        
        let export = Export()
        
        
        let css = export.getCSSDATA()
               
               let js = "var style = document.createElement('style'); style.innerHTML = '\(css)'; document.head.appendChild(style);"
               
        self.webView.evaluateJavaScript(js, completionHandler: nil)
        
        
        let render = UIPrintPageRenderer()
        render.addPrintFormatter((self.webView?.viewPrintFormatter())!, startingAtPageAt: 0)
        
        //Give your needed size
        let pagewidth = 8.5 * 72.0
        let pageheight = 11 * 72.0
        let page = CGRect(x: 0, y: 0, width: pagewidth , height: pageheight)
        
        render.setValue(NSValue(cgRect:page),forKey:"paperRect")
        render.setValue(NSValue(cgRect:page), forKey: "printableRect")
        
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData,page, nil)
        print("pages: ")
        print(render.numberOfPages)
        for i in 1...render.numberOfPages{
            
            UIGraphicsBeginPDFPage();
            let bounds = UIGraphicsGetPDFContextBounds()
            render.drawPage(at: i-1 , in: bounds)
        }
        
        UIGraphicsEndPDFContext();
        //For locally view page
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(UUID().uuidString + ".pdf")
        url = fileURL
        if !FileManager.default.fileExists(atPath:fileURL.path) {
            do {
                try pdfData.write(to: fileURL)
                print("file saved")
                
            } catch {
                print("error saving file:", error);
            }
        }
    }
    
   
    
    @IBOutlet weak var webView: WKWebView!
    
    @IBAction func abort(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func Safe(_ sender: Any) {
        // 2
        if(url != nil)
        {
            
        let activity = UIActivityViewController(
            activityItems: ["Export Speichern", url!],
            applicationActivities: nil
        )
            activity.popoverPresentationController?.barButtonItem = (sender as! UIBarButtonItem)
        
        // 3
        present(activity, animated: true, completion: nil)
        }
    }
    }
    
    
    
    
    

   

