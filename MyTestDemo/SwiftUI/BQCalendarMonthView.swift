//
//  BQCalendarMonthView.swift
//  MyTestDemo
//
//  Created by baiqiang on 2023/6/2.
//

import SwiftUI
import BQSwiftKit


struct BQCalednarHeaderView: View {
    let gridTimes: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 1), count: 7)
    var body: some View {
        LazyVGrid(columns: gridTimes, spacing: 1) {
            ForEach(BQWeekDay.allCases, id: \.title) { weekday in
                Text(weekday.title)
                    .font(.headline)
                    .frame(minHeight: 30)
                    .padding(.bottom, 4)
            }
        }
    }
}

struct BQCalendarMonthView<Content: View>: View {
    let gridTimes: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 1), count: 7)
    let days: [CalendarDate]
    let content: (CalendarDate) -> Content

    init(days: [CalendarDate], @ViewBuilder content: @escaping (CalendarDate) -> Content) {
        self.days = days
        self.content = content
    }

    var body: some View {
        LazyVGrid(columns: gridTimes, spacing: 1) {
            ForEach(Array(days.enumerated()), id: \.0) { _, date in
                content(date)
            }
        }
    }
}

struct BQCalendarYearView<Content: View>: View {
    let gridTimes: [GridItem] = Array(repeating: GridItem(.fixed(300)), count: 12)
    let monthDays: [[CalendarDate]]
    let content: (CalendarDate) -> Content

    init(monthDays: [[CalendarDate]], @ViewBuilder content: @escaping (CalendarDate) -> Content) {
        self.monthDays = monthDays
        self.content = content
    }
    var body: some View {
        TabView {
            ForEach(Array(monthDays.enumerated()), id: \.0) { _, days in
                VStack {
                    BQCalendarMonthView(days: days, content: content)
                        .frame(width: UIScreen.main.bounds.width)
                    Spacer()
                }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
}

extension BQWeekDay {
    var title: String {
        switch self {
        case .sunday: return "日"
        case .monday: return "一"
        case .tuesday: return "二"
        case .wednesday: return "三"
        case .thursday: return "四"
        case .friday: return "五"
        case .saturday: return "六"
        }
    }
}

struct testView: View {
    @State var selectDay = Date().startOfDay
    let monthDays: [[CalendarDate]] = CalendarUtil().currentYearDateList()
    var body: some View {
        VStack(spacing: 0) {
            BQCalednarHeaderView()
            BQCalendarYearView (monthDays: monthDays) { date in
                VStack(spacing: 6) {
                    HStack {
                        Spacer()
                        Text("\(date.day)")
                            .lineLimit(1)
                            .font(.caption2)
                            .foregroundColor(date.isCurrentMonth ? (date.isToday ? Color.red : Color.black) : Color.orange)
                        Spacer()
                    }
                    RoundedRectangle(cornerRadius: .infinity)
                        .frame(width: 4, height: 4)
                        .foregroundColor(Color.gray)
                }
                .frame(minHeight: 50)
                .background(
                    RoundedRectangle(cornerRadius: .infinity)
                        .frame(width: 40, height: 40)
                        .foregroundColor(date.date == selectDay ? Color.cyan : Color.clear)
                )
                .onTapGesture {
                    selectDay = date.date
                }
            }
            Spacer()
        }
    }
}

struct BQCalendarMonthView_Previews: PreviewProvider {

    static var previews: some View {
        testView()
    }
}
