# GitHub Contributions Widget (macOS)

This project is a macOS widget that displays a user's GitHub contribution graph directly on the desktop using SwiftUI and WidgetKit.

## Features

* Displays the latest GitHub contributions for a specified user.
* Color-coded contribution heatmap (light green for low, dark green for high).
* Automatically refreshes data every hour.

---

## Prerequisites

* macOS 12.0 or later
* Xcode 14.0 or later
* Basic knowledge of SwiftUI and WidgetKit.

---

## Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/GitHubContributionsWidget.git
```

### 2. Open in Xcode

* Open the `.xcodeproj` or `.xcworkspace` file.

### 3. Modify User

* Change the GitHub username in the `fetchGitHubContributions` function:

```swift
let url = URL(string: "https://ghchart.rshah.org/your_github_username")
```

### 4. Set Up Info.plist for Network Access

* Add the following to both the main app target and widget target Info.plist:

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSExceptionDomains</key>
    <dict>
        <key>ghchart.rshah.org</key>
        <dict>
            <key>NSIncludesSubdomains</key>
            <true/>
            <key>NSExceptionAllowsInsecureHTTPLoads</key>
            <false/>
            <key>NSExceptionRequiresForwardSecrecy</key>
            <false/>
            <key>NSAllowsArbitraryLoads</key>
            <false/>
        </dict>
    </dict>
</dict>
```

### 5. Enable Network Entitlement (for Widget)

* Go to your Widget target’s Signing & Capabilities.
* Add "App Sandbox".
* Ensure "Outgoing Network Connections (Client)" is enabled.

### 6. Run on Physical Device

* Connect your macOS device.
* Select the device as the target in Xcode.
* Build and run.

---

## Troubleshooting

* If you see "A server with the specified hostname could not be found", ensure the URL is correct and the domain has an ATS exception.
* Test the URL in Safari to confirm it loads correctly.
* Test on a physical device instead of the simulator if network calls fail.

---

