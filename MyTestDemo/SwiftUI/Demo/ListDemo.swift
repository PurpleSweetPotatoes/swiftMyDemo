//
//  ListDemo.swift
//  MyTestDemo
//  
//  Created by Bai, Payne on 2023/4/10.
//  Copyright © 2023 Garmin All rights reserved
//  

import SwiftUI

typealias listViewModelCombine = StateViewModel<ListState, ListAction>

struct RowData: Identifiable {
    let rowId: Int
    let name: String
    var isSelected: Bool = false

    var id: String {
        String("\(rowId)")
    }
}

struct ListState {
    var datas: [RowData]
}

enum ListAction {
    case creation
    case selected(Int)
    case updateData
}

final class listViewModel: listViewModelCombine {
    override func trigger(_ action: ListAction) {
        switch action {
        case .creation:
            state.datas = [RowData(rowId: 0, name: "a"),
                     RowData(rowId: 1, name: "b")
                     ]
        case .selected(let index):
            state.datas[index].isSelected.toggle()
        case .updateData:
            state.datas = [RowData(rowId: 0, name: "a"),
                     RowData(rowId: 1, name: "b")
                     ]
        }
    }
}

struct ListDemo: View {
    @StateObject var viewModel: listViewModelCombine
    var body: some View {
        VStack {
            List {
                ForEach(Array(zip(0..., viewModel.datas)), id: \.1.rowId) { index, data in
                    VStack {
                        Text("\(index)")
                        RowView(data: data)
                            .onTapGesture {
                                viewModel.trigger(.selected(index))
                            }
                    }
                }
                Text("abc")
            }
            .listStyle(.plain)

            Button {
                viewModel.trigger(.updateData)
            } label: {
                Text("update")
            }
        }
        .background(Color.gray)
        .onAppear {
            viewModel.trigger(.creation)
        }
    }

    struct RowView: View {
        var data: RowData
        var body: some View {
            HStack {
                Text(data.name)
                Spacer()
                if data.isSelected {
                    Text("selected")
                }
            }
        }
    }
}

struct ListDemo_Previews: PreviewProvider {
    static var previews: some View {
        ListDemo(viewModel: listViewModel(initialState: ListState(datas: [])))
    }
}
