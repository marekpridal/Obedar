//
//  FullscreenMapViewModel.swift
//  Obedar
//
//  Created by Marek Přidal on 02.04.18.
//  Copyright © 2018 Marek Pridal. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation
import RxCocoa
import RxSwift

class FullscreenMapViewModel {
    let disposeBag = DisposeBag()
    let data = Variable<[RestaurantTO]>([])
}
