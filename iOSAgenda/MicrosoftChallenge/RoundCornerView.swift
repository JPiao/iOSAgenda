//
//  RoundCornerView.swift
//  MicrosoftChallenge
//
//  Created by Jason Piao on 2017-03-19.
//  Copyright © 2017 Jason Piao. All rights reserved.
//

import UIKit

class RoundCornerView: UIView {
    
    //rounding corners of the tag view
    override func awakeFromNib() {
        self.layer.cornerRadius = 10
        
    }
}
