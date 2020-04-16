//
//  ViewController.swift
//  StarRating
//
//  Created by 이유리 on 2020/04/10.
//  Copyright © 2020 이유리. All rights reserved.
//

import UIKit
import Foundation
import RxSwift
import Then
import SnapKit

class ViewController: UIViewController {
    var rateView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
        // MARK: View
        rateView = CustomRateView(frame: CGRect(x: 0, y: 0, width: 300, height: 50), totalStarCount: 5, unFilledImage: #imageLiteral(resourceName: "UnFilledStar"), filledImage: #imageLiteral(resourceName: "FilledStar"))

        self.view.addSubview(rateView)
        
        rateView.snp.makeConstraints {
            $0.size.equalTo(rateView.frame.size)
            $0.center.equalToSuperview()
        }
    }

}

