//
//  TestView.swift
//  MyTestDemo
//  
//  Created by Bai, Payne on 2024/10/29.
//  Copyright © 2024 Garmin All rights reserved
//  

import SwiftUI



class ActivityData {
    let id: Int
    let name: String
    var mapImage: UIImage?

    init(id: Int) {
        self.id = id
        self.name = "activity \(id)"
    }
}

class Status: ObservableObject {
    @Published var count: Int = 0
}

struct StatusView: View {
    @StateObject var status: Status
    init(status: Status) {
        self._status = StateObject(wrappedValue: status)
    }
    var body: some View {
        VStack {
            Text("count: \(status.count)")
            Button {
                status.count += 1
            } label: {
                Text("Add")
            }
        }
    }
}

struct TestView: View {
    @ObservedObject var status = Status()
    var body: some View {
        VStack {
            Text("origin count: \(status.count)")
            StatusView(status: status)
        }
    }

//    @State var viewModelList: [ActivityData] = [ActivityData(id: 0), ActivityData(id: 1),ActivityData(id: 2), ActivityData(id: 3)]
//    var body: some View {
//        ScrollView {
//            LazyVStack(alignment: .leading, spacing: 16) {
//                Spacer().frame(height: 16)
//                ForEach(viewModelList, id: \.id) { item in
//                    ActivityCard(item: item)
//                }
//            }
//        }
//        .refreshable {
//            var list: [ActivityData] = []
//            for i in 0...3 {
//                list.append(ActivityData(id: i + 3))
//            }
//            viewModelList = list
//        }
//    }
}

struct ActivityCard: View {
    let item: ActivityData
    let uuid = UUID().uuidString
    init(item: ActivityData) {
        print("a!!! create ActivityCard \(uuid)")
        self.item = item
    }
    var body: some View {
        VStack {
            Text(uuid)
            Text(item.name)
            if item.mapImage != nil {

            }
            Color.cyan.frame(height: 350)
        }
        .onAppear {
            print("a!!! on appear \(uuid)")
        }
    }
}

#Preview {
    TestView()
}
