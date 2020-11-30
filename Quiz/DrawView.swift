//
//  DrawView.swift
//  Quiz
//
//  Created by Angel Jiang on 11/29/20.
//

import UIKit

class DrawView: UIView, UIGestureRecognizerDelegate {
    
    var currentLine: Line?
    var finishedLines = [Line]()
    var selectedLineIndex: Int? {
        didSet {
            if selectedLineIndex == nil {
                let menu = UIMenuController.shared
                menu.hideMenu(from: self)
            }
        }
    }
    var changeColorIndex: Int?
    var moveRecognizer: UIPanGestureRecognizer!
    
    @IBInspectable var finishedLineColor: UIColor = UIColor.black {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var currentLineColor: UIColor = UIColor.red {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var lineThickness: CGFloat = 10 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(DrawView.doubleTap(_:)))
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.delaysTouchesBegan = true
        addGestureRecognizer(doubleTapRecognizer)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(DrawView.tap(_:)))
        tapRecognizer.delaysTouchesBegan = true
        tapRecognizer.require(toFail: doubleTapRecognizer)
        addGestureRecognizer(tapRecognizer)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(DrawView.longPress(_:)))
        addGestureRecognizer(longPressRecognizer)
        
        moveRecognizer = UIPanGestureRecognizer(target: self, action: #selector(DrawView.moveLine(_:)))
        moveRecognizer.delegate = self
        moveRecognizer.cancelsTouchesInView = false
        addGestureRecognizer(moveRecognizer)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
    @objc func moveLine(_ gestureRecognizer: UIPanGestureRecognizer) {
        print("Recognized a pan!")
        
        if let index = selectedLineIndex {
            if gestureRecognizer.state == .changed {
                let translation = gestureRecognizer.translation(in: self)
                
                finishedLines[index].begin.x += translation.x
                finishedLines[index].begin.y += translation.y
                finishedLines[index].end.x += translation.x
                finishedLines[index].end.y += translation.y
                
                gestureRecognizer.setTranslation(CGPoint.zero, in: self)
                
                setNeedsDisplay()
            }
            else {
                return
            }
        }
    }
    
    
    @objc func longPress(_ gestureRecognizer: UIGestureRecognizer) {
        print("Recognized a long press")
        let point = gestureRecognizer.location(in: self)

        if gestureRecognizer.state == .began {
            selectedLineIndex = indexOfLine(at: point)
            
            if selectedLineIndex != nil {
                currentLine = nil
            }
        }
        else if gestureRecognizer.state == .ended {
            selectedLineIndex = nil
            
            
            // pop up pen color
            let menu = UIMenuController.shared

            let orangeStroke = UIMenuItem(title: "Orange", action: #selector(DrawView.changeToOrange(_:)))
            let pinkStroke = UIMenuItem(title: "Pink", action: #selector(DrawView.changeToPink(_:)))
            let purpleStroke = UIMenuItem(title: "Purple", action: #selector(DrawView.changeToPurple(_:)))
            let lightGrayStroke = UIMenuItem(title: "Light Gray", action: #selector(DrawView.changeToLightGray(_:)))

            menu.menuItems = [orangeStroke, pinkStroke, purpleStroke, lightGrayStroke]

            let targetRect = CGRect(x: point.x, y: point.y, width: 2, height: 2)
            menu.showMenu(from: self, rect: targetRect)

        }
        
        setNeedsDisplay()
    }
    
    
    @objc func doubleTap(_ gestureRecognizer: UIGestureRecognizer) {
        print("Recognized a double tap")
        
        selectedLineIndex = nil
        currentLine = nil
        finishedLines.removeAll()
        setNeedsDisplay()
    }
    
    
    @objc func tap(_ gestureRecognizer: UIGestureRecognizer) {
        print("Recognized a tap")
        
        let point = gestureRecognizer.location(in: self)
        selectedLineIndex = indexOfLine(at: point)
        
        let menu = UIMenuController.shared
        
        if selectedLineIndex != nil {
            becomeFirstResponder()
            
            let deleteItem = UIMenuItem(title: "Delete", action: #selector(DrawView.deleteLine(_:)))
            let orangeStroke = UIMenuItem(title: "Orange", action: #selector(DrawView.changeToOrange(_:)))
            let pinkStroke = UIMenuItem(title: "Pink", action: #selector(DrawView.changeToPink(_:)))
            let purpleStroke = UIMenuItem(title: "Purple", action: #selector(DrawView.changeToPurple(_:)))
            let lightGrayStroke = UIMenuItem(title: "Light Gray", action: #selector(DrawView.changeToLightGray(_:)))

            menu.menuItems = [deleteItem, orangeStroke, pinkStroke, purpleStroke, lightGrayStroke]
            
            let targetRect = CGRect(x: point.x, y: point.y, width: 2, height: 2)
            menu.showMenu(from: self, rect: targetRect)
        }
        else {
            menu.hideMenu(from: self)
        }
        
        setNeedsDisplay()
    }
    
    
    func stroke(_ line: Line) {
        let path = UIBezierPath()
        path.lineWidth = lineThickness
        path.lineCapStyle = .round
        
        path.move(to: line.begin)
        path.addLine(to: line.end)
        path.stroke()
    }
    
    
    func indexOfLine(at point: CGPoint) -> Int? {
        for(index, line) in finishedLines.enumerated() {
            let begin = line.begin
            let end = line.end
            
            for t in stride(from: CGFloat(0), to: 1.0, by: 0.05) {
                let x = begin.x + ((end.x - begin.x) * t)
                let y = begin.y + ((end.y - begin.y) * t)
                
                if hypot(x - point.x, y - point.y) < 20.0 {
                    return index
                }
            }
        }
        return nil
    }
    
    
    @objc func deleteLine(_ sender: UIMenuController) {
        // how to add alert??
        if let index = self.selectedLineIndex {
            self.finishedLines.remove(at: index)
            self.selectedLineIndex = nil
        }

        setNeedsDisplay()
    }
    
    @objc func changePenToOrange(_ sender: UIMenuController) {
        finishedLineColor = UIColor.orange
    }
    
    
    @objc func changeToOrange(_ sender: UIMenuController) {
        if let index = selectedLineIndex {
            finishedLines[index].color = UIColor.orange
        }
    }
    
    @objc func changeToLightGray(_ sender: UIMenuController) {
        if let index = selectedLineIndex {
            finishedLines[index].color = UIColor.lightGray
        }
    }
    
    @objc func changeToPink(_ sender: UIMenuController) {
        if let index = selectedLineIndex {
            finishedLines[index].color = UIColor.systemPink
        }
    }
    
    @objc func changeToPurple(_ sender: UIMenuController) {
        if let index = selectedLineIndex {
            finishedLines[index].color = UIColor.purple
        }
    }
    
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    
    override func draw(_ rect: CGRect) {
        for line in finishedLines {
            line.color.setStroke()
            stroke(line)
        }
        
        if let line = currentLine {
            currentLineColor.setStroke()
            stroke(line)
        }
        
        if let index = selectedLineIndex {
            UIColor.green.setStroke()
            let selectedLine = finishedLines[index]
            stroke(selectedLine)
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        
        let location = touch.location(in: self)
        
        currentLine = Line(begin: location, end: location)
        
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        
        currentLine?.end = location
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if var line = currentLine {
            line.color = finishedLineColor
            let touch = touches.first!
            let location = touch.location(in: self)
            line.end = location
                        
            finishedLines.append(line)
        }
        currentLine = nil
        
        setNeedsDisplay()
    }
    
    // don't think it will be called
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
        
        currentLine = nil
    }
    
    
}
