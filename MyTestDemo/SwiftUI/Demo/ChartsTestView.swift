//
//  ChartsTestView.swift
//  MyTestDemo
//
//  Created by baiqiang on 2023/6/14.
//

import Charts
import SwiftUI

let cheeseburgerCost: [Food] = [
    .init(name: "Cheeseburger", price: 0.15, year: 1960),
    .init(name: "Cheeseburger", price: 0.20, year: 1970),
    .init(name: "Cheeseburger", price: 1.10, year: 2020)
]


struct Food: Identifiable {
    let name: String
    let price: Double
    let date: Date
    let id = UUID()


    init(name: String, price: Double, year: Int) {
        self.name = name
        self.price = price
        let calendar = Calendar.autoupdatingCurrent
        self.date = calendar.date(from: DateComponents(year: year))!
    }
}
struct ChartsTestView: View {
    var body: some View {
        if #available(iOS 16.0, *) {
            ChartView()
        } else {
            Text("asd")
        }

    }
}

@available(iOS 16.0, *)
struct ChartView: View {
    var body: some View {
        VStack {
            Spacer()
            Chart(cheeseburgerCost) { cost in
                AreaMark(
                    x: .value("Date", cost.date),
                    y: .value("Price", cost.price)
                )
            }
            Spacer()
        }
    }
}

struct ChartsTestView_Previews: PreviewProvider {
    static var previews: some View {
        ChartsTestView()
    }
}
