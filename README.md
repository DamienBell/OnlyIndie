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
which passes in the __Shop__ object. This shows the shop details, and UI for
opening maps, yelp, or foursquare. Additionally, another call is made to the onlyindiecoffee api
to determine if there is a foursquare location. If so, the the foursquare button
is shown, and an image gallery is instantiated using the __AsyncImageGallery__ class.

* __Shop__: The shop object is built from the api data, and is really the backbone
of the app. When instantiated, the shop calculates the users distance from the shop,
and sets general information, and images. Additionally the shop is responsible for
determining if foursquare has this location so that the user can checkin on
foursquare if they wish. Methods on the shop are called to open in
foursquare, yelp, or maps. If foursquare, or yelp aren't available natively then they should
open to the relevant url in Safari.

* __AsyncImageGallery__: If get images from the api, then those
images are rendered in a gallery at the top of __shopsDetailsViewController__. These images
are loaded asynchronously as the user swipes to avoid locking up the UI.

![screen shot one](https://raw.github.com/DamienBell/OnlyIndie/master/photo1.PNG)
![screen shot two](https://raw.github.com/DamienBell/OnlyIndie/master/photo2.PNG)
