# SwiftUI Flow Grids

A lightweight SwiftUI library providing `VFlowGrid` and `HFlowGrid` for laying out views in a flowing stack, either vertically or horizontally.

## Usage

Import the library and SwiftUI:

```swift
import FlowGrids
import SwiftUI
```

Creates a flowed grid with customizable row and item alignment:

```swift
VFlowGrid(rowAlignment: .leading, itemAlignment: .bottom, rowSpacing: 5, itemSpacing: 5) {
    ForEach(generateSportTags(), content: Tag.init(item:))
}
```

<img width="782" alt="Screenshot 2025-03-06 at 22 36 22" src="https://github.com/user-attachments/assets/14d6b3b5-074d-4f11-bbec-49019860d9c3" />

## Features

- Vertical (`VFlowGrid`) and horizontal (`HFlowGrid`) flow layout;
- Customizable alignment, spacing, and item arrangement;
- Works seamlessly with `SwiftUI` views.

<img width="291" alt="Screenshot 2025-03-06 at 22 03 53" src="https://github.com/user-attachments/assets/7e488717-9585-4cfc-9d8c-dfb2852eccb8" />

<img width="342" alt="Screenshot 2025-03-06 at 22 08 22" src="https://github.com/user-attachments/assets/53c0b5b2-25ff-4d44-8fc8-30a8da7180d3" />

## Requirements

- iOS 16.0+
- macCatalyst 16.0+
- macOS 13.0+
- tvOS 16.0+
- visionOS 1.0+
- watchOS 9.0+

## Installation

To use SwiftUI Flow Grids, add the package to your Xcode project:

1. Open Xcode and go to **File > Add Packages**.
2. Enter the repository URL.
3. Choose **Add Package**.

To install this library using Swift Package Manager, add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/zijievv/swiftui-flow-grids.git", from: "0.1.0"),
]
```

## License

This project is available under the MIT License.

## Contributions

Contributions are welcome! Feel free to open issues or submit pull requests.
