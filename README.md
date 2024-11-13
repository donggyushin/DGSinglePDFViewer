# DGSinglePDFViewer

Have you ever wanted to show PDF files without any space? You can easily implement them on a SwiftUI basis with the DGSinglePDFViewer.

<div>
   <img src="https://raw.githubusercontent.com/donggyushin/DGSinglePDFViewer/refs/heads/develop/screenshots/1.png" width=250 />
   <img src="https://raw.githubusercontent.com/donggyushin/DGSinglePDFViewer/refs/heads/develop/screenshots/2.png" width=250 />
</div>

## Installation

### Swift Package Manager

The [Swift Package Manager](https://www.swift.org/documentation/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler.

Once you have your Swift package set up, adding `DGSinglePDFViewer` as a dependency is as easy as adding it to the dependencies value of your Package.swift or the Package list in Xcode.

```
dependencies: [
   .package(url: "https://github.com/donggyushin/DGSinglePDFViewer.git", .upToNextMajor(from: "1.0.0"))
]
```

Normally you'll want to depend on the DGSinglePDFViewer target:

```
.product(name: "DGSinglePDFViewer", package: "DGSinglePDFViewer")
```

```swift
    @State var urls: [URL] = []
    
    var body: some View {
        TabView {
            ForEach(urls, id: \.self) { url in
                DGSinglePDFViewer(url: url)
                    .frame(height: 450)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.horizontal, 30)
            }
        }
        .background {
            Color(uiColor: .secondarySystemBackground)
                .ignoresSafeArea()
        }
        .frame(height: 500)
        .tabViewStyle(.page(indexDisplayMode: .never))
        .onAppear {
            if let url = Bundle.module.url(forResource: "sample_pdf", withExtension: "pdf") {
                self.urls = dividePDFPerPage(pdfFileURL: url)
            }
        }
    }
```
