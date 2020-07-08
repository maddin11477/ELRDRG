//
//  NoticeBookViewController.swift
//  ELRDRG
//
//  Created by Jonas Wehner on 20.03.20.
//  Copyright © 2020 Martin Mangold. All rights reserved.
//

import UIKit
import PencilKit

class NoticeBookViewController: UIViewController {

	var drawView : PKCanvasView?
    override func viewDidLoad() {
        super.viewDidLoad()
		let drawArea = PKCanvasView(frame: .zero)
		drawView = drawArea
		drawArea.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(drawArea)
		NSLayoutConstraint.activate([ drawArea.topAnchor.constraint(equalTo: view.bottomAnchor), drawArea.bottomAnchor.constraint(equalTo: view.bottomAnchor), drawArea.leadingAnchor.constraint(equalTo: view.leadingAnchor), drawArea.trailingAnchor.constraint(equalTo: view.trailingAnchor), ])
    }
    



}
