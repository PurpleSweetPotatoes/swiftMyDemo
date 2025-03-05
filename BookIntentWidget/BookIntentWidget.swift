//
//  BookIntentWidgetWidget.swift
//  MyTestDemo
//
//  Created by Bai, Payne on 2024/8/5.
//  Copyright © 2024 Garmin All rights reserved
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), book: .tianDao)
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), book: .tianDao)
    }

    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []
        let currentDate = Date()
        for (index, book) in BookManager.availableBooks.enumerated() {
            let entry = SimpleEntry(date: currentDate + TimeInterval((index * 10)), book: book)
            entries.append(entry)
        }
        return Timeline(entries: entries, policy: .atEnd)
//        let currentDate = Date()
//        let book = book(for: configuration)
//        let nextRefreshDate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate)!
//        let entry = SimpleEntry(date: currentDate, book: book)
//        return Timeline(entries: [entry], policy: .after(nextRefreshDate))
    }

    func book(for configuration: ConfigurationAppIntent) -> Book {
        if let name = configuration.bookName {
            BookManager.setCurrentBook(with: name)
            return BookManager.book(from: name) ?? .tianDao
        }
        return .tianDao
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let book: Book
}

struct BookIntentWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading) {
            Group {
                Text(entry.book.name)
                Text("作者: \(entry.book.author)")
            }
            .transition(.push(from: .bottom))

            Text("Rate: \(entry.book.rate)")
                .contentTransition(.numericText())

            HStack {
                Text("Last Read:")
                Text(entry.date, style: .time)
            }
            .contentTransition(.numericText())
        }
    }
}

struct BookIntentWidget: Widget {
    let kind: String = "BookIntentWidgetWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            BookIntentWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}

#Preview(as: .systemSmall) {
    BookIntentWidget()
} timeline: {
    SimpleEntry(date: .now, book: .tianDao)
    SimpleEntry(date: .now + 3720, book: .pingFanDeShiJie)
}
