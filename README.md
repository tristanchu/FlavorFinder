# FlavorFinder
The app for finding and saving your new favorite flavor combinations. Created for CS 98 Senior Project Implementation at Dartmouth College for educational purposes.

Project by: Courtney Ligh, Jaki Kimball, Tristan Chu, and Jon

## Pitch
The Flavor Finder is a flavor pairing lookup mobile app—a creative culinary tool for inspiration, experimentation, and reference with user-generated content. There is currently no easy mobile way to look up what flavors go well together or what flavors go well with the ingredients you currently have. A book called [The Flavor Bible](http://www.amazon.com/The-Flavor-Bible-Creativity-Imaginative/dp/0316118400) offer some flavor lookup capabilities, but it is incomplete in certain respects, most notably in static content limitations, accessibility via digital mobile platforms, and the medium's lack of multi-search lookup capabilities.

**Target users:** experienced and experimental cooks looking to break free from following exact recipes

Advanced features beyond basic flavor lookup:

1. **filtered searches** (e.g. only show vegetarian options)
	
2. **multi-item searches** (e.g. look up what goes with carrots *and* peas!)

3. **favorites** (pin your most-loved flavors to the top of your search results)

4. **lists** (manage collections of ingredients as customizable lists)

## Implementation
Flavor Finder is an iOS app built using Swift in Xcode. We use Github for version control and file sharing among the group members. For our initial test data, we will use a small portion of The Flavor Bible book as a model set. Ideally, we will move into having a community-driven data set, but the Flavor Bible works as a strictly educational source as it closely models the type of data and relations that we want to capture, convey, and query, though with some inconsistencies and missing fields.

## Frameworks Used
* [**Parse**](https://www.parse.com/?) as a backend solution & server
* [**CocoaPods**](https://cocoapods.org/) for package management
* [**icons8**](https://icons8.com/), [**Font Awesome**](http://fontawesome.io), [**The Noun Project**](https://thenounproject.com/) for icons
* [**Toast-Swift**](https://github.com/scalessec/Toast-Swift) for Toast notifications as user action feedback
* [**MGSwipeTableCell**](https://github.com/MortimerGoro/MGSwipeTableCell) for table row actions
* [**DOFavoriteButton**](https://github.com/okmr-d/DOFavoriteButton) for button animations and effects

## Seed Data
* Excerpt from [**The Flavor Bible** (2008)](http://www.amazon.com/Flavor-Bible-Essential-Creativity-Imaginative/dp/0316118400/) by Karen Page and Andrew Dornenburg for seed data, for educational purposes in a class setting and not available for public redistribution
