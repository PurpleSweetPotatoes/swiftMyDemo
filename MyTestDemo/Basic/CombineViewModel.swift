//
//  StateViewModel.swift
//  MyTestDemo
//  
//  Created by Bai, Payne on 2023/3/17.
//  Copyright © 2023 Garmin All rights reserved
//  

import Combine
import Foundation
// 声明了@dynamicMemberLookup后，即使属性没有定义，但是程序会在运行时动态的查找属性的值，调用subscript(dynamicMember member: String)方法来获取值
@dynamicMemberLookup
open class StateViewModel<State, Action>: ObservableObject {
    @Published open var state: State

    public init(initialState: State) {
        state = initialState
    }

    open func trigger(_ action: Action) {
        assert(false, "This method must be implemented in subclasses")
    }

    public subscript<Value>(dynamicMember keyPath: KeyPath<State, Value>) -> Value {
        state[keyPath: keyPath]
    }
}

/// Base class for ViewState view models used for UIKit features
//open class BindableStateViewModel<event, action> {
//    /// The view state or display event observable property. Define a feature specific enum
//    public let event: Dynamic<event>
//
//    /// The view model must be initialized with an initial state/event
//    public init(initialEvent: event) {
//        event = Dynamic(initialEvent, notifyOnMain: true)
//    }
//
//    /// Used by the view to trigger a view action
//    /// - Parameter action: the view action
//    open func trigger(_ action: action) {
//        assert(false, "This method must be implemented in subclasses")
//    }
//}
