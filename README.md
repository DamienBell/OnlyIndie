#Only Indie Coffee
###Find independent coffee shops near you.

Here's a quick rundown of how this app operates.

OIC uses four custom classes.

*  __shopsMasterViewController__: Inherits from UITableViewController.
This view is responsible for getting the users location,
and sending location data to the onlyindiecoffee api. On success
the api returns an array of json objects which are iterated through
and saved as __Shop__ objects. The __Shop__ objects are then rendered
to the UITableView. This controller also has a pull to refresh which repeats
the process, and a few error states to account for poor connection or
server error.

*  __shopsDetailsViewController__: This view is triggered from from the TableView
which passes a __Shop__ object to this view. This view is responsible for showing
shop details, opening maps with directions to the shop, as well as opening the shop
in yelp, or foursquare. Additionally, another call is made to the onlyindiecoffee api
to determine if there is a foursquare location. If so, the the foursquare button
is shown, and an image gallery is instantiated using the __AsyncImageGallery__ class.

* __Shop__: The shop object is built from the api data, and is really the backbone
of the app. When instantiated, the shop calculates the users distance from the shop,
and sets general information, and images. Additionally the shop is responsible for
determining if foursquare also has this location so that the user can open to the
foursquare location if they wish. Methods on the shop are called to open in
foursquare, yelp, or maps.

* __AsyncImageGallery__: If we're able to get images from the api, then those
images are rendered in a gallery on the __shopsDetailsViewController__. These images
preload as they're swiped, and done so asynchronously to avoid locking up the UI.

![screen shot one](https://raw.github.com/DamienBell/OnlyIndie/master/photo1.PNG)
![screen shot two](https://raw.github.com/DamienBell/OnlyIndie/master/photo2.PNG)
