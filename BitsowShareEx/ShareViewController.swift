//
//  ShareViewController.swift
//  BitsowShareEx
//
//  Created by Cynthia Tu on 3/26/16.
//  Copyright © 2016 Cynthia Tu. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices


class ShareViewController: SLComposeServiceViewController {

    let extensionName = "group.com.Bitsow.swift.shareExtension"
    let key = "url"
    
    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        self.extensionContext!.completeRequestReturningItems([], completionHandler: nil)
        
        
        
        
        // check if extension is valid
        if let content = extensionContext!.inputItems[0] as? NSExtensionItem {
            let contentType = kUTTypeURL as String
            
            // check provider is valid
            if let contents = content.attachments as? [NSItemProvider]{
                // look for url
                for attachment in contents {
                    if attachment.hasItemConformingToTypeIdentifier(contentType){
                        attachment.loadItemForTypeIdentifier(contentType, options: nil) { data, error in
                            let url = data as! NSURL
                            self.saveURL(self.key, url: url)
                        }
                    }
                }
            }
        }
        // Unblock UI
        self.extensionContext!.completeRequestReturningItems([], completionHandler: nil)
        
    }

    override func configurationItems() -> [AnyObject]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }
    
    // Saves an image to user defaults.
    func saveURL(key: String, url: NSURL) {
        if let saved = NSUserDefaults(suiteName: extensionName) {
            saved.setObject(url, forKey: key)
        }
    }

}
