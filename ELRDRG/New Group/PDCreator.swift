//
//  PDCreator.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 17.06.19.
//  Copyright © 2019 Martin Mangold. All rights reserved.
//

import UIKit
import WebKit
class PDFCreator: NSObject {
    public static func generatePDFfromHTML(html : String) -> URL
    {
        let render = UIPrintPageRenderer()
        let fmt = UIMarkupTextPrintFormatter(markupText: html)
        render.addPrintFormatter(fmt, startingAtPageAt: 0)
        
        let page = CGRect(x: 0, y: 0, width: 595.2, height: 841.8)
        render.setValue(page, forKey: "paperRect")
        render.setValue(page, forKey: "printableRect")
        
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, .zero, nil)
        
        for i in 0..<render.numberOfPages {
            UIGraphicsBeginPDFPage()
            render.drawPage(at: i, in: UIGraphicsGetPDFContextBounds())
        }
        
        UIGraphicsEndPDFContext()
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let filePath = "\(documentsPath)/" + UUID().uuidString + ".pdf"
        print(filePath)
        let url = NSURL(fileURLWithPath: filePath)
        //let urlRequest = NSURLRequest(url: url as URL)
        return url as URL
    }
}
