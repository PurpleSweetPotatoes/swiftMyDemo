////
////  EnvironmentDemo.swift
////  MyTestDemo
////  
////  Created by Bai, Payne on 2024/1/6.
////  Copyright © 2024 Garmin All rights reserved
////  
//
//import SwiftUI
//import Observation
//
//@Observable class Account {
//  var userName: String?
//}
//
//@available(iOS 17.0, *)
//struct EnvironmentDemo : View {
//  @Environment(Account.self) var account
//
//  var body: some View {
//    if let name = account.userName {
//      HStack { Text(name); Button("Log out") { account.userName = "log out" } }
//    } else {
//      Button("Login") { account.userName = "log In" }
//    }
//  }
//}
//
//#Preview {
//    EnvironmentDemo(account: Account())
//}
