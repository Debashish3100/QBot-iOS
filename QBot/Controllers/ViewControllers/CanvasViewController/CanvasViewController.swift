//
//  CanvasViewController.swift
//  QBot
//
//  Created by Debashish Das on 04/11/20.
//  Copyright © 2020 debashish. All rights reserved.
//

import Foundation
import UIKit
class CanvasViewController: UIViewController {
    
    //MARK: - Outlet
    
    @IBOutlet weak var canvasView: CanvasView!
    @IBOutlet weak var controlView: UIView!
    @IBOutlet weak var clearScreenButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    //MARK: - Property
    var isPaused = false
    
    //MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    //MARK: - SetupView
    private func setupView() {
        title = "QBot"
        
        controlView.backgroundColor = .white
        
        clearScreenButton.backgroundColor = .orange
        clearScreenButton.setTitle("Clear Screen", for: .normal)
        clearScreenButton.setTitleColor(.white, for: .normal)
        clearScreenButton.layer.cornerRadius = clearScreenButton.bounds.height / 2
        clearScreenButton.addShadow()
        
        playButton.backgroundColor = .orange
        playButton.setTitle("Play", for: .normal)
        playButton.setTitleColor(.white, for: .normal)
        playButton.layer.cornerRadius = playButton.bounds.height / 2
        playButton.addShadow()
    }
    //MARK: - ClearScreen Button Action
    
    @IBAction func clearScreenAction(_ sender: UIButton) {
        canvasView.clearCanvasView()
    }
    //MARK: - Play ButtonAction
    
    @IBAction func playAction(_ sender: UIButton) {
        if !canvasView.isJourneyStarted {
            canvasView.play { [weak self] in
                guard let weakSelf = self else { return }
                print("\nDirection Coordinates available for Future use (TYPE : CGPoint(x:, y:)\n")
                print(weakSelf.canvasView.robotDirections ?? [])
                DispatchQueue.main.async {
                    weakSelf.playButton.setTitle("Play", for: .normal)
                }
            }
            if canvasView.isJourneyStarted {
                playButton.setTitle("Pause", for: .normal)
            }
        } else {
            if canvasView.isJourneyStarted && !canvasView.isPaused {
                canvasView.pause()
                playButton.setTitle("Play", for: .normal)
            } else if canvasView.isJourneyStarted && canvasView.isPaused {
                canvasView.pause()
                playButton.setTitle("Pause", for: .normal)
            }
        }
    }
}
