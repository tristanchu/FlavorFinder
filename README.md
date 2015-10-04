# FlavorFinder
App for matching and finding new flavors. Created for CS 98 Senior Project Implementation at Dartmouth College.

## Pitch
The Flavor Finder is a flavor lookup mobile app—a creative culinary tool for inspiration, experimentation, and reference with user-generated content. There is currently no easy mobile way to look up what flavors go well together or what flavors go well with the ingredients you currently have (except for wine+cheese pairing apps that don’t cover the scope of flavors we hope to cover). A book called The Flavor Bible exists with a flavor lookup section, but it is bulky and its eBook is not user-friendly; moreover, it is incomplete in certain respects. This app will be perfect for looking up flavors on the go (e.g. supermarket, farmer's market), but also handy in the kitchen

Target users: experienced and experimental cooks (intermediate to advanced skill)
Advanced features beyond basic flavor lookup:
    a) advanced searches (e.g. filter out non-vegetarian flavors, search for flavors compatible with two or three user-chosen flavors rather than just one, etc.)
    b) browsing recipes in-app that use selected flavors (pulled from recipe website)

## Strategy & Timeline
Essentially, this fall we are focusing on the core flavor lookup aspects of the app, and in the winter we are focusing on user experience and user-driven features/content.

*Sept. 28–October 10: Familiarizing with Swift (do tutorial) & research technical design aspects
*October 1–October 12: Create design doc / vision especially figuring out database tech
*October 10–21: Skeleton ios app up
*October 10–17: Crawler of ebook section (The Flavor Bible) for our development data set - manually mark some data for testing advanced filter options not in book’s data (ex. “vegetarian”)
*October 17–November 7: Small scale beta version with sample data, with very basic search
*November 4–November 25: Advanced search and/or filtering

In winter term, we expect to focus more heavily on UX/UI testing/development and also develop community-driven data creation/modification; we may also make adjustments to advanced search during this time based on user testing. Favorites and more user-based features would exist. We would also have integration with a recipe website’s API for pulling recipes related to flavor lookups. Over winter break, we will likely be in contact and do some of the initial planning/research for these additional features, and also start lining up user testers.

## Implementation
We have decided that we want to do an iOS app and use Swift for the components related to that. We will use Github for version control and file sharing among the group. For our initial test data, as a model set, we will use a small portion of The Flavor Bible book. Ideally, we will move into having some sort of community-driven data set, but we chose this resource for initial educational development purposes as it closely models the type of data and relations that we want to capture, convey, and query.