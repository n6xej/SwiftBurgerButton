//
//  SwiftBurgerButton.swift
//  SwiftBurgerButton
//
//  Created by Christopher Worley on 7/9/16.
//  Copyright © 2016 stashdump.com. All rights reserved.
//
//	The MIT License (MIT)
//
//	Copyright (c) 2016 Christopher Worley
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//	SOFTWARE.
//

import UIKit

@objc
@IBDesignable
public class SwiftBurgerButton: UIButton {

	private var animateDuration: CFTimeInterval = 0.5
	
	private var strokeWidth: CGFloat = 4.0 {
		didSet {
			if strokeWidth != oldValue {
				_topLayer.lineWidth = strokeWidth
				_middleLayer.lineWidth = strokeWidth
				_bottomLayer.lineWidth = strokeWidth
				_rightLayer.lineWidth = strokeWidth
				_leftLayer.lineWidth = strokeWidth
			}
		}
	}

	@objc
	@IBInspectable public var lineColor: UIColor = UIColor.blackColor() {
		didSet {
			if lineColor != oldValue {
				_topLayer.strokeColor = lineColor.CGColor
				_middleLayer.strokeColor = lineColor.CGColor
				_bottomLayer.strokeColor = lineColor.CGColor
				_leftLayer.strokeColor = lineColor.CGColor
				_rightLayer.strokeColor = lineColor.CGColor
			}
		}
	}

	@objc
	@IBInspectable public var viewColor: UIColor = UIColor.lightGrayColor() {
		didSet {
			if lineColor != oldValue {
				_circleLayer.fillColor = viewColor.CGColor
			}
		}
	}
	
	// when using interface inspector to set, the didSet
	// is called after the button initializes, so need to
	// keep it to check for proper init
	private var isInitialized = false
	@objc
	@IBInspectable internal var isMenu: Bool = true {
		didSet {
			
			if isMenu != oldValue {
				if !isInitialized {
					
				}
				else {
					configButton()
				}
			}
			else {
				isInitialized = true
			}
		}
	}

	@objc  // alternate the animation pattern
	@IBInspectable public var alternateAni: Bool = false

	#if TARGET_INTERFACE_BUILDER
	
	@objc // invert the animation pattern
	@IBInspectable var invertAni: Bool = false {
		didSet {
			_rightLayer.path = self._rightPath.CGPath
			_leftLayer.path = self._leftPath.CGPath
		}
	}
	
	#else
	
	@objc // invert the animation pattern
	@IBInspectable var invertAni: Bool = false {
		didSet {
			
			if invertAni != oldValue {
				if invertAni {
					_rightLayer.path = self._rightPathInv.CGPath
					_leftLayer.path = self._leftPathInv.CGPath
				}
				else {
					_rightLayer.path = self._rightPath.CGPath
					_leftLayer.path = self._leftPath.CGPath
				}
			}
		}
	}
	
