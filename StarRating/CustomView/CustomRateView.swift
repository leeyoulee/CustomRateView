//
//  CustomRateView.swift
//  StarRating
//
//  Created by 이유리 on 2020/04/16.
//  Copyright © 2020 이유리. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class CustomRateView: UIView {
    /// 안채워진 별 배열
    var unFilledView = UIView()
    /// 채워진 별 배열
    var filledView = UIView()
    /// 총 별 개수
    var totalStarCount: Int = 0
    /// 선택된 별 개수
    var selectedStarCount = BehaviorRelay<CGFloat>(value: 1)
    /// 별 사이 간격
    var spacing: CGFloat = 5.0
    /// 별의 너비
    var starWidth: CGFloat = 0.0
    
    var disposeBag = DisposeBag()

    public init(frame: CGRect, totalStarCount: Int, unFilledImage: UIImage, filledImage: UIImage) {
        super.init(frame: frame)
        self.totalStarCount = totalStarCount
        self.setGestureRecognizer()

        // 별이미지로 만들어준 스택뷰를 뷰에 붙여줌
        // 안채워진 별뷰 위에 채워진 별뷰를 올려줌
        self.unFilledView = setUpStarRateView(unFilledImage)
        addSubview(self.unFilledView)
        self.filledView = setUpStarRateView(filledImage)
        insertSubview(filledView, aboveSubview: unFilledView)

        self.starWidth = self.unFilledView.frame.size.width / CGFloat(self.totalStarCount) // 별뷰 너비/별 갯수

        animateStarRateView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CustomRateView {
    // MARK: - 스택뷰 세팅
    func setUpStarRateView(_ image: UIImage) -> UIView {
        let rateView = UIView(frame: bounds)
        rateView.clipsToBounds = true

        let stackView = UIStackView(frame: bounds)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = self.spacing
        rateView.addSubview(stackView)

        // 별이미지를 총개수만큼 스택뷰에 쌓아줌
        for _ in 0..<self.totalStarCount {
            let imageView = UIImageView(image: image)
            stackView.addArrangedSubview(imageView)
        }

        return rateView
    }

    // MARK: - 애니메이션 세팅
    func animateStarRateView() {
        self.selectedStarCount.subscribe(onNext: { count in
            DispatchQueue.main.async {
                // timeIntervale을 0.1로 주고, animate주기
                UIView.animate(withDuration: 0.1) {
                    // 선택된 별개수와 별너비를 곱해서 채워진 별의 너비를 계산
                    self.filledView.frame.size.width = count * self.starWidth
                    print("filledView_Width : \(self.filledView.frame.size.width)")
                }
            }
        }).disposed(by: disposeBag)
    }

    // MARK: - 제스쳐 세팅
    func setGestureRecognizer() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        self.addGestureRecognizer(panGesture)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        self.addGestureRecognizer(tapGesture)
    }

    // MARK: - PanGesture
    @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let locationX = recognizer.location(in: self).x
        self.countSelectedStar(locationX: locationX, isPan: true)
    }

    // MARK: - TabGesture
    @objc func handleTapGesture(_ recognizer: UITapGestureRecognizer) {
        let locationX = recognizer.location(in: self).x
        self.countSelectedStar(locationX: locationX, isPan: false)
    }

    // MARK: - setLocationX
    /// 제스쳐의 X값으로 선택된 별의 개수를 계산하는 함수
    func countSelectedStar(locationX: CGFloat, isPan: Bool) {
        var locationX = locationX

        // PanGesture이면
        // X의 최소값을 0으로, 최대값을 뷰의 최대값으로 지정
        if isPan {
            if locationX < 0 {
                locationX = 0
            } else if locationX > bounds.maxX {
                locationX = bounds.maxX
            }
        }

        let starCount = locationX / bounds.width * CGFloat(totalStarCount)
        let ceilCount = ceil(starCount) // 별개수를 반올림, 반내림함
        self.selectedStarCount.accept(ceilCount)
        print("starCount : \(starCount)")
    }
}
