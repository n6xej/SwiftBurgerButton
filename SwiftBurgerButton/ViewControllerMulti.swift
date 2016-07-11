//
//  ViewControllerMulti.swift
//  SwiftBurgerButton
//
//  Created by Christopher Worley on 7/9/16.
//  Copyright © 2016 stashdump.com. All rights reserved.
//

import UIKit

class ViewControllerMulti: UIViewController {

	var burger0: SwiftBurgerButton!
	var burger1: SwiftBurgerButton!
	@IBOutlet weak var burger2: SwiftBurgerButton!
	@IBOutlet weak var burger3: SwiftBurgerButton!
	@IBOutlet weak var burger4: SwiftBurgerButton!
	@IBOutlet weak var burger5: SwiftBurgerButton!
	@IBOutlet weak var burger6: SwiftBurgerButton!
	@IBOutlet weak var burger7: SwiftBurgerButton!
	@IBOutlet weak var burger8: SwiftBurgerButton!
	@IBOutlet weak var burger9: SwiftBurgerButton!
	@IBOutlet weak var burger10: SwiftBurgerButton!
	@IBOutlet weak var burger11: SwiftBurgerButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let width = UIScreen.mainScreen().bounds.size.width / 2
		
		
		let rect = CGRectMake(width - 125, 22, 100, 100)
		
		let vc = SwiftBurgerButton.init(frame: rect)
		vc.lineColor = UIColor.yellowColor()
		vc.viewColor = UIColor.purpleColor()
		vc.alternateAni = true

		self.burger0 = vc
		
		view.addSubview(vc)
		
		let rect1 = CGRectMake(width + 25, 22, 100, 100)
		
		let vc1 = SwiftBurgerButton.init(frame: rect1)
		vc1.lineColor = UIColor.redColor()
		vc1.viewColor = UIColor.blackColor()
		vc1.isMenu = false
		vc1.alternateAni = true
		
		self.burger1 = vc1
		view.addSubview(vc1)
		
		let TVV = 1.0
		
		NSTimer.schedule(delay: 0.13){ timer in
			NSTimer.schedule(repeatInterval: TVV) { timer in
				self.burger0.isMenu = !self.burger0.isMenu
			}
		}
		NSTimer.schedule(delay: 0.43){ timer in
			NSTimer.schedule(repeatInterval: TVV) { timer in
				self.burger1.isMenu = !self.burger1.isMenu
			}
		}
		NSTimer.schedule(delay: 0.71){ timer in
			NSTimer.schedule(repeatInterval: TVV) { timer in
				self.burger2.isMenu = !self.burger2.isMenu
			}
		}
		NSTimer.schedule(delay: 0.33){ timer in
			NSTimer.schedule(repeatInterval: TVV) { timer in
				self.burger3.isMenu = !self.burger3.isMenu
			}
		}
		NSTimer.schedule(delay: 0.6){ timer in
			NSTimer.schedule(repeatInterval: TVV) { timer in
				self.burger4.isMenu = !self.burger4.isMenu
			}
		}
		NSTimer.schedule(delay: 0.84){ timer in
			NSTimer.schedule(repeatInterval: TVV) { timer in
				self.burger5.isMenu = !self.burger5.isMenu
			}
		}
		NSTimer.schedule(delay: 0.92){ timer in
			NSTimer.schedule(repeatInterval: TVV) { timer in
				self.burger6.isMenu = !self.burger6.isMenu
			}
		}
		NSTimer.schedule(delay: 0.79){ timer in
			NSTimer.schedule(repeatInterval: TVV) { timer in
				self.burger7.isMenu = !self.burger7.isMenu
			}
		}
		NSTimer.schedule(delay:0.29){ timer in
			NSTimer.schedule(repeatInterval: TVV) { timer in
				self.burger8.isMenu = !self.burger8.isMenu
			}
		}
		NSTimer.schedule(delay: 0.64){ timer in
			NSTimer.schedule(repeatInterval: TVV) { timer in
				self.burger9.isMenu = !self.burger9.isMenu
			}
		}
		NSTimer.schedule(delay: 0.93){ timer in
			NSTimer.schedule(repeatInterval: TVV) { timer in
				self.burger10.isMenu = !self.burger10.isMenu
			}
		}
		NSTimer.schedule(delay: 0.53){ timer in
			NSTimer.schedule(repeatInterval: TVV) { timer in
				self.burger11.isMenu = !self.burger11.isMenu
			}
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	@IBAction func clickBurger(sender: SwiftBurgerButton) {
		// do not set isMenu on click, taken care of internally

	}


}

extension NSTimer {
	class func schedule(delay delay: NSTimeInterval, handler: NSTimer! -> Void) -> NSTimer {
		let fireDate = delay + CFAbsoluteTimeGetCurrent()
		let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, 0, 0, 0, handler)
		CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, kCFRunLoopCommonModes)
		return timer
	}
	
	class func schedule(repeatInterval interval: NSTimeInterval, handler: NSTimer! -> Void) -> NSTimer {
		let fireDate = interval + CFAbsoluteTimeGetCurrent()
		let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, interval, 0, 0, handler)
		CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, kCFRunLoopCommonModes)
		return timer
	}
}