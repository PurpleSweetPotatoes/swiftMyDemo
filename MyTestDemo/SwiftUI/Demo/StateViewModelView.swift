//
//  StateViewModelView.swift
//  MyTestDemo
//  
//  Created by Bai, Payne on 2023/3/17.
//  Copyright © 2023 Garmin All rights reserved
//  

import SwiftUI

typealias TestViewModelCombine = StateViewModel<TestViewModel.State, TestViewModel.Action>
class TestViewModel: TestViewModelCombine {
    struct State {
        enum Status: String {
            case creation = "creation"
            case refresh = "refresh"
            case completed = "completed"
            case error = "error"
        }
        var status: Status = .creation

    }

    enum Action {
        case startRefresh
        case refreshCompleted
        case error
    }

    override func trigger(_ action: Action) {
        switch action {
        case .startRefresh:
            state.status = .refresh
        case .refreshCompleted:
            state.status = .completed
        default:
            state.status = .error
        }
    }
}

struct StateViewModelView: View {
    @ObservedObject var viewModel: TestViewModelCombine
    var body: some View {
        VStack {
            Text(viewModel.status.rawValue)
            HStack {
                Button {
                    viewModel.trigger(.startRefresh)
                } label: {
                    Text("start")
                }
                Button {
                    viewModel.trigger(.refreshCompleted)
                } label: {
                    Text("completed")
                }
                Button {
                    viewModel.trigger(.error)
                } label: {
                    Text("error")
                }
            }
        }
    }
}

struct StateViewModelView_Previews: PreviewProvider {
    static var previews: some View {
        StateViewModelView(viewModel: TestViewModel(initialState: TestViewModel.State()))
    }
}