	#endif

	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}

	// MARK: Interface Builder
	override public func awakeFromNib() {
		commonInit()
	}

	// MARK: Live Render
	override public func prepareForInterfaceBuilder() {
		_rightLayer.path = self._rightPath.CGPath
		_leftLayer.path = self._leftPath.CGPath
		commonInit()
	}

	private func configButton() {

		if isMenu {
			print("hamburger")
			makeBurger()
		} else {
			makeCancelX()
			print("cancel")
		}
	}

	// the button will keep track of own state with button
	// presses. Can programmatically set button with isMenu property
	// but should not set in response to an event from an outlet
	func touchUpInside(sender: UIButton, event: UIEvent) {
		if !isInitialized {
			isInitialized = true
		}

		isMenu = !isMenu
	}

	private func CGPointMakeWithScale(x: CGFloat, y: CGFloat, inverse: Bool? = false) -> CGPoint {

		let ORIGINALSIZE: CGFloat = 50

		var foo = x / ORIGINALSIZE
		foo *= frame.size.width

		var foo1 = y / ORIGINALSIZE

		if inverse! {
			foo1 = (ORIGINALSIZE - y) / ORIGINALSIZE
		}

		foo1 *= frame.size.height

		return CGPointMake(foo, foo1)
	}
	
	private func commonInit() {
		
		let space = fmin(frame.size.width, frame.size.height)
		strokeWidth = ceil(space * 0.08)
		
		self.addTarget(self, action: #selector(SwiftBurgerButton.touchUpInside(_:event:)), forControlEvents: .TouchUpInside)
		
		#if !TARGET_INTERFACE_BUILDER
			
			if alternateAni || invertAni {
				invertAni = !invertAni
			}
			
		#endif
		
		if isMenu {
			
			// set up for menu button
			_rightLayer.strokeStart = 0.0
			_rightLayer.strokeEnd =  msLen / lsLen
			
			_leftLayer.strokeStart = 0.0
			_leftLayer.strokeEnd =   msLen / lsLen
			
			_topLayer.path = _topPath.CGPath
			_middleLayer.path = _middlePath.CGPath
			_bottomLayer.path = _bottomPath.CGPath
			
			_topLayer.hidden = false
			_middleLayer.hidden = false
			_bottomLayer.hidden = false
		}
		else {
			
			// set up for cancel button X lines
			_rightLayer.strokeStart = 1.0 - (cwLen / lsLen) - (bxLen / lsLen)
			_rightLayer.strokeEnd =   1.0 - (bxLen / lsLen)
			
			_leftLayer.strokeStart = 1.0 - (cwLen / lsLen) - (bxLen / lsLen)
			_leftLayer.strokeEnd =   1.0 - (bxLen / lsLen)
			
			_topLayer.path = _middlePath.CGPath
			_bottomLayer.path = _middlePath.CGPath
			
			_topLayer.hidden = true
			_middleLayer.hidden = true
			_bottomLayer.hidden = true
			_leftLayer.hidden = false
			_rightLayer.hidden = false
		}
		
		isInitialized = true
	}

	@objc
	public override func layoutSubviews() {
		super.layoutSubviews()

		if _circleLayer.superlayer != layer {
			layer.addSublayer(_circleLayer)
		}

		if _topLayer.superlayer != layer {
			layer.addSublayer(_topLayer)
		}

		if _middleLayer.superlayer != layer {
			layer.addSublayer(_middleLayer)
		}

		if _bottomLayer.superlayer != layer {
			layer.addSublayer(_bottomLayer)
		}

		if _rightLayer.superlayer != layer {
			layer.addSublayer(_rightLayer)
		}

		if _leftLayer.superlayer != layer {
			layer.addSublayer(_leftLayer)
		}
	}

	lazy private var _rightLayer: CAShapeLayer = {
		let layer = CAShapeLayer()
		layer.path      = self._rightPath.CGPath
		layer.fillColor = self.viewColor.CGColor
		layer.strokeColor = self.lineColor.CGColor
		layer.lineWidth = self.strokeWidth
		layer.lineCap = kCALineCapRound
		layer.fillColor = nil
		layer.hidden = true

		return layer
	}()

	private var _rightPath: UIBezierPath {
		let rightPath = UIBezierPath()

		rightPath.moveToPoint(CGPointMakeWithScale(10, y: 25))
		rightPath.addLineToPoint(CGPointMakeWithScale(40, y: 25))
		rightPath.addLineToPoint(CGPointMakeWithScale(44.26, y: 25))
		rightPath.addCurveToPoint(CGPointMakeWithScale(47.74, y: 24.01), controlPoint1: CGPointMakeWithScale(44.26, y: 24.82), controlPoint2: CGPointMakeWithScale(46.52, y: 25.04))
		rightPath.addCurveToPoint(CGPointMakeWithScale(48.5, y: 22.5), controlPoint1: CGPointMakeWithScale(48.15, y: 23.66), controlPoint2: CGPointMakeWithScale(48.44, y: 23.18))
		rightPath.addCurveToPoint(CGPointMakeWithScale(48.5, y: 21.32), controlPoint1: CGPointMakeWithScale(48.53, y: 22.16), controlPoint2: CGPointMakeWithScale(48.61, y: 21.77))
		rightPath.addCurveToPoint(CGPointMakeWithScale(46.76, y: 15.85), controlPoint1: CGPointMakeWithScale(47.72, y: 18.21), controlPoint2: CGPointMakeWithScale(46.76, y: 15.85))
		rightPath.addLineToPoint(CGPointMakeWithScale(45.22, y: 12.84))
		rightPath.addCurveToPoint(CGPointMakeWithScale(42.28, y: 9.66), controlPoint1: CGPointMakeWithScale(45.22, y: 12.84), controlPoint2: CGPointMakeWithScale(43.6, y: 10.09))
		rightPath.addCurveToPoint(CGPointMakeWithScale(39.75, y: 10.08), controlPoint1: CGPointMakeWithScale(41.64, y: 9.45), controlPoint2: CGPointMakeWithScale(40.2, y: 9.63))
		rightPath.addCurveToPoint(CGPointMakeWithScale(38.64, y: 11.39), controlPoint1: CGPointMakeWithScale(39.15, y: 10.68), controlPoint2: CGPointMakeWithScale(38.64, y: 11.39))
		rightPath.addLineToPoint(CGPointMakeWithScale(7, y: 43))

		return rightPath
	}

	private var _rightPathInv: UIBezierPath {
		let rightPath = UIBezierPath()

		rightPath.moveToPoint(CGPointMakeWithScale(10, y: 25, inverse: true))
		rightPath.addLineToPoint(CGPointMakeWithScale(40, y: 25, inverse: true))
		rightPath.addLineToPoint(CGPointMakeWithScale(44.26, y: 25, inverse: true))
		rightPath.addCurveToPoint(CGPointMakeWithScale(47.74, y: 24.01, inverse: true), controlPoint1: CGPointMakeWithScale(44.26, y: 24.82, inverse: true), controlPoint2: CGPointMakeWithScale(46.52, y: 25.04, inverse: true))
		rightPath.addCurveToPoint(CGPointMakeWithScale(48.5, y: 22.5, inverse: true), controlPoint1: CGPointMakeWithScale(48.15, y: 23.66, inverse: true), controlPoint2: CGPointMakeWithScale(48.44, y: 23.18, inverse: true))
		rightPath.addCurveToPoint(CGPointMakeWithScale(48.5, y: 21.32, inverse: true), controlPoint1: CGPointMakeWithScale(48.53, y: 22.16, inverse: true), controlPoint2: CGPointMakeWithScale(48.61, y: 21.77, inverse: true))
		rightPath.addCurveToPoint(CGPointMakeWithScale(46.76, y: 15.85, inverse: true), controlPoint1: CGPointMakeWithScale(47.72, y: 18.21, inverse: true), controlPoint2: CGPointMakeWithScale(46.76, y: 15.85, inverse: true))
		rightPath.addLineToPoint(CGPointMakeWithScale(45.22, y: 12.84, inverse: true))
		rightPath.addCurveToPoint(CGPointMakeWithScale(42.28, y: 9.66, inverse: true), controlPoint1: CGPointMakeWithScale(45.22, y: 12.84, inverse: true), controlPoint2: CGPointMakeWithScale(43.6, y: 10.09, inverse: true))
		rightPath.addCurveToPoint(CGPointMakeWithScale(39.75, y: 10.08, inverse: true), controlPoint1: CGPointMakeWithScale(41.64, y: 9.45, inverse: true), controlPoint2: CGPointMakeWithScale(40.2, y: 9.63, inverse: true))
		rightPath.addCurveToPoint(CGPointMakeWithScale(38.64, y: 11.39, inverse: true), controlPoint1: CGPointMakeWithScale(39.15, y: 10.68, inverse: true), controlPoint2: CGPointMakeWithScale(38.64, y: 11.39, inverse: true))
		rightPath.addLineToPoint(CGPointMakeWithScale(7, y: 43, inverse: true))

		return rightPath
	}

	lazy private var _leftLayer: CAShapeLayer = {
		let layer = CAShapeLayer()
		layer.path      = self._leftPath.CGPath
		layer.fillColor = self.viewColor.CGColor
		layer.strokeColor = self.lineColor.CGColor
		layer.lineWidth = self.strokeWidth
		layer.lineCap = kCALineCapRound
		layer.fillColor = nil
		layer.hidden = true

		return layer
	}()

	private var _leftPath: UIBezierPath {
		let leftPath = UIBezierPath()

		leftPath.moveToPoint(CGPointMakeWithScale(40, y: 25))
		leftPath.addLineToPoint(CGPointMakeWithScale(10, y: 25))
		leftPath.addLineToPoint(CGPointMakeWithScale(5.74, y: 25))
		leftPath.addCurveToPoint(CGPointMakeWithScale(2.26, y: 24.01), controlPoint1: CGPointMakeWithScale(5.74, y: 24.82), controlPoint2: CGPointMakeWithScale(3.48, y: 25.04))
		leftPath.addCurveToPoint(CGPointMakeWithScale(1.5, y: 22.5), controlPoint1: CGPointMakeWithScale(1.85, y: 23.66), controlPoint2: CGPointMakeWithScale(1.56, y: 23.18))
		leftPath.addCurveToPoint(CGPointMakeWithScale(1.5, y: 21.32), controlPoint1: CGPointMakeWithScale(1.47, y: 22.16), controlPoint2: CGPointMakeWithScale(1.39, y: 21.77))
		leftPath.addCurveToPoint(CGPointMakeWithScale(3.24, y: 15.85), controlPoint1: CGPointMakeWithScale(2.28, y: 18.21), controlPoint2: CGPointMakeWithScale(3.24, y: 15.85))
		leftPath.addLineToPoint(CGPointMakeWithScale(4.78, y: 12.84))
		leftPath.addCurveToPoint(CGPointMakeWithScale(7.72, y: 9.66), controlPoint1: CGPointMakeWithScale(4.78, y: 12.84), controlPoint2: CGPointMakeWithScale(6.4, y: 10.09))
		leftPath.addCurveToPoint(CGPointMakeWithScale(10.25, y: 10.08), controlPoint1: CGPointMakeWithScale(8.36, y: 9.45), controlPoint2: CGPointMakeWithScale(9.8, y: 9.63))
		leftPath.addCurveToPoint(CGPointMakeWithScale(11.36, y: 11.39), controlPoint1: CGPointMakeWithScale(10.85, y: 10.68), controlPoint2: CGPointMakeWithScale(11.36, y: 11.39))
		leftPath.addLineToPoint(CGPointMakeWithScale(43, y: 43))

		return leftPath
	}

	private var _leftPathInv: UIBezierPath {
		let leftPath = UIBezierPath()

		leftPath.moveToPoint(CGPointMakeWithScale(40, y: 25, inverse: true))
		leftPath.addLineToPoint(CGPointMakeWithScale(10, y: 25, inverse: true))
		leftPath.addLineToPoint(CGPointMakeWithScale(5.74, y: 25, inverse: true))
		leftPath.addCurveToPoint(CGPointMakeWithScale(2.26, y: 24.01, inverse: true), controlPoint1: CGPointMakeWithScale(5.74, y: 24.82, inverse: true), controlPoint2: CGPointMakeWithScale(3.48, y: 25.04, inverse: true))
		leftPath.addCurveToPoint(CGPointMakeWithScale(1.5, y: 22.5, inverse: true), controlPoint1: CGPointMakeWithScale(1.85, y: 23.66, inverse: true), controlPoint2: CGPointMakeWithScale(1.56, y: 23.18, inverse: true))
		leftPath.addCurveToPoint(CGPointMakeWithScale(1.5, y: 21.32, inverse: true), controlPoint1: CGPointMakeWithScale(1.47, y: 22.16, inverse: true), controlPoint2: CGPointMakeWithScale(1.39, y: 21.77, inverse: true))
		leftPath.addCurveToPoint(CGPointMakeWithScale(3.24, y: 15.85, inverse: true), controlPoint1: CGPointMakeWithScale(2.28, y: 18.21, inverse: true), controlPoint2: CGPointMakeWithScale(3.24, y: 15.85, inverse: true))
		leftPath.addLineToPoint(CGPointMakeWithScale(4.78, y: 12.84, inverse: true))
		leftPath.addCurveToPoint(CGPointMakeWithScale(7.72, y: 9.66, inverse: true), controlPoint1: CGPointMakeWithScale(4.78, y: 12.84, inverse: true), controlPoint2: CGPointMakeWithScale(6.4, y: 10.09, inverse: true))
		leftPath.addCurveToPoint(CGPointMakeWithScale(10.25, y: 10.08, inverse: true), controlPoint1: CGPointMakeWithScale(8.36, y: 9.45, inverse: true), controlPoint2: CGPointMakeWithScale(9.8, y: 9.63, inverse: true))
		leftPath.addCurveToPoint(CGPointMakeWithScale(11.36, y: 11.39, inverse: true), controlPoint1: CGPointMakeWithScale(10.85, y: 10.68, inverse: true), controlPoint2: CGPointMakeWithScale(11.36, y: 11.39, inverse: true))
		leftPath.addLineToPoint(CGPointMakeWithScale(43, y: 43, inverse: true))

		return leftPath
	}

	lazy private var _topLayer: CAShapeLayer = {
		let layer = CAShapeLayer()
		layer.path      = self._topPath.CGPath
		layer.strokeColor = self.lineColor.CGColor
		layer.lineWidth = self.strokeWidth
		layer.lineCap = kCALineCapRound
		layer.fillColor = nil

		return layer
	}()

	private var _topPath: UIBezierPath {

		let topPath = UIBezierPath()

		// top Menu line Path
		topPath.moveToPoint(CGPointMakeWithScale(10, y: 12))
		topPath.addLineToPoint(CGPointMakeWithScale(40, y: 12))

		return topPath
	}

	private var _topPathB: UIBezierPath {
		let topPathB = UIBezierPath()

		// top Menu line Bounce Path
		topPathB.moveToPoint(CGPointMakeWithScale(10, y: 10))
		topPathB.addLineToPoint(CGPointMakeWithScale(40, y: 10))

		return topPathB
	}

	lazy private var _middleLayer: CAShapeLayer = {
		let layer = CAShapeLayer()
		layer.path      = self._middlePath.CGPath
		layer.strokeColor = self.lineColor.CGColor
		layer.lineWidth = self.strokeWidth
		layer.lineCap = kCALineCapRound
		layer.fillColor = nil

		return layer
	}()

	private var _middlePath: UIBezierPath {

		let middlePath = UIBezierPath()

		// middle Menu line Path
		middlePath.moveToPoint(CGPointMakeWithScale(10, y: 25))
		middlePath.addLineToPoint(CGPointMakeWithScale(40, y: 25))

		return middlePath
	}

	lazy private var _bottomLayer: CAShapeLayer = {
		let layer = CAShapeLayer()
		layer.path = self._bottomPath.CGPath
		layer.strokeColor = self.lineColor.CGColor
		layer.lineWidth = self.strokeWidth
		layer.lineCap = kCALineCapRound
		layer.fillColor = nil

		return layer
	}()

	private var _bottomPath: UIBezierPath {

		let bottomPath = UIBezierPath()

		// bottom Menu line Path
		bottomPath.moveToPoint(CGPointMakeWithScale(10, y: 38))
		bottomPath.addLineToPoint(CGPointMakeWithScale(40, y: 38))

		return bottomPath
	}

	private var _bottomPathB: UIBezierPath {
		let bottomPathB = UIBezierPath()

		// bottom Menu line Bounce Path
		bottomPathB.moveToPoint(CGPointMakeWithScale(10, y: 40))
		bottomPathB.addLineToPoint(CGPointMakeWithScale(40, y: 40))

		return bottomPathB
	}

	lazy private var _circleLayer: CAShapeLayer = {
		let layer = CAShapeLayer()
		layer.path      = self._circlePath.CGPath
		layer.fillColor = self.viewColor.CGColor
		layer.strokeColor = nil

		return layer
	}()

	private var _circlePath: UIBezierPath {

		let radiusScale = CGPointMakeWithScale(25, y: 25)

		return UIBezierPath(arcCenter: CGPointMakeWithScale(25, y: 25), radius: fmin(radiusScale.x, radiusScale.y), startAngle: 0.0, endAngle: CGFloat(M_PI * 2.0), clockwise: true)
	}

	private let bxLen: CGFloat = 8.5
	private let cwLen: CGFloat = 85.0
	private let lsLen: CGFloat = 207.0
	private let msLen: CGFloat = 60.0

	private func makeBurger() {

		#if !TARGET_INTERFACE_BUILDER
			if alternateAni {
				invertAni = !invertAni
			}
		#endif

		let repeatCnt: Float = 0.0			// Float.infinity to repeat forver
		let xTime = animateDuration * 0.6		// most of animation spent making X
		let bounceDst =  Double(bxLen)		// the bounce distance
		let barLen =  Double(msLen)			// distance of hamburger bars
		let totalMovement = Double(lsLen)	// total distance to move
		let distanceDelta = totalMovement - barLen - bounceDst	// distance the start or end point will go from start to end
		let timeScale = xTime / distanceDelta	// scale so animation always has same pace
		let totalTimeBouncDst = (totalMovement - barLen) * timeScale // total time to go with bounce distanc
		let bouncTime = totalTimeBouncDst - xTime	// bounce time
		let twoBounceTimes = bouncTime * 2			// double bounce time
		let strokeDelay = animateDuration - xTime		// time for 1st part 2 finish
		let firstAniTime = strokeDelay * 0.95		// safe time to show lt & rt lines
		let menuBounce = firstAniTime * 0.2		// duration of menu bounce
		let delay0 = bouncTime					// delay before strokeEnd moves
		let dur0 = xTime
		let dur1 = twoBounceTimes
		let dur2 = twoBounceTimes + twoBounceTimes
		let delay1 = delay0 + dur2 - bouncTime
		let enddur0 = totalTimeBouncDst
		let durTotal = delay0 + dur0 + dur1 + dur2 + strokeDelay // total duration

		let alpMid = CABasicAnimation(keyPath: "hidden")

		alpMid.fromValue = true
		alpMid.toValue = false
		alpMid.beginTime = enddur0 + dur1 + delay1 - 0.01
		alpMid.duration = 0.02
		alpMid.removedOnCompletion = false
		alpMid.fillMode = kCAFillModeForwards

		let groupMid = CAAnimationGroup()

		groupMid.animations = [alpMid]
		groupMid.duration = durTotal
		groupMid.autoreverses = false
		groupMid.repeatCount = repeatCnt
		groupMid.removedOnCompletion = false
		groupMid.fillMode = kCAFillModeForwards

		let ani0 = CABasicAnimation.init(keyPath: "path")

		ani0.toValue = _topPathB.CGPath
		ani0.fromValue = _middlePath.CGPath
		ani0.beginTime = enddur0 + dur1 + delay1
		ani0.duration = menuBounce
		ani0.removedOnCompletion = false
		ani0.fillMode = kCAFillModeForwards

		let ani0B = CABasicAnimation.init(keyPath: "path")

		ani0B.toValue = _topPath.CGPath
		ani0B.fromValue = _topPathB.CGPath
		ani0B.beginTime = ani0.beginTime + ani0.duration
		ani0B.duration = firstAniTime - menuBounce
		ani0B.removedOnCompletion = false
		ani0B.fillMode = kCAFillModeForwards

		let ani1 = CABasicAnimation.init(keyPath: "path")

		ani1.toValue = _bottomPathB.CGPath
		ani1.fromValue = _middlePath.CGPath
		ani1.beginTime = enddur0 + dur1 + delay1
		ani1.duration = menuBounce
		ani1.removedOnCompletion = false
		ani1.fillMode = kCAFillModeForwards

		let ani1B = CABasicAnimation.init(keyPath: "path")

		ani1B.toValue = _bottomPath.CGPath
		ani1B.fromValue = _bottomPathB.CGPath
		ani1B.beginTime = ani1.beginTime + ani1.duration
		ani1B.duration = firstAniTime - menuBounce
		ani1B.removedOnCompletion = false
		ani1B.fillMode = kCAFillModeForwards

		let groupTop = CAAnimationGroup()

		groupTop.animations = [ani0, ani0B, alpMid]
		groupTop.duration = durTotal
		groupTop.autoreverses = false
		groupTop.repeatCount = repeatCnt
		groupTop.removedOnCompletion = false
		groupTop.fillMode = kCAFillModeForwards

		let groupBottom = CAAnimationGroup()

		groupBottom.animations = [ani1, ani1B, alpMid]
		groupBottom.duration = durTotal
		groupBottom.autoreverses = false
		groupBottom.repeatCount = repeatCnt
		groupBottom.removedOnCompletion = false
		groupBottom.fillMode = kCAFillModeForwards

		let end1 = CABasicAnimation(keyPath: "strokeEnd")

		end1.toValue = 1.0
		end1.fromValue = 1.0 - (bxLen / lsLen)
		end1.beginTime = delay1
		end1.duration = dur1
		end1.removedOnCompletion = false
		end1.fillMode = kCAFillModeForwards

		let end0 = CABasicAnimation(keyPath: "strokeEnd")

		end0.toValue = msLen / lsLen
		end0.fromValue = 1.0
		end0.beginTime = end1.beginTime + end1.duration
		end0.duration = enddur0
		end0.removedOnCompletion = false
		end0.fillMode = kCAFillModeForwards

		let start2 = CABasicAnimation(keyPath: "strokeStart")

		start2.toValue = 1.0 - (cwLen / lsLen) + (bxLen / lsLen)
		start2.fromValue = 1.0 - (cwLen / lsLen) - (bxLen / lsLen)
		start2.beginTime = 0.0
		start2.duration = dur2
		start2.removedOnCompletion = false
		start2.fillMode = kCAFillModeForwards

		let start1 = CABasicAnimation(keyPath: "strokeStart")

		start1.toValue = 1.0 - (cwLen / lsLen) - (bxLen / lsLen)
		start1.fromValue = 1.0 - (cwLen / lsLen) + (bxLen / lsLen)
		start1.beginTime = start2.beginTime + start2.duration
		start1.duration = dur1
		start1.removedOnCompletion = false
		start1.fillMode = kCAFillModeForwards

		let start0 = CABasicAnimation(keyPath: "strokeStart")
		start0.toValue = 0.0
		start0.fromValue = 1.0 - (cwLen / lsLen) - (bxLen / lsLen)
		start0.beginTime = start1.beginTime + start1.duration
		start0.duration = dur0
		start0.removedOnCompletion = false
		start0.fillMode = kCAFillModeForwards

		let alp = CABasicAnimation(keyPath: "hidden")

		alp.toValue = true
		alp.fromValue = false
		alp.beginTime = enddur0 + dur1 + delay1
		alp.duration = 0.1
		alp.removedOnCompletion = false
		alp.fillMode = kCAFillModeForwards

		let groupX = CAAnimationGroup()

		groupX.animations = [end1, end0, start2, start1, start0, alp]
		groupX.duration = durTotal

		groupX.autoreverses = false
		groupX.repeatCount = repeatCnt
		groupX.removedOnCompletion = false
		groupX.fillMode = kCAFillModeForwards

		_middleLayer.addAnimation(groupMid, forKey: "makeaburger")
		_topLayer.addAnimation(groupTop, forKey: "makeaburger")
		_bottomLayer.addAnimation(groupBottom, forKey: "makeaburger")
		_rightLayer.addAnimation(groupX, forKey: "makeaburger")
		_leftLayer.addAnimation(groupX, forKey: "makeaburger")
	}

	private func makeCancelX() {

		let repeatCnt: Float = 0.0			// Float.infinity to repeat forver
		let xTime = animateDuration * 0.6		// most of animation spent making X
		let bounceDst =  Double(bxLen)		// the bounce distance
		let barLen =  Double(msLen)			// distance of hamburger bars
		let totalMovement = Double(lsLen)	// total distance to move
		let distanceDelta = totalMovement - barLen - bounceDst	// distance the start or end point will go from start to end
		let timeScale = xTime / distanceDelta	// scale so animation always has same pace
		let totalTimeBouncDst = (totalMovement - barLen) * timeScale // total time to go with bounce distanc
		let bouncTime = totalTimeBouncDst - xTime	// bounce time
		let twoBounceTimes = bouncTime * 2			// double bounce time
		let strokeDelay = animateDuration - xTime		// time for 1st part 2 finish
		let firstAniTime = strokeDelay * 0.95		// safe time to show lt & rt lines
		let showCross = strokeDelay * 0.98		// when to make the X lines visible
		let delay0 = bouncTime					// delay before strokeEnd moves
		let dur0 = xTime
		let dur1 = twoBounceTimes
		let dur2 = twoBounceTimes + twoBounceTimes
		let delay1 = delay0 + dur2 - bouncTime
		let enddur0 = totalTimeBouncDst
		let durTotal = delay0 + dur0 + dur1 + dur2 + strokeDelay // total duration

		let alpMid = CABasicAnimation(keyPath: "hidden")

		alpMid.fromValue = false
		alpMid.toValue = true
		alpMid.beginTime = strokeDelay
		alpMid.duration = 0.02
		alpMid.removedOnCompletion = false
		alpMid.fillMode = kCAFillModeForwards

		let groupMid = CAAnimationGroup()

		groupMid.animations = [alpMid]
		groupMid.duration = durTotal
		groupMid.autoreverses = false
		groupMid.repeatCount = repeatCnt
		groupMid.removedOnCompletion = false
		groupMid.fillMode = kCAFillModeForwards

		let ani0 = CABasicAnimation.init(keyPath: "path")

		ani0.fromValue = _topPath.CGPath
		ani0.toValue = _middlePath.CGPath
		ani0.beginTime = 0.0
		ani0.duration = firstAniTime
		ani0.removedOnCompletion = false
		ani0.fillMode = kCAFillModeForwards

		let ani1 = CABasicAnimation.init(keyPath: "path")

		ani1.fromValue = _bottomPath.CGPath
		ani1.toValue = _middlePath.CGPath
		ani1.beginTime = 0.0
		ani1.duration = firstAniTime
		ani1.removedOnCompletion = false
		ani1.fillMode = kCAFillModeForwards

		let groupTop = CAAnimationGroup()

		groupTop.animations = [ani0, alpMid]
		groupTop.duration = durTotal
		groupTop.autoreverses = false
		groupTop.repeatCount = repeatCnt
		groupTop.removedOnCompletion = false
		groupTop.fillMode = kCAFillModeForwards

		let groupBottom = CAAnimationGroup()

		groupBottom.animations = [ani1, alpMid]
		groupBottom.duration = durTotal
		groupBottom.autoreverses = false
		groupBottom.repeatCount = repeatCnt
		groupBottom.removedOnCompletion = false
		groupBottom.fillMode = kCAFillModeForwards

		let alp = CABasicAnimation(keyPath: "hidden")

		alp.fromValue = true
		alp.toValue = false
		alp.beginTime = showCross
		alp.duration = 0.1
		alp.removedOnCompletion = false
		alp.fillMode = kCAFillModeForwards

		let start0 = CABasicAnimation(keyPath: "strokeStart")

		start0.fromValue = 0.0
		start0.toValue = 1.0 - (cwLen / lsLen) - (bxLen / lsLen)
		start0.beginTime = strokeDelay + delay0
		start0.duration = dur0
		start0.removedOnCompletion = false
		start0.fillMode = kCAFillModeForwards

		let start1 = CABasicAnimation(keyPath: "strokeStart")

		start1.fromValue = 1.0 - (cwLen / lsLen) - (bxLen / lsLen)
		start1.toValue = 1.0 - (cwLen / lsLen) + (bxLen / lsLen)
		start1.beginTime = start0.beginTime + start0.duration
		start1.duration = dur1
		start1.removedOnCompletion = false
		start1.fillMode = kCAFillModeForwards

		let start2 = CABasicAnimation(keyPath: "strokeStart")

		start2.fromValue = 1.0 - (cwLen / lsLen) + (bxLen / lsLen)
		start2.toValue = 1.0 - (cwLen / lsLen) - (bxLen / lsLen)
		start2.beginTime = start1.beginTime + start1.duration
		start2.duration = dur2
		start2.removedOnCompletion = false
		start2.fillMode = kCAFillModeForwards

		let end0 = CABasicAnimation(keyPath: "strokeEnd")

		end0.fromValue = msLen / lsLen
		end0.toValue = 1.0
		end0.beginTime = strokeDelay
		end0.duration = enddur0
		end0.removedOnCompletion = false
		end0.fillMode = kCAFillModeForwards

		let end1 = CABasicAnimation(keyPath: "strokeEnd")

		end1.fromValue = 1.0
		end1.toValue = 1.0 - (bxLen / lsLen)
		end1.beginTime = end0.beginTime + end0.duration + delay1
		end1.duration = dur1
		end1.removedOnCompletion = false
		end1.fillMode = kCAFillModeForwards

		let groupX = CAAnimationGroup()

		groupX.animations = [alp, start0, start1, start2, end0, end1]
		groupX.duration = durTotal
		groupX.autoreverses = false
		groupX.repeatCount = repeatCnt
		groupX.removedOnCompletion = false
		groupX.fillMode = kCAFillModeForwards

		_middleLayer.addAnimation(groupMid, forKey: "makeacross")
		_topLayer.addAnimation(groupTop, forKey: "makeacross")
		_bottomLayer.addAnimation(groupBottom, forKey: "makeacross")
		_rightLayer.addAnimation(groupX, forKey: "makeacross")
		_leftLayer.addAnimation(groupX, forKey: "makeacross")
	}
}
