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
		fmt.contentInsets = UIEdgeInsets(top: 72, left: 72, bottom: 72, right: 72)
        render.addPrintFormatter(fmt, startingAtPageAt: 0)
		render.headerHeight = 20

        let pageLandscape = CGRect(x: 0, y: 0, width: 781.8, height: 595.2)
		let page = CGRect(x: 0, y: 0, width: 595.2, height: 841.8) // A4, 72 dpi
		let printable = page.insetBy(dx: 80, dy: 80)

		render.setValue(NSValue(cgRect: page), forKey: "paperRect")
		render.setValue(NSValue(cgRect: printable), forKey: "printableRect")
        
        let pdfData = NSMutableData()
		UIGraphicsBeginPDFContextToData(pdfData, page, nil)
        
        for i in 0..<render.numberOfPages {
            //UIGraphicsBeginPDFPage()
			//render.drawHeaderForPage(at: i, in: UIGraphicsGetPDFContextBounds())

				 render.drawContentForPage(at: i, in: UIGraphicsGetPDFContextBounds())//(at: i, in: UIGraphicsGetPDFContextBounds())
			

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
