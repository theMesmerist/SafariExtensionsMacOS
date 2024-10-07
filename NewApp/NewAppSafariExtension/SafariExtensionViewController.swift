//
//  SafariExtensionViewController.swift
//  NewAppSafariExtension
//
//  Created by Emre Karaoğlu on 6.10.2024.
//
import SwiftUI
import SafariServices
import SwiftSoup
import PDFKit

class SafariExtensionViewController: SFSafariExtensionViewController {
    
    var window : SFSafariWindow!
    var selectedText: String = ""
    var content: String = ""
    var hostingView = SafariPopOverView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = NSHostingView(rootView: hostingView)
    }
    
    func searchAction(sender: SFSafariWindow) {
        self.window = sender
        hostingView.selectedText =  selectedText
    }
    
    func toolbarItemClicked(sender: SFSafariWindow) {
        self.window = sender
        sender.getActiveTab { tab in
            tab?.getActivePage(completionHandler: { page in
                page?.getPropertiesWithCompletionHandler({ props in
                    if let url = props?.url {

                        let task = URLSession.shared.dataTask(with: url) { data, response, error in
                            if let error = error {
                                print("Error: \(error)")
                                return
                            }

                            guard let httpResponse = response as? HTTPURLResponse,
                                  (200...299).contains(httpResponse.statusCode) else {
                                print("Error: Invalid response")
                                return
                            }

                            guard let data = data else {
                                print("Error: No data received")
                                return
                            }
                           
                            let urlPath = url.path
                            
                            if urlPath.hasSuffix(".pdf") {
                                self.getPdfContent(data: data)
                            } else {
                                self.getHtmlContent(data: data)
                            }
                        }

                        task.resume()
                    }
                })
            })
        }
    }
    
    private func getPdfContent(data: Data) {
        if let pdfDocument = PDFDocument(data: data) {
            var pdfContent = ""
            for i in 0..<pdfDocument.pageCount {
                if let page = pdfDocument.page(at: i) {
                    pdfContent += page.string ?? ""
                }
            }
            print("PDF Content:\n\(pdfContent)")
            self.content = pdfContent
        } else {
            print("Error: Failed to create PDF document")
        }
    }
    
    private func getHtmlContent(data: Data) {
        let htmlString = String(data: data, encoding: .utf8) ?? ""
        do {
            let doc = try SwiftSoup.parse(htmlString)
            let text = try doc.text()
            print("Text Content:\n\(text)")
            self.content = text
        }
        catch let error {
            print("Error: \(error)")
        }
    }
}
