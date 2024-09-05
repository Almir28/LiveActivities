//
//  OrderStatusBundle.swift
//  OrderStatus
//
//  Created by Almir Khialov on 04.09.2024.
//

import WidgetKit
import SwiftUI

@main
struct OrderStatusBundle: WidgetBundle {
    var body: some Widget {
        OrderStatus()
        OrderStatusLiveActivity()
    }
}
