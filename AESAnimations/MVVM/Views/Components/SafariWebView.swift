//
//  SafariWebView.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 30.11.24.
//

import SwiftUI
import SafariServices

/// Code from the project work:
/// `Development of a Modular iOS Learning App with Swift and SwiftUI`,
/// authored by Leon Chamoun.
#if os(iOS)
// Source: https://sarunw.com/posts/sfsafariviewcontroller-in-swiftui
/// A view that wraps the `SFSafariViewController` to display a web page within a SwiftUI view.
struct SafariWebView: UIViewControllerRepresentable {
    let url: URL // The URL to be loaded in the Safari view controller.
    
    /// Creates and returns an `SFSafariViewController` that loads the provided URL.
    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    /// Updates the existing `SFSafariViewController` with new data if needed. Currently empty because the URL doesn't change.
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        // No update code needed for static URL usage
    }
}

/// A wrapper view that attempts to create a `SafariWebView` if the URL is valid, otherwise displays an error message.
struct SafariWebViewWrapper: View {
    let urlString: String // The raw string URL to be transformed into a `URL`.
    
    var body: some View {
        if let url = URL(string: urlString) {
            SafariWebView(url: url) // Embeds the Safari web view if the URL is valid.
        } else {
            Text("The URL is not valid") // Displays an error message if the URL is not valid.
        }
    }
}

// MARK: - Preview
#Preview {
    SafariWebView(url: URL(string: "https://docs.swift.org/swift-book/documentation/the-swift-programming-language/")!)
}
#endif
