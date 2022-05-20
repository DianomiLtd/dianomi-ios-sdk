# Retaining displayed adverts

## Using advert containers in UITableView/UICollectionView

When using `DianomiAdvertView`s in an iOS `UITableView` or `UICollectionView`, care must be taken to ensure that a container does not load new adverts when cells are recycled.

> Speak to Dianomi to understand whether you should avoid different adverts being presented when the user scrolls or whether doing so could actually be desirable (as it could expose the user to more adverts).

Assuming that non-reloading `DianomiAdvertView` behaviour is desirable, the app should retail the instances of `DianomiAdvertView` even outside the `UITableViewCell/UICollectionViewCell`. 


### Ensuring that content is loaded / lazy-loaded

> Speak to Dianomi about whether it is best to eager-load or lazy-load adverts in your app. In most cases, lazy-loading may be the preferred option.

> An advantage of eager-loading is that content is more likely to be rendered when the `UITableView/UICollectionView` is scrolled so that a container is in view.

Advantages of lazy-loading content include:

- Network and processor only used for containers likely to be in view
- May be preferred by advertisers where monetisation is based on viewability

#### Eager loading

If you wish to load content up-front, load immediately after initialising each container, e.g.

```
let advert = DianomiAdvertView(contextFeedID: "id")
view.adSubview(advert)
      
// Eager-load content
advert.load()
```

#### Lazy loading

If you wish to only load a given container when it is likely to view viewed, instead of the above, load when the ad is actually needed. Such as in `tableView(_:willDisplay:forRowAt:)` method (if using `UITableView`). The actual initialisation of the `DianomiAdvertView` is very cheap compared to loading WebView contents.

```
let advert = DianomiAdvertView(contextFeedID: "id")

func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    advert.load()   
}
```


