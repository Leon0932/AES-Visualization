### README.md

# AES-Visualization App

This project is an AES-Visualization application developed with Swift and SwiftUI.

## Prerequisites

- Xcode (version 16)
- Git
- GitLab account (optional but recommended)
- Apple Developer account or an Apple ID associated with an iCloud account (required for running on physical devices)

## Installation

### 1. Clone the repository

Open your terminal and execute the following command:

```bash
git clone https://gitlab.com/Leon0932/AES-Visualization.git
```

### 2. Navigate to the project directory

```bash
cd AES-Visualization
```

### 3. Open the Xcode project

```bash
open AES-Visualization.xcodeproj
```

### 4. Build and run the project

Select your target device and click the Run button (`⌘R`) to build and run the project.

## Bundle Identifier

The app requires a unique Bundle Identifier (e.g., `com.yourname.AESAnimations`) to run on a device. Xcode generates a default identifier, but you can customize it as follows:

1. Select the **AES-Visualization** project in the Project Navigator.
2. Go to **Signing & Capabilities** and modify the **Bundle Identifier** to suit your preference.
3. Under **Team**, select your Apple Developer account or an Apple ID associated with an iCloud account. This is necessary for code signing and allows the app to be installed on physical devices.

## Running Unit Tests

To execute the Unit Tests, follow these steps:

1. Open the project in Xcode.
2. Press `Command + U` to run all Unit Tests.
3. Review the results in the Test navigator.
