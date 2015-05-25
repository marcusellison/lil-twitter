# lil-twitter
(ios) A Fun-Sized Twitter Client built in Swift

Time spent: `<Number of hours spent>`

### Features

#### Required

- [x] User can sign in using OAuth login flow
- [x] User can view last 20 tweets from their home timeline
- [x] The current signed in user will be persisted across restarts
- [x] In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp.  In other words, design the custom cell with the proper Auto Layout settings.  You will also need to augment the model classes.
- [x] User can pull to refresh
- [x] User can compose a new tweet by tapping on a compose button.
- [x] User can tap on a tweet to view it, with controls to retweet, favorite, and reply.
- [ ] User can retweet, favorite, and reply to the tweet directly from the timeline feed.

#### Optional

- [ ] When composing, you should have a countdown in the upper right for the tweet limit.
- [ ] After creating a new tweet, a user should be able to view it in the timeline immediately without refetching the timeline from the network.
- [x] Retweeting and favoriting should increment the retweet and favorite count.
- [ ] User should be able to unretweet and unfavorite and should decrement the retweet and favorite count.
- [ ] Replies should be prefixed with the username and the reply_id should be set when posting the tweet,
- [ ] User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client.

### Walkthrough

![Alt text](/gif/yelp-gif.gif?raw=true "Optional Title")

Installation

- Requires Xcode 6.3 beta
- Retrieve the Yelp API tokens from http://developer.yelp.com
- Create a folder called Config in the main folder (the one that contains the Podfile)

- Inside YelpLightConfig.xcconfig, change the following strings:
  - yelpConsumerKey = your-consumer-token
  - yelpConsumerSecret = your-consumer-secret
  - yelpToken = your-token
  - yelpTokenSecret = your-secret

GIF created with LiceCap.
