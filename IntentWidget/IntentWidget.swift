//
//  IntentWidget.swift
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
        let currentDate = Date()
        let book = book(for: configuration)
        let nextRefreshDate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate)!
        let entry = SimpleEntry(date: currentDate, book: book)
        return Timeline(entries: [entry], policy: .after(nextRefreshDate))
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

struct IntentWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text(entry.book.name)
            Text(entry.book.author)
            HStack {
                Text("Last refresh:")
                Text(entry.date, style: .time)
            }
        }
    }
}

struct IntentWidget: Widget {
    let kind: String = "IntentWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            IntentWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}

#Preview(as: .systemSmall) {
    IntentWidget()
} timeline: {
    SimpleEntry(date: .now, book: .tianDao)
    SimpleEntry(date: .now, book: .pingFanDeShiJie)
}
