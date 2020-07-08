//
//  ExportVC.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 01.07.19.
//  Copyright © 2019 Martin Mangold. All rights reserved.
//

import UIKit
import WebKit
import PDFKit

class ExportVC: UIViewController, WKNavigationDelegate {

    public var htmlText : String?
    public var url : URL?
	public var data : NSMutableData?
    
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

	override func viewWillDisappear(_ animated: Bool) {
		let fileManager = FileManager.default
		let myDocuments = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!.absoluteURL
		do{

		}


		do {
			let mydocs = try fileManager.contentsOfDirectory(at: myDocuments, includingPropertiesForKeys: [URLResourceKey(rawValue: ".pdf")], options: .skipsSubdirectoryDescendants)
			for url in mydocs
			{
				print(url.absoluteString)
				if url.absoluteString.contains(".pdf")
				{
					try fileManager.removeItem(at: url)
					print(url)
				}

			}

		} catch {
			return
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
        
		let pageLandscape = CGRect(x: 0, y: 10, width: 791.8, height: 595.2) // A4, 72 dpi
		let page = CGRect(x: 0, y: 0, width: 595.2, height: 841.8) // A4, 72
		let printable = page.insetBy(dx: 0, dy: 0)

		render.setValue(NSValue(cgRect: page), forKey: "paperRect")
		render.setValue(NSValue(cgRect: printable), forKey: "printableRect")
        
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
            activityItems: ["Export Speichern", url],
            applicationActivities: nil
        )


            activity.popoverPresentationController?.barButtonItem = (sender as! UIBarButtonItem)
        
        // 3
        present(activity, animated: true, completion: nil)
        }
    }
    }
    
    
    
    
    

   

