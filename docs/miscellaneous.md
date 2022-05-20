# Miscellaneous

## Video content

> The current SDK does **not** take viewabilty fully into account when determining when to start video content. The SDK may start playing videos when they are not in view.

Video content auto-plays when a container is loaded. It is therefore important to consider when to call `loadAd()`. For example, it may be appropriate to use lazy-loading in `UITableView/UICollectionView` to increase the likelihood that videos will be in view when playing when on screen.

## Tracking and monetisation
> The current SDK does **not** fully determine viewability of adverts within a container when tracking impressions vs viewability and in any viewability-based monetisation applied by advertisers.
The SDK may consider adverts to be viewable when they are not currently visible to the user.

Viewability needs to consider both when a container is viewable and whether specific adverts within that container are viewable (e.g. the top half of a container may be on screen but a particular advert may be in the bottom half of that container therefore off-screen). If viewability is important to your app it may be appropriate to use apropriate lazy-loading callbacks in `UITableView/UICollectionView` and to minimise the numbers of adverts within a container. But such measures will still not fully guarantee the accuracy of viewability measurement.

## Security
### Certificate pinning

The SDK does not provide direct support for hostname verification or certificate pinning for network operations performed by iOS WKWebViews within containers. If your app requires such functionality, please refer to Apple documentation:

See [Identity Pinning: How to configure server certificates for your app](https://developer.apple.com/news/?id=g9ejcf8y)

### Javascript in WkWebView's
The current SDK loads and displays adverts using iOS `WkWebView`s. These views:

- Have Javascript enabled
- Employ a Javascript interface (Javascript in web content calling back to iOS SDK code; no data passed)

These are required for the SDK to function.