//
//  ViewController.swift
//  SwiftBurgerButton
//
//  Created by Christopher Worley on 7/10/16.
//  Copyright © 2016 stashdump.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	@IBOutlet weak var burger: SwiftBurgerButton!
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	@IBAction func pressBurger(sender: SwiftBurgerButton) {
		// do not set isMenu on click, taken care of internally
		
		if sender.isMenu {
			print("Was a Burger")
			print("Now an X")
		}
		else {
			print("Was an X")
			print("Now a Burger")
		}
		
	}


}

