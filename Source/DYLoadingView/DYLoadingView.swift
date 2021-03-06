//
//  DYLoadingView.swift
//  healthy
//
//  Created by 安丹阳 on 2017/11/1.
//  Copyright © 2017年 massagechair. All rights reserved.
//

import UIKit

class DYLoadingView: UIView {
    
    enum LoadingType {
        case none, loading, success, failure
    }

    var loadingType: LoadingType = .none {
        didSet{
            
            if oldValue == loadingType {
                return;
            }
            
            switch  loadingType {
            case .none:
                clear()
            case .loading:
                loading()
            case .success:
                success()
            case .failure:
                failure()
            }
        }
    }
    
    
    var loadingColor: UIColor =  UIColor.blue
    
    var successColor: UIColor = UIColor.green
    
    var failureColor: UIColor = UIColor.red
    
    fileprivate var loadingDuration: TimeInterval = 2.0
    
    fileprivate let markLayerWidth: CGFloat = 48
    
    fileprivate let markLayerHeight: CGFloat = 28
    
    fileprivate var circleLayer: CAShapeLayer = CAShapeLayer()
    
    fileprivate var markLayer: CAShapeLayer = CAShapeLayer()
    
    //MARK:- init
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    fileprivate func setup()  {
        
        layer.addSublayer(circleLayer)
    }
    
    
    convenience init(loadType: LoadingType = .loading) {
        self.init(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        self.loadingType = loadType
    }
    
    func show(in  superView: UIView, isCenter: Bool = true, loadType: LoadingType = .loading){
        
        superView.addSubview(self)
        self.loadingType = .loading
        if isCenter {
            var frame = self.frame
            frame.origin.x = (superView.bounds.width - frame.width) / 2.0
            frame.origin.y = (superView.bounds.height - frame.height) / 2.0
            self.frame = frame
        }
    }
    
    func hide()  {
        
        self.loadingType = .none
        self.removeFromSuperview()
    }
    
    //MARK:- Animations
    func clear() {
        
        circleLayer.removeAllAnimations()
        markLayer.removeAllAnimations()
        markLayer.removeFromSuperlayer()
    }
    
    fileprivate func loading()  {
        
        clear()
        layer.addSublayer(circleLayer)

        let path = UIBezierPath(arcCenter: CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0), radius: bounds.height / 2.0, startAngle: CGFloat.pi * -0.5, endAngle: CGFloat.pi * 1.5, clockwise: true)

        circleLayer.path = path.cgPath
        circleLayer.lineWidth = 6
        circleLayer.strokeColor = loadingColor.cgColor
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = "round"

        let strokeEndAnim = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnim.fromValue = NSNumber(value: 0)
        strokeEndAnim.toValue = NSNumber(value: 1)
        strokeEndAnim.duration = loadingDuration
        strokeEndAnim.repeatCount = MAXFLOAT
        strokeEndAnim.autoreverses = true
       // strokeEndAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        circleLayer.add(strokeEndAnim, forKey: "strokeEndAnim")

        let zAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        zAnim.toValue = NSNumber(value: -Float.pi * 2)
        zAnim.duration = loadingDuration / 2.0
        zAnim.repeatCount = MAXFLOAT
        zAnim.autoreverses = false
        zAnim.isRemovedOnCompletion = true
        self.layer.add(zAnim, forKey: "zAnim")
    }
    
    fileprivate func success()  {
        
        circleLayer.removeAllAnimations()
        layer.removeAllAnimations()
        
        circleLayer.strokeColor = successColor.cgColor
        markLayer.frame = bounds
        layer.addSublayer(markLayer)
        
        let path = UIBezierPath()
        
        let markTop = (bounds.height - markLayerHeight) / 2.0
        let markLeft = (bounds.width - markLayerWidth) / 2.0
        path.move(to: CGPoint(x: markLeft, y: markTop + 15))
        path.addLine(to: CGPoint(x: markLeft + 15, y: markTop + 28))
        path.addLine(to: CGPoint(x: markLeft + 48, y: markTop + 0))
        path.miterLimit = 4
        path.usesEvenOddFillRule = true
        
        markLayer.path = path.cgPath
        markLayer.lineWidth = 6
        markLayer.strokeColor = successColor.cgColor
        markLayer.fillColor = UIColor.clear.cgColor
        markLayer.lineCap = "round"
        
        let strokeEndAnim = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnim.fromValue = NSNumber(value: 0)
        strokeEndAnim.toValue = NSNumber(value: 1)
        strokeEndAnim.duration = 0.5
        strokeEndAnim.timingFunction = CAMediaTimingFunction(name: "easeOut")
        markLayer.add(strokeEndAnim, forKey: "strokeEndAnim")
    }
    
    fileprivate func failure(){
        
        circleLayer.removeAllAnimations()
        layer.removeAllAnimations()
        circleLayer.strokeColor = failureColor.cgColor
        markLayer.frame = bounds
        layer.addSublayer(markLayer)
        
        
        let path = UIBezierPath()
        let  markLayerWidth = self.markLayerWidth / 2.0
        let markTop = (bounds.height - markLayerWidth) / 2.0
        let markLeft = (bounds.width - markLayerWidth) / 2.0
        path.move(to: CGPoint(x: markLeft, y: markTop))
        path.addLine(to: CGPoint(x: markLeft + markLayerWidth, y: markTop + markLayerWidth))
        path.move(to: CGPoint(x: markLeft + markLayerWidth, y: markTop  ))
        path.addLine(to: CGPoint(x: markLeft , y: markTop + markLayerWidth))
        
        markLayer.path = path.cgPath
        markLayer.lineWidth = 6
        markLayer.strokeColor = failureColor.cgColor
        markLayer.fillColor = UIColor.clear.cgColor
        markLayer.lineCap = "round"
        
        let strokeEndAnim = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnim.fromValue = NSNumber(value: 0)
        strokeEndAnim.toValue = NSNumber(value: 1)
        strokeEndAnim.duration = 0.5
        strokeEndAnim.timingFunction = CAMediaTimingFunction(name: "easeOut")
        strokeEndAnim.delegate = self
        strokeEndAnim.setValue("failure_strokeEndAnim", forKey: "animationKey")
        markLayer.add(strokeEndAnim, forKey: "failure_strokeEndAnim")
    }
    
    fileprivate func shake(){
        
        let shakeAnima = CABasicAnimation(keyPath: "transform.rotation.z")
        shakeAnima.fromValue = NSNumber(value: -Float.pi / 12)
        shakeAnima.toValue = NSNumber(value: Float.pi / 12)
        shakeAnima.duration = 0.1
        shakeAnima.repeatCount = 5
        self.layer.add(shakeAnima, forKey: "shakeAnima")
    }
}

extension DYLoadingView: CAAnimationDelegate{
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool){
        
        if let animationKey = anim.value(forKey: "animationKey") as? String ,
            animationKey == "failure_strokeEndAnim" {
            shake()
        }
    }
}
