//
//  Export.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 11.04.19.
//  Copyright © 2019 Martin Mangold. All rights reserved.
//

import UIKit

class Export: NSObject {
    func createTemplate()
    {
    let html = "<b>Welcome <i>World!</i></b> <p><h1><font color='red'>This  is PDF file In swift 3.0</font></h1></p>"
    let frmt = UIMarkupTextPrintFormatter(markupText: html)
    
    //  set print format
    
    let render = UIPrintPageRenderer()
    render.addPrintFormatter(frmt, startingAtPageAt: 0)
    
    //  Create Paper Size for print
    
    let page = CGRect(x: 0, y: 0, width: 595.2, height: 841.8)
    let printable = page.insetBy(dx: 0, dy: 0)
    
    render.setValue(NSValue(cgRect: page), forKey: "paperRect")
    render.setValue(NSValue(cgRect: printable), forKey: "printableRect")
    
    // 4. Create PDF context and draw
    
    let filedata = NSMutableData()
    UIGraphicsBeginPDFContextToData(filedata, CGRect.zero, nil)
    
    for i in 1...render.numberOfPages {
    
    UIGraphicsBeginPDFPage();
    let bounds = UIGraphicsGetPDFContextBounds()
    render.drawPage(at: i - 1, in: bounds)
    }
    
    UIGraphicsEndPDFContext();
    
    // 5. Save PDF file you can also save this file by using another button
    
    
    let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    
    filedata.write(toFile: "\(documentsPath)/myfile.pdf", atomically: true)
    
    }
    
    
    
    func createHeader(mission : Mission) -> String
    {
        let einsatzname : String = mission.reason ?? "unknown"
        var header = """
        <!doctype html>
        <html><head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="ELRD EXPORT" content="width=device-width, initial-scale=1">
        <title>ELRD Einsatz \(einsatzname)</title>
            
            <!-- Bootstrap -->
            <link href="bootstrap-4.0.0.css" rel="stylesheet">
        <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.6.3/css/all.css" integrity="sha384-UHRtZLI+pbxtHCWp1t77Bi1L4ZtiqrqD80Kn4Z8NTSRyMA2Fd33n5dQ8lWUE00s/" crossorigin="anonymous">
        <style type="text/css">
            .typeColumn {
        }
        </style>
        </head>
        """
        
        return header

    }
    /*
    func generateUnit(unit : Unit) -> String
    {
        
    }
    
    func generateSection(section : Section) -> String
    {
        
    }
    
    func generateVictim(victim : Victim) -> String
    {
        
    }
    
    func generateDemageOverview(mission : Mission) -> String
    {
        
    }
    
    func generateDocumentation(mission : Mission) -> String
    {
        
    }
    
    func generateMissionInfo(mission : Mission) -> String
    {
        
    }
    
    func generateSections(mission : Mission) -> String
    {
        
    }
    
    func generateVictims(mission : Mission) -> String
    {
        
    }
    
    func generateDocumentations(mission : Mission) -> String
    {
        
    }
    
    
    func generateBody1(mission : Mission) -> String
    {
        //var body : String = """"""
    }*/
}
