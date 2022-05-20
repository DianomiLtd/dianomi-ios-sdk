//
//  DianomiAdvertView.swift
//
//
// © 2022 Dianomi. All rights reserved.
//

import WebKit

@IBDesignable
public class DianomiAdvertView: UIView {
    
    /// Unit ID of the ad this Advert was initialised with
    @IBInspectable public var contextFeedID: String = ""

    /// Optional delegate that can be used to moniror status of the Ad
    public weak var delegate: AdvertDelegate?
    
    /// Make adview scrollable (not scrollable by default)
    @IBInspectable public var isScrollable: Bool = false {
        didSet {
            webView.scrollView.isScrollEnabled = isScrollable
        }
    }
    
    private lazy var webView: WKWebView = {
        let configuration  = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        configuration.userContentController.add(self, name: "contentRendered")
        
        if #available(iOS 14, macOS 11.0, *) {
            let wkPreferences = WKWebpagePreferences()
            wkPreferences.allowsContentJavaScript = true
            configuration.defaultWebpagePreferences = wkPreferences
        } else {
            let preferences = WKPreferences()
            preferences.javaScriptEnabled = true
            configuration.preferences = preferences
        }

        let wkWebView = WKWebView(frame: .zero, configuration: configuration)
        wkWebView.navigationDelegate = self
        wkWebView.uiDelegate = self
        
        wkWebView.scrollView.isScrollEnabled = isScrollable
        return wkWebView
    }()

    /// Preferred horizontal size of the ad. Only set once the ad is loaded
    public private(set) var contentHeight: CGFloat?
    
    private let dianomiAdverts: DianomiAdverts
    
    /// Reports the current status of the ad
    public private(set) var status: AdvertStatus = .created {
        didSet {
            dianomiAdverts.log("[Context feed ID '\(contextFeedID)'] Changed status to '\(status)'")
            delegate?.didChangeStatus(advertView: self, status: status)
        }
    }
    
    /// Sets context to be passed in Ad request
    public var context: String?
    
    /**
        Initialise advertView
        - Parameter id: Id of the Context Feed ID this advert represtents.
        - Parameter context: Context information to be passed in the Ad request.
    */
    public required init(contextFeedID: String, context: String? = nil) {
        DianomiAdverts.shared.log("[Context feed ID '\(contextFeedID)'] Creating DianomiAdvertView")
        self.contextFeedID = contextFeedID
        self.dianomiAdverts = .shared
        self.context = context
        
        super.init(frame: .zero)
        
        addSubview(webView)
    }
    
    // Internal initialiser allowing injecting webView (used for unit testing)
    internal init(contextFeedID: String, webView: WKWebView, adverts: DianomiAdverts = .shared) {
        self.contextFeedID = contextFeedID
        self.dianomiAdverts = adverts
        
        super.init(frame: .zero)
        
        self.webView = webView
        webView.navigationDelegate = self
        webView.uiDelegate = self
        addSubview(webView)
    }
    
    required init?(coder: NSCoder) {
        self.dianomiAdverts = .shared
        super.init(coder: coder)
        
        addSubview(webView)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        webView.frame = bounds
    }

    /// Loads the ad from the network
    public func loadAd() {
        var html = """
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html xmlns="http://www.w3.org/1999/xhtml">
<html>
<body style="margin:0;padding:0">
<meta name="viewport" content="width=device-width, initial-scale=0">
<script type="text/javascript" id="dianomi_context_script" src="https://www.dianomi.com/js/contextfeed.js"></script>
<div class="dianomi_context" data-dianomi-context-id="\(contextFeedID)"
"""
        
        if let consentString = dianomiAdverts.consent?.formUrlencoded {
            html.append(" data-dianomi-consent=" + "\"" + consentString + "\"")
        }

        if let darkmodeOverride = dianomiAdverts.appearanceOverride {
            html.append(" data-dianomi-darkmode-override=" + "\"" + darkmodeOverride.rawValue + "\"")
        }
        
        if let advertisingID = dianomiAdverts.advertisingID?.formUrlencoded {
            html.append(" data-dianomi-advertising-id=\"\(advertisingID)\"")
        }
        
        if let userId = dianomiAdverts.userId?.formUrlencoded {
            html.append(" data-dianomi-user-id=\"\(userId)\"")
        }
        
        if let context = context?.formUrlencoded {
            html.append(" data-dianomi-context=\"\(context)\"")
        }
        
        html.append("></div></html>")
        
        webView.loadHTMLString(html, baseURL: URL(string: "https://www.dianomi.com"))
        
        dianomiAdverts.log("[Context feed ID '\(contextFeedID)'] Webview loading ad content, HTML = \(html)")
        
        status = .loading
    }
    
    /// Stops loading the add and all of its resources
    public func stop() {
        
        dianomiAdverts.log("[Context feed ID '\(contextFeedID)'] Stopping Ad")
        webView.stopLoading()
        
        status = .created
    }
}

extension DianomiAdvertView: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard let scriptURL = URL(string: "https://www.dianomi.com/js/contentRendererListener.js") else {
            self.status = .failed(.invalidRequest)
            return
        }
        
        DispatchQueue.global().async { [weak self] in
            do {
                let contents = try String(contentsOf: scriptURL)
                DispatchQueue.main.async {
                    self?.webView.evaluateJavaScript(contents) { _, error in
                        if let error = error {
                            self?.loadingError(error)
                        } else {
                            self?.status = .loaded
                        }
                    }
                }
            } catch(let error) {
                self?.loadingError(error)
            }
        }
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        loadingError(error)
    }
    
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        loadingError(error)
    }
    
    private func loadingError(_ error: Error) {
        DispatchQueue.main.async { [contextFeedID, weak self] in
            self?.dianomiAdverts.log("[Context feed ID '\(contextFeedID)'] failed with error: \(error.localizedDescription)")
            self?.status = .failed(.loadingError(error))
        }
    }
}

extension DianomiAdvertView: WKUIDelegate {
    public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {

        if navigationAction.targetFrame == nil, let url = navigationAction.request.url {
            dianomiAdverts.log("[Context feed ID '\(contextFeedID)'] Opening URL: \(url) in the external browser")
            UIApplication.shared.open(url)
        }
        return nil
    }
}

extension DianomiAdvertView: WKScriptMessageHandler {
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        webView.evaluateJavaScript("document.documentElement.scrollHeight", completionHandler: { [contextFeedID, weak self] (height, error) in
            if let height = height as? CGFloat {
                self?.dianomiAdverts.log("[Context feed ID '\(contextFeedID)'] produced height: \(height)")
                self?.contentHeight = height
            } else {
                self?.dianomiAdverts.log("[Context feed ID '\(contextFeedID)'] unable to read height")
                self?.contentHeight = self?.frame.height
            }
            
            self?.status = .rendered
        })
    }
}
