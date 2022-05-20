# SDK Configuration

## Global configuration options

> Use singleton class `DianomiAdverts` to 
configure global attributes for the Dianomi SDK.

> Attributes only apply to the newly loaded Adverts so should be set before loading ads, e.g. in your `AppDelegate` class.

Configure options before initialising and loading any advert containers.

## Debug Logging

Logging is usefuly for troubleshooting Ad loading when development. Logging is disabled by default.


To enable debug logging, set:

```
DianomiAdvertsshared.loggingEnabled = true
```

## Setting Advertising ID

Providing the SDK with *Identifier for vendor (IDFA)* may help Dianomi to better target adverts. Set Advertising ID by calling:

```
DianomiAdverts.shared.advertisingID = "Advertising ID" 
```

## Accessing IDFA on iOS
> The SDK does not obtain IDFA. The app will be responsible for obtaining it, including obtaining required user consent, etc.

Please follow Apple documentation about how to obtain the advertising ID:

- [App Tracking Trransparancy](https://developer.apple.com/documentation/apptrackingtransparency)

- [User Privacy and Data Use](https://developer.apple.com/app-store/user-privacy-and-data-use/)


## Setting an app User ID
> Consider data privacy when sharing any User ID.

If your app has the concept of a User ID, providing the SDK with that User ID may help Dianomi to better target adverts. Set User ID by calling `setUserId(...)`, e.g.

```
DianomiAdverts.shared.userID = "User ID"
```

## Setting a Consent String

> The SDK does not obtain Consent Strings for on your behalf, your app will be responsible for obtaining or constructing Consent Strings as agreed with Dianomi.

If your app is subject to privacy regulations such as GFPR or CCPA, you may be required to provide the SDK with a Consent String representing the current user’s consent status for your app.

```
DianomiAdverts.shared.consent "Consent string"
```

### Obtaining Consent String from your Consent Management Platform (CMP)

If your app is using a TCF-compliant CMP you should be able to read a Consent Strings according to TCF v1 and TCF v2 standards.

See TCF documentation:

- [GDPR-Transparency-and-Consent-Framework/Mobile In-App Consent APIs v1.0 Final.md at master · InteractiveAdvertisingBureau/GDPR-Transparency-and-Consent-Framework](https://github.com/InteractiveAdvertisingBureau/GDPR-Transparency-and-Consent-Framework/blob/master/Mobile%20In-App%20Consent%20APIs%20v1.0%20Final.md#access)  

- [GDPR-Transparency-and-Consent-Framework/IAB Tech Lab - CMP API v2.md at master · InteractiveAdvertisingBureau/GDPR-Transparency-and-Consent-Framework](https://github.com/InteractiveAdvertisingBureau/GDPR-Transparency-and-Consent-Framework/blob/master/TCFv2/IAB%20Tech%20Lab%20-%20CMP%20API%20v2.md#how-do-third-party-sdks-vendors-access-the-consent-information-in-app)

A basic TCF v2 solution might include

```
let consentString =  UserDefaults.standard.string(forKey: "IABTCF_TCString")
```

### Other consent strings

If you are unable to obtain a TCF Consent String in your app, you may be able to construct a Consent String using a format agreed with Dianomi, e.g.

```
DianomiAdverts.shared.consent = "gdpr=true,ccpa=false"
```

### Indicating whether the app is overriding UI appearance (dark mode)
If your app enables users to override system settings for Light/Dark mode appearance, pass this override status to the SDK so that Dianomi can take this override into account when advert content is presented. Set Dark Mode Override by calling:

```
DianomiAdverts.shared.appearanceOverride = .light
```
Supported values are

| Value | Meaning |
|------------------------------------------|----------------------------------|
| `AppearanceOverride.light` | The app uses light UI appearance |
| `AppearanceOverride.dark` | The app uses dark UI appearance |


## Container-specific configuration options

> Configure options before loading a container.

### Setting Context Feed ID

> A container must has a Context Feed ID set before it is initialised and content is loaded.

Every container must have a Context Feed ID set. Dianomi will agree on the set of available Context Feed IDs with you and particular IDs will map to particular advert arrangements optimised for a given area within your app.

- Set Context Feed ID in the IB using custom attribute Context Feed ID as illustrated earlier

- Set Context Feed ID programmatically during initialising of the ad container by calling `DianomiAdvertView(contextFeedId: "id")`

## Setting Advert Context

Providing the SDK with the context in which adverts will be displayed may help Dianomi to better target adverts. Advert Context could be something like an article title or similar

- Set Advert Context in the IB using custom attribute Context

- Set Advert Context programmatically during initialising of the ad container `DianomiAdvertView(contextFeedId: "id", context: "" "Your Context")`
