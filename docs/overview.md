# Overview of Dianomi Android SDK

## Advert containers

The Dianomi SDK provides the ability to embed advert containers within native UIKit screens

- An advert container is provided as an UIView based DianomiAdvertView
DianomiAdvertView can be created in the Xcode Interface Builder (IB) or programmatically
- There can be several DianomiAdvertView 's in the view hieararchy
- Each advert container has a Context Feed ID. These IDs will be provided to you by a Dianomi
- An advert container may present one or more independently tapable adverts of varying types, as agreed with Dianomi for a given Context Feed ID
- Taping on an advert opens an external browser for that advert’s target URL

## Global configuration
The Dianomi SDK provides the ability to configure a number of properties that will apply to all `DianomiAdvertView`s within an app, including:

- Whether debug logging is enabled
- Advertising ID
- App User ID
- Consent String (e.g. for GDPR / CCPA)
- Whether the app has overriden appearance (dark mode)

## Configuring individual containers
The Dianomi SDK also provides the ability to configure a number of properties of an individual `DianomiAdvertView`, either in Interface builder or programmatically, including

- Context Feed ID (required)
- Advert Context


## Listening for state changes
The Dianomi SDK provides the ability to observe state changes for a `DianomiAdvertView` by setting an `AdvertDelegate`

- This could be used to e.g. show / hide a loading indicator for a given DianomiAdvertView
- This could be used to e.g. retry loading for a `DianomiAdvertView` when an attempted load fails, or hide a container that has failed to load
- A status call back can be used to update height of the DianomiAdvertView once the Ad content is rendered.

 
# How the Dianomi advert SDK works

The Dianomi SDK uses an iOS `WKWebView` to render content for each container. All advert content is therefore web-based, with Dianomi providing styling designed to mirror the look and feel of your app.
