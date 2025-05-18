import WidgetKit
import SwiftUI

#if os(iOS)
import UIKit
typealias PlatformImage = UIImage
#elseif os(macOS)
import AppKit
typealias PlatformImage = NSImage
#endif

// Timeline Entry
struct SimpleEntry: TimelineEntry {
    let date: Date
    let imageData: Data?
}

// Timeline Provider
struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), imageData: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        fetchImage { data in
            let entry = SimpleEntry(date: Date(), imageData: data)
            completion(entry)
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        fetchImage { data in
            let entry = SimpleEntry(date: Date(), imageData: data)
            // Refresh every hour
            let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(3600)))
            completion(timeline)
        }
    }

    private func fetchImage(completion: @escaping (Data?) -> ()) {
        guard let url = URL(string: "https://ghchart.rshah.org/rdxrud") else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Failed to fetch image: \(error.localizedDescription)")
                completion(nil)
                return
            }
            completion(data)
        }.resume()
    }
}

// Widget View
struct GitHubContributionWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        if let imageData = entry.imageData,
           let image = loadImage(from: imageData) {
            Image(platformImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()
        } else {
            VStack {
                ProgressView()
                Text("Loading...")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding()
        }
    }

    // Helper to convert Data to PlatformImage
    func loadImage(from data: Data) -> PlatformImage? {
        #if os(iOS)
        return PlatformImage(data: data)
        #elseif os(macOS)
        return PlatformImage(data: data)
        #else
        return nil
        #endif
    }
}

// Extension to use PlatformImage with SwiftUI's Image
extension Image {
    init(platformImage: PlatformImage) {
        #if os(iOS)
        self.init(uiImage: platformImage)
        #elseif os(macOS)
        self.init(nsImage: platformImage)
        #else
        self.init(systemName: "photo") // fallback placeholder
        #endif
    }
}

// Main Widget Definition

struct GitHubContributionWidget: Widget {
    let kind: String = "GitHubContributionWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            GitHubContributionWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("GitHub Contributions")
        .description("Shows your GitHub contribution calendar heatmap.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
