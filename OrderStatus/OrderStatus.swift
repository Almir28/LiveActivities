//
//  OrderStatus.swift
//  OrderStatus
//
//  Created by Almir Khialov on 04.09.2024.
//

import WidgetKit
import SwiftUI
import Intents

struct OrderStatus: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: OrderAttributes.self) { context in
            // Виджет для экрана блокировки
            ZStack {
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .fill(Color("StarbucksGreen").gradient)
                
                VStack(alignment: .leading) {
                    HStack {
                        Image("Logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                        
                        Text("In store pickup")
                            .foregroundColor(.white.opacity(0.6))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack(spacing: 10) {
                            ForEach(["Burger", "Shake"], id: \.self) { image in
                                Image(image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 35, height: 35)
                                    .background {
                                        Circle()
                                            .fill(context.state.status.rawValue == image ? Color.white : Color("StarbucksGreen"))
                                            .padding(-2)
                                    }
                                    .background {
                                        Circle()
                                            .stroke(Color.white, lineWidth: 1.5)
                                            .padding(-2)
                                    }
                            }
                        }
                    }
                    
                    HStack(alignment: .bottom, spacing: 0) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(message(status: context.state.status))
                                .font(.title3)
                                .foregroundStyle(.white)
                            
                            Text(subMessage(status: context.state.status))
                                .font(.caption2)
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .offset(y: 13)
                        }
                        
                        HStack(alignment: .bottom, spacing: 0) {
                            ForEach(Status.allCases, id: \.self) { type in
                                VStack {
                                    Image(systemName: type.rawValue)
                                        .font(context.state.status == type ? .title2 : .body)
                                        .foregroundColor(context.state.status == type ? .black : .white) // Изменить цвет текста
                                        .frame(width: context.state.status == type ? 45 : 32, height: context.state.status == type ? 45 : 32)
                                        .background(
                                            Circle()
                                                .fill(context.state.status == type ? Color.white : Color.green.opacity(0.5))
                                        )
                                        .frame(maxWidth: .infinity)
                                    
                                    // Добавляем черточку под активным статусом
                                    BottomArrow(status: context.state.status, type: type)
                                }
                            }
                            .overlay(alignment: .bottom) {
                                // Основная линия для всех статусов
                                RoundedRectangle(cornerRadius: 1.5)
                                    .fill(Color.white.opacity(0.6))
                                    .frame(height: 2) // Толщина линии
                                    .offset(y: 12)
                                    .padding(.horizontal, 27.5)
                            }
                        }
                    }
                    .padding(.leading, 15)
                    .padding(.trailing, -10)
                    .frame(maxWidth: .infinity)
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
                .padding(15)
            }
        } dynamicIsland: { context in
            // Виджет для Dynamic Island
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Image(systemName: context.state.status.rawValue)
                        .foregroundColor(.white)
                }
                
                DynamicIslandExpandedRegion(.center) {
                    Text("Order #\(context.attributes.orderNumber)")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                
                DynamicIslandExpandedRegion(.trailing) {
                    Text(context.state.status.rawValue.capitalized)
                        .font(.caption)
                        .foregroundColor(.white)
                }
                
                DynamicIslandExpandedRegion(.bottom) {
                    Text(context.attributes.orderItems)
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
            } compactLeading: {
                Image(systemName: context.state.status.rawValue)
                    .foregroundColor(.white)
            } compactTrailing: {
                Text("...")
                    .foregroundColor(.white)
            } minimal: {
                Text("🍔")
                    .foregroundColor(.white)
            }
        }
    }
    
    // Вспомогательная функция для стрелки
    @ViewBuilder
    func BottomArrow(status: Status, type: Status) -> some View {
        if status == type { // Отображаем только для активного статуса
            RoundedRectangle(cornerRadius: 1.5)
                .fill(Color.white)
                .frame(width: 30, height: 3) // Настройка размеров и формы
                .offset(y: 10) // Смещение вниз для более точного позиционирования
                .overlay(alignment: .bottom) {
                    Circle()
                        .fill(.white)
                        .frame(width: 6, height: 6) // Точка под чертой
                        .offset(y: 15) // Смещение точки ниже черты
                }
        }
    }
    
    // Вспомогательные функции для сообщения статуса
    func message(status: Status) -> String {
        switch status {
        case .received:
            return "Order received"
        case .inProgress:
            return "Order in progress"
        case .ready:
            return "Order ready"
        }
    }
    
    func subMessage(status: Status) -> String {
        switch status {
        case .received:
            return "We just received your order."
        case .inProgress:
            return "We are handcrafting your order."
        case .ready:
            return "Your order is ready."
        }
    }
}

@main
struct OrderStatusBundle: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        OrderStatus()
    }
}
