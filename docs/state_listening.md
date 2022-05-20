# Listening for container state changes

## Setting a delegate
A container supports a single `AdvertDelegate` that will be notified of events for that container.

> Setting a delegatre is optional. 

Set the delegate by setting DianomiAdvertView's `delegate` property, e.g.

```
advert.delegate = your class
```

## The delegate interface 

The `AdvertDelegate` interface is

```
public protocol AdvertDelegate: AnyObject {
    /**
        Use this method to get notified when a loading status if advert is changed
     - Parameter advertView: advert that is being reported
     - Parameter status: status of the ad.
    */
    func didChangeStatus(advertView: DianomiAdvertView, status: AdvertStatus)
}
```

Where the status is the status of the advert:

```
public enum AdvertStatus {
    case created
    case loading
    case loaded
    case rendered
    case failed(AdvertError)
}
``` 

| Method | Meaning |
|--------|---------|
|`.created` | Initial state set when the `DianomiAdvertView` is created |
|`.loading` | State set when the Advert content started to load. The app might want to display a loading indicator if appropriate. |
|`.loaded` | State set when Advert successfully completes. The Advert might be rendered in the original frame assigned when creating the Advert container |
|`.rendered` | Called when the Advert is fully rendered. At this point the app might want to access its contentHeight to update container height to optimal size. |
|`.failed(AdvertError)` | Called when loading of the ad fails with error. The nature of the error could be established by comparing of the associated error value. |


## The error enum

The `.failed` status may provide an `AdvertError` with details of the error. Supported values are:

```

public enum AdvertError: Error {
    case invalidRequest
    case loadingError(Error)
}
```

Properties are:

| Property | Meaning |
|----------|---------|
| `invalidRequest `   | Runtime error when a request might not be created|
| `loadingError(Error)`| Underlying `NSURLSession` or similar error when a request in the WebView fails. |



## Getting current state

As well as listening for state changes using a delegate, your app can also directly access the current state of a container by accessing status property, e.g.

```
advert.status
```

Please see the table above for possible status values.
