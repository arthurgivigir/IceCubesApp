//
//  IceCubesWidget.swift
//  IceCubesWidget
//
//  Created by Arthur Givigir on 30/01/23.
//

import WidgetKit
import SwiftUI
import Intents
import Explore
import DesignSystem

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct IceCubesWidgetEntryView : View {
    @EnvironmentObject private var theme: Theme
    
    var entry: Provider.Entry

    var body: some View {
        Text("Ola mundo")
            .foregroundColor(theme.labelColor)
            .background(theme.primaryBackgroundColor)
    }
}

struct IceCubesWidget: Widget {
    @StateObject private var theme = Theme.shared
    
    let kind: String = "IceCubesWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: ConfigurationIntent.self,
            provider: Provider()
        ) { entry in
            print("🚧 \(theme)")
            return IceCubesWidgetEntryView(entry: entry)
                .applyTheme(theme)
                .environmentObject(theme)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct IceCubesWidget_Previews: PreviewProvider {
    static var previews: some View {
        IceCubesWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
