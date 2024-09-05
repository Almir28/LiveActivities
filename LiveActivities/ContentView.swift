//
//  ContentView.swift
//  LiveActivities
//
//  Created by Almir Khialov on 04.09.2024.
//

import SwiftUI
import WidgetKit
import ActivityKit

struct ContentView: View {
    
    @State var currentID: String = ""
    @State var currentSelection: Status = .received
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker(selection: $currentSelection) {
                    Text("Received")
                        .tag(Status.received)
                    Text("In Progress")
                        .tag(Status.inProgress)
                    Text("Ready")
                        .tag(Status.ready)
                } label: {
                    // Оставляем пустым
                }
                .labelsHidden()
                .pickerStyle(.segmented)
                
                // Кнопка для добавления активности
                Button("Start Activity") {
                    addLiveActivity()
                }
                .padding(.top)
                
                // Кнопка для удаления активности
                Button("Remove Activity") {
                    removeActivity()
                }
                .padding(.top)
                
                // Обновление активности при изменении выбора
                .onChange(of: currentSelection) { newValue in
                    if let activity = Activity<OrderAttributes>.activities.first(where: { $0.id == currentID }) {
                        print("Activity Found")
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            var updatedState = activity.contentState
                            updatedState.status = currentSelection
                            Task {
                                await activity.update(using: updatedState)
                            }
                        }
                    }
                }
                
                .navigationTitle("Live Activities")
                .padding(15)
            }
        }
    }
    
    // Функция для добавления активности
    func addLiveActivity() {
        let orderAttributes = OrderAttributes(orderNumber: 26383, orderItems: "Burger & Milk Shake")
        let initialContentState = OrderAttributes.ContentState(status: .received)
        
        do {
            let activity = try Activity<OrderAttributes>.request(attributes: orderAttributes, contentState: initialContentState, pushType: nil)
            currentID = activity.id
            print("Activity Added Successfully. id: \(activity.id)")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // Функция для удаления активности
    func removeActivity() {
        if let activity = Activity<OrderAttributes>.activities.first(where: { $0.id == currentID }) {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                Task {
                    await activity.end(using: activity.contentState, dismissalPolicy: .immediate)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
