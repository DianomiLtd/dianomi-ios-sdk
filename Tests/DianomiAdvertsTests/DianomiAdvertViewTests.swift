//
//  DianomiAdvertViewTests.swift
//
// © 2022 Dianomi. All rights reserved.
//

import XCTest
@testable import DianomiAdverts
import WebKit

final class DianomiAdvertViewTests: XCTestCase {
    
    var advertView: DianomiAdvertView!
    var mockWebView: MockWKWebView!
    var dianomiAdverts: DianomiAdverts = DianomiAdverts()
    
    override func setUp() {
        super.setUp()

        mockWebView = MockWKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        advertView = DianomiAdvertView(contextFeedID: "4343", webView: mockWebView, adverts: dianomiAdverts)
        mockWebView.navigationDelegate = advertView
    }
    
    func testAdvertView_whenInitialised_hadProperStatus() throws {

        XCTAssertEqual(advertView.status, AdvertStatus.created)
        XCTAssertEqual(advertView.contextFeedID, "4343")
    }
    
    func testAdvertView_onLoad_updatesStatus() throws {
        
        advertView.loadAd()
        
        XCTAssertEqual(advertView.status, AdvertStatus.loading)
    }

    func testAdvertView_onLoad_AddsContextId() throws {
        
        advertView.loadAd()
        
        XCTAssertTrue(mockWebView.loadHtmlStringArgsForCall.first?.string.contains("data-dianomi-context-id=\"4343\"") ?? false)
    }
    
    func testAdvertView_onLoad_AddsConsent() throws {
        
        advertView.loadAd()
        
        XCTAssertFalse(mockWebView.loadHtmlStringArgsForCall.last?.string.contains("data-dianomi-consent") ?? true)
        
        dianomiAdverts.consent = "a-consent"
        
        advertView.loadAd()
        
        XCTAssertTrue(mockWebView.loadHtmlStringArgsForCall.last?.string.contains("data-dianomi-consent=\"a-consent\"") ?? false)
    }
    
    func testAdvertView_onLoad_AddsDarkModeOverride() throws {
        
        advertView.loadAd()
        
        XCTAssertFalse(mockWebView.loadHtmlStringArgsForCall.last?.string.contains("data-dianomi-darkmode-override") ?? true)
        
        dianomiAdverts.appearanceOverride = .light
        
        advertView.loadAd()
        
        XCTAssertTrue(mockWebView.loadHtmlStringArgsForCall.last?.string.contains("data-dianomi-darkmode-override=\"false\"") ?? false)
        
        dianomiAdverts.appearanceOverride = .dark
        
        advertView.loadAd()
        
        XCTAssertTrue(mockWebView.loadHtmlStringArgsForCall.last?.string.contains("data-dianomi-darkmode-override=\"true\"") ?? false)
    }
    
    func testAdvertView_onLoad_AddsUserId() throws {
        
        dianomiAdverts.userId = nil
        
        advertView.loadAd()
        
        XCTAssertFalse(mockWebView.loadHtmlStringArgsForCall.last?.string.contains("data-dianomi-user-id") ?? true)
        
        dianomiAdverts.userId = "an id"
        
        advertView.loadAd()
                
        XCTAssertTrue(mockWebView.loadHtmlStringArgsForCall.last?.string.contains("data-dianomi-user-id=\"an+id\"") ?? false)
    }
    
    func testAdvertView_onLoad_AddsAdvertisingID() throws {
        
        dianomiAdverts.advertisingID = nil
        
        advertView.loadAd()
        
        XCTAssertFalse(mockWebView.loadHtmlStringArgsForCall.last?.string.contains("data-dianomi-advertising-id") ?? true)
        
        dianomiAdverts.advertisingID = "an-id"
        
        advertView.loadAd()
        
        XCTAssertTrue(mockWebView.loadHtmlStringArgsForCall.last?.string.contains("data-dianomi-advertising-id=\"an-id\"") ?? false)
    }
    
    func testAdvertView_onLoad_SetsBaseURL() throws {
        
        advertView.loadAd()
        
        XCTAssertEqual(mockWebView.loadHtmlStringArgsForCall.first?.baseURL, URL(string: "https://www.dianomi.com"))
    }
    
    func testAdvertView_onStop_stopsWebView() throws {
        
        advertView.stop()
        
        XCTAssertEqual(mockWebView.stopLoadingCallCount, 1)
        XCTAssertEqual(advertView.status, AdvertStatus.created)
    }
}

extension AdvertStatus: Equatable {
    public static func == (lhs: AdvertStatus, rhs: AdvertStatus) -> Bool {
        switch (lhs, rhs) {
        case (.created, .created), (.loading, .loading), (.loaded, .loaded), (.rendered, .rendered), (.failed, .failed):
            return true
        default:
            return false
        }
    }
}
