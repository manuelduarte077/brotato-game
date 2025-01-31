//
//  NFWidget.swift
//  NFWidget
//
//  Created by Manuel Duarte on 25/1/25.
//

import WidgetKit
import SwiftUI

struct Payment {
    let title: String
    let amount: Double
    let dueDate: String
}

struct Provider: TimelineProvider {
    let appGroupId = "group.payReminderApp"
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), payments: [
            Payment(title: "Netflix", amount: 15.99, dueDate: "28/02"),
            Payment(title: "Spotify", amount: 9.99, dueDate: "01/03")
        ])
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let userDefaults = UserDefaults(suiteName: appGroupId)
        
        print("Reading widget data from UserDefaults")
        
        let titles = userDefaults?.stringArray(forKey: "titles") ?? []
        let amounts = userDefaults?.array(forKey: "amounts") as? [Double] ?? []
        let dueDates = userDefaults?.stringArray(forKey: "dueDates") ?? []
        
        print("Widget data read: titles=\(titles), amounts=\(amounts), dueDates=\(dueDates)")
        
        var payments: [Payment] = []
        for i in 0..<min(titles.count, min(amounts.count, dueDates.count)) {
            payments.append(Payment(
                title: titles[i],
                amount: amounts[i],
                dueDate: dueDates[i]
            ))
        }
        
        print("Created payments: \(payments)")
        
        let entry = SimpleEntry(date: Date(), payments: payments)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        getSnapshot(in: context) { entry in
            let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: Date()) ?? Date()
            let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
            completion(timeline)
        }
    }

}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let payments: [Payment]
}

struct NFWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Próximos Pagos")
                .font(.headline)
                .padding(.bottom, 4)
            
            ForEach(entry.payments.prefix(3), id: \.title) { payment in
                HStack {
                    Text(payment.title)
                        .font(.subheadline)
                    Spacer()
                    Text("$\(String(format: "%.2f", payment.amount))")
                        .font(.subheadline)
                    Text(payment.dueDate)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            if entry.payments.isEmpty {
                Text("No hay pagos próximos")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
    }
}

struct NFWidget: Widget {
    let kind: String = "NFWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                NFWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                NFWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemSmall) {
    NFWidget()
} timeline: {
    SimpleEntry(date: .now, payments: [
        Payment(title: "Netflix", amount: 15.99, dueDate: "28/02"),
        Payment(title: "Spotify", amount: 9.99, dueDate: "01/03")
    ])
    SimpleEntry(date: .now, payments: [])
}
