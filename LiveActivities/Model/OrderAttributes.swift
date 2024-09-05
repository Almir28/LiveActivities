//
//  OrderAttributes.swift
//  LiveActivities
//
//  Created by Almir Khialov on 04.09.2024.
//
import ActivityKit

struct OrderAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        var status: Status = .received
    }
    
    var orderNumber: Int
    var orderItems: String
}

enum Status: String, CaseIterable, Codable, Equatable {
    case received = "shippingbox.fill"
    case inProgress = "person.fill"
    case ready = "takeoutbag.and.cup.and.straw.fill"
}
