//
//  CanvasView.swift
//  QBot
//
//  Created by Debashish Das on 04/11/20.
//  Copyright © 2020 debashish. All rights reserved.
//

import UIKit

class CanvasView: UIView {

    //MARK: - Properties
    
    private var path: Path?
    
    private let pathWidth: CGFloat = 4.0
    private let pathColor: UIColor = .orange
    private let pathOpacity: CGFloat = 1.0
    
    private(set) var isPaused = false
    private(set) var isJourneyStarted = false
    
    //<#DESCRIPTION#>
    ///It holds the coordinate points from start to end of robot movement. Can be accessed onces robot completes it's movement.
    /// +VE value Represents : X or Y is increased in X or Y Direction in 2D Plane.
    /// -VE value Represents : X or Y is decreased in X or Y Direction in 2D Plane.
    
    private(set) var robotDirections: [CGPoint]? = []
    
    private var currentPositionIndex: Int?
    private var onReachingDestination: (() -> Void)?
    
    //MARK: Robot View
    private lazy var robot: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
        view.layer.cornerRadius = 22.5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    private var userInteraction: Bool {
        get {
            isUserInteractionEnabled
        }
        set {
            isUserInteractionEnabled = newValue
        }
    }
    //MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    //MARK: - Setup View
    
    private func setupView() {
        self.backgroundColor = .lightGray
    }
    //MARK: - Draw
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let graphicsContext = UIGraphicsGetCurrentContext() else { fatalError() }
        drawPath(context: graphicsContext)
    }
    //MARK:  Draw Path
    
    private func drawPath(context: CGContext) {
        guard let points = path?.points else { return }
        for (index, point) in points.enumerated() {
            if index == 0 {
                context.move(to: point)
                let rect = CGRect(x: point.x - 4, y: point.y - 4, width: 8, height: 8)
                context.addEllipse(in: rect)
                context.closePath()
                context.move(to: point)
            } else {
                context.addLine(to: point)
            }
            context.setStrokeColor(pathColor.cgColor)
            context.setLineWidth(pathWidth)
        }
        context.setLineCap(.round)
        context.drawPath(using: .stroke)
    }
    //MARK: - Touch Handlers
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        path = Path(points: [CGPoint]())
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first?.location(in: nil) else { fatalError() }
        path?.points.append(touch)
        setNeedsDisplay()
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let path = path, !path.points.isEmpty {
            userInteraction = false
        }
    }
    //MARK: - Clear Screen Action
    //<#DESCRIPTION#>
    /// It clears the Canvas in which Path is drawn.
    /// Resets Canvas View properties to initial Values.
    func clearCanvasView() {
        path = nil
        currentPositionIndex = nil
        isPaused = false
        isJourneyStarted = false
        userInteraction = true
        robot.removeFromSuperview()
        setNeedsDisplay()
    }
    //MARK: - Play
    
    //<#DESCRIPTION#>
    /// It's called for the first time to add the robot to the starting point & to start movement of the robot.
    /// It takes a escaping closure as parameter which will be executed after robot reaches last point.
    
    func play(completionHandler: @escaping () -> Void) {
        guard let points = path?.points , !points.isEmpty else {
            path = nil
            print("First Draw a Path")
            isJourneyStarted = false
            return
            
        }
        isJourneyStarted = true
        onReachingDestination = completionHandler
        robotDirections = []
        self.addSubview(robot)
        //TODO: get bot direction here  //getBotDirection(currentPoint: points[0], previousPoint: nil)
        robotDirection(currentPoint: points[0], previousPoint: nil)
        UIView.animate(withDuration: 0.3, animations: {
            self.robot.center = points[0]
        }) { (_) in
            self.moveToPoint(index: 1)
        }
    }
    //MARK: - Pause
    
    //<#DESCRIPTION#>
    /// It is called to Paush & Start the movement of the robot, Once the robot starts it's movement.
    /// After Pause, robot starts it's movement from the last point, where it was paused.
    
    func pause() {
        isPaused.toggle()
        if !isPaused, let position = currentPositionIndex {
            moveToPoint(index: position)
        }
    }
    //MARK: - Bot Direction
    
    //<#DESCRIPTION#>
    /// It calculates the direction of robot in terms of X & Y value of a point
    /// It takes CurrentPosition & PreviousPosition of robot interms of CGPoint.
    
    private func robotDirection(currentPoint: CGPoint, previousPoint: CGPoint?) {
        guard let prevPoint = previousPoint else {
            robotDirections?.append(currentPoint)
            print("\nStarting Point : X : \(currentPoint.x) points, Y : \(currentPoint.y) points\n")
            return
        }
        let xDiff = currentPoint.x - prevPoint.x
        let yDiff = currentPoint.y - prevPoint.y
        robotDirections?.append(CGPoint(x: xDiff, y: yDiff))
        decodeDirection(x: xDiff, y: yDiff)
    }
    
    //<#DESCRIPTION#>
    /// Represents robot movement from Start to End point.
    /// It represents Position of robot in X & Y value of a Point ( type: CGPoint ).
    /// It shows if the current X or Y value is decresed, increased or remains same from the previous value.
    
    private func decodeDirection(x: CGFloat, y: CGFloat) {
        switch (x, y) {
        case let (x, y) where x == 0 && y == 0:
            print("SAME POSITION : X : \(x) points, Y: \(y) points")
        case let (x, y) where x == 0:
            y > 0 ? print("INCREMENT : Y : \(y) points, X : \(x) points") : print("DECREMENT : Y : \(abs(y)) points, X : \(x) points")
        case let (x, y) where y == 0:
            x > 0 ? print("INCREMENT : X : \(x) points, Y : \(y) points") : print("DECREMENT : X : \(abs(x)) points, Y : \(y) points")
        case let (x, y) where x > 0 && y > 0:
            print("INCREMENT : X : \(x) points, INCREMENT : Y : \(y) points")
        case let (x, y) where x < 0 && y < 0:
            print("DECREMENT : X : \(abs(x)) points, DECREMENT : Y : \(abs(y)) points")
        case let (x, y) where x > 0 && y < 0:
            print("INCREMENT : X : \(x) points, DECREMENT : Y : \(abs(y)) points")
        case let (x, y) where x < 0 && y > 0:
            print("DECREMENT : X : \(abs(x)) points, INCREMENT : Y : \(y) points")
        default:
            print("UNKNOWN DIRECTION")
            fatalError()
        }
    }
    //MARK: - Helper Methods
    
    //MARK: 
    private func moveToPoint(index: Int) {
        guard !isPaused else { return }
        guard let points = path?.points, points.count > 1 else { return }
        
        robotDirection(currentPoint: points[index], previousPoint: points[index - 1])
        
        UIView.animate(withDuration: 0.2, delay: 0.05, options: .curveLinear, animations: { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.robot.center = points[index]
        }, completion: { [weak self] _ in
            guard let weakSelf = self else { return }
            if index < points.count - 1 {
                weakSelf.currentPositionIndex = index
                weakSelf.moveToPoint(index: index + 1)
            } else {
                if let completionHandler = weakSelf.onReachingDestination {
                    completionHandler()
                }
                weakSelf.isJourneyStarted = false
            }
        })
    }
}
