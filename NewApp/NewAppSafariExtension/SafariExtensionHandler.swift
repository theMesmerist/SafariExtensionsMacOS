//
//  SafariExtensionHandler.swift
//  NewAppSafariExtension
//
//  Created by Emre Karaoğlu on 6.10.2024.
//

import SafariServices
import os.log

class SafariExtensionHandler: SFSafariExtensionHandler {
    
    var safari = SafariExtensionViewController()
    
    override func contextMenuItemSelected(withCommand command: String, in page: SFSafariPage, userInfo: [String : Any]? = nil) {
        page.getContainingTab { tab in
            tab.getContainingWindow { window in
                guard let window else { return }
                self.safari.window = window
                self.safari.searchAction(sender: window)
            }
        }
    }

    override func messageReceived(withName messageName: String, from page: SFSafariPage, userInfo: [String : Any]?) {
        if messageName == "selectedText", let selectedText = userInfo?["text"] as? String {
            print("Selected Text: \(selectedText)")
            safari.selectedText = selectedText
        }
    }

    override func validateToolbarItem(in window: SFSafariWindow, validationHandler: @escaping ((Bool, String) -> Void)) {
        safari.toolbarItemClicked(sender: window)
        validationHandler(true, "")
    }
    
    override func popoverViewController() -> SFSafariExtensionViewController {
        return safari
    }

}



