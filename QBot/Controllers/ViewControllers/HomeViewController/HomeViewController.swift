//
//  HomeViewController.swift
//  QBot
//
//  Created by Debashish Das on 04/11/20.
//  Copyright © 2020 debashish. All rights reserved.
//

//          ------------------------------ INFO ---------------------------------------

    /// 1. Since I didn't have any proper image file of Robot, I have added a generic View as robot ( Color : Black, Shape: Circular )
    /// 2. I have added the "Draw Line" robot Image by taking screenshot from the App.

//          ---------------------------------------------------------------------------

import Foundation
import UIKit

class HomeViewController: UIViewController {
    
    //MARK: - Outlet
    
    @IBOutlet weak var drawLineLabel: UILabel!
    @IBOutlet weak var drawLineImage: UIImageView!
    
    //MARK: - Property
    
    private enum StoryboardID {
        static let homeVC = "HomeViewController"
        static let canvasVC = "CanvasViewController"
    }
    
    //MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    //MARK: - SetupView
    private func setupView() {
        title = "QBot"
        drawLineLabel.text = "Draw line"
        
        //MARK: Tap gesture added to drawLineImage
        drawLineImage.isUserInteractionEnabled = true
        drawLineImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(drawLineImageAction(_:))))
    }
    
    //MARK: - TapGestureAction
    
    @objc func drawLineImageAction(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let canvasViewController = storyboard?.instantiateViewController(withIdentifier: StoryboardID.canvasVC) as? CanvasViewController else { fatalError("CanvasViewController can't be instantiated") }
        navigationController?.pushViewController(canvasViewController, animated: true)
    }
}
