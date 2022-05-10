//
//  MockWKWebView.swift
//  
//
// © 2022 Dianomi. All rights reserved.
//

import WebKit

class MockWKWebView: WKWebView {
    var stopLoadingCallCount = 0
    override func stopLoading() {
        stopLoadingCallCount += 1
    }
    
    var loadHtmlStringArgsForCall = [(string: String, baseURL: URL?)]()
    override func loadHTMLString(_ string: String, baseURL: URL?) -> WKNavigation? {
        loadHtmlStringArgsForCall.append((string, baseURL))
        return nil
    }
}
