// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
import UIKit
import PDFKit

public struct DGSinglePDFViewer: UIViewRepresentable {
    
    let url: URL
    let backgroundColor: UIColor?
    let verticalEnlargement: CGFloat
    let horizontalEnlargement: CGFloat
    
    public init(
        url: URL,
        backgroundColor: UIColor? = nil,
        verticalEnlargement: CGFloat = 10,
        horizontalEnlargement: CGFloat = 10
    ) {
        self.url = url
        self.backgroundColor = backgroundColor
        self.verticalEnlargement = verticalEnlargement
        self.horizontalEnlargement = horizontalEnlargement
    }
    
    public func makeUIView(context: Context) -> SinglePDFView {
        SinglePDFView(
            url: url,
            verticalEnlargement: verticalEnlargement,
            horizontalEnlargement: horizontalEnlargement
        )
    }
    
    public func updateUIView(_ uiView: SinglePDFView, context: Context) {
        uiView.pdfView.subviews.first?.backgroundColor = backgroundColor
    }
}

public class SinglePDFView: UIView {
    let pdfURL: URL
    let pdfView = PDFView()
    let verticalEnlargement: CGFloat
    let horizontalEnlargement: CGFloat
    
    init(
        url: URL,
        verticalEnlargement: CGFloat,
        horizontalEnlargement: CGFloat
    ) {
        self.pdfURL = url
        self.verticalEnlargement = verticalEnlargement
        self.horizontalEnlargement = horizontalEnlargement
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        guard frame.size.width > 0 else { return }
        guard frame.size.height > 0 else { return }
        
        subviews.filter { $0 == pdfView }.forEach { $0.removeFromSuperview() }
        
        pdfView.document = PDFDocument(url: pdfURL)
        pdfView.autoScales = true
        
        addSubview(pdfView)
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        pdfView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        pdfView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        pdfView.widthAnchor.constraint(equalToConstant: frame.width + horizontalEnlargement).isActive = true
        pdfView.heightAnchor.constraint(equalToConstant: frame.height + verticalEnlargement).isActive = true
    }
}

// PDF 파일을 페이지별로 나누어 저장하고, 각 페이지별 파일의 URL을 반환하는 함수
public func dividePDFPerPage(pdfFileURL: URL) -> [URL] {
    // PDF 파일을 로드합니다.
    guard let originalPDF = PDFDocument(url: pdfFileURL) else {
        print("PDF 파일을 로드하지 못했습니다.")
        return []
    }
    
    // 결과 URL을 담을 배열을 초기화합니다.
    var pageURLs: [URL] = []
    
    // 원본 PDF의 페이지 수를 확인합니다.
    let totalPageCount = originalPDF.pageCount
    
    // 페이지를 개별적으로 추출하여 저장합니다.
    for pageIndex in 0..<totalPageCount {
        // 새 PDFDocument 객체를 생성하여 해당 페이지를 추가합니다.
        let newPDFDocument = PDFDocument()
        if let page = originalPDF.page(at: pageIndex) {
            newPDFDocument.insert(page, at: 0)
        }
        
        // 각 페이지별로 저장할 파일 URL을 생성합니다.
        let outputFileName = "\(pdfFileURL.deletingPathExtension().lastPathComponent)_Page_\(pageIndex + 1).pdf"
        let outputURL = pdfFileURL.deletingLastPathComponent().appendingPathComponent(outputFileName)
        
        // 새 PDF 파일을 페이지별로 저장합니다.
        if newPDFDocument.write(to: outputURL) {
            // 성공적으로 저장된 경우, 해당 URL을 배열에 추가합니다.
            pageURLs.append(outputURL)
        } else {
            print("페이지 \(pageIndex + 1)을 저장하는 데 실패했습니다.")
        }
    }
    
    // 각 페이지의 파일 URL 배열을 반환합니다.
    return pageURLs
}