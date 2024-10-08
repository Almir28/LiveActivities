//
//  OrderStatusLiveActivity.swift
//  OrderStatus
//
//  Created by Almir Khialov on 04.09.2024.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct OrderStatusAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct OrderStatusLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: OrderStatusAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension OrderStatusAttributes {
    fileprivate static var preview: OrderStatusAttributes {
        OrderStatusAttributes(name: "World")
    }
}

extension OrderStatusAttributes.ContentState {
    fileprivate static var smiley: OrderStatusAttributes.ContentState {
        OrderStatusAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: OrderStatusAttributes.ContentState {
         OrderStatusAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: OrderStatusAttributes.preview) {
   OrderStatusLiveActivity()
} contentStates: {
    OrderStatusAttributes.ContentState.smiley
    OrderStatusAttributes.ContentState.starEyes
}
