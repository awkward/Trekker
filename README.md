# Trekker

[![Build Status](https://travis-ci.org/awkward/Tatsi.svg?branch=master)](https://travis-ci.org/awkward/Tatsi)
[![Contact](https://img.shields.io/badge/contact-madeawkward-blue.svg?style=flat)](https://twitter.com/madeawkward)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A wrapper to easily swap out different analytics services or to support multiple analytics services at once. Trekker works best with event based analytics services like Mixpanel, Amplitude, Firebase, and Answers by Crashlytics.

### Introduction

Hi, we're <a href="https://awkward.co/" target="_blank">Awkward</a>. We used many different analytics services for our iOS reddit client called <a href="https://beamreddit.com/" target="_blank">Beam</a>. We weren't quite sure which service we wanted to use, so we wanted to make it easy to implement them all and switch between services on the fly. Trekker was born. We welcome you to use Trekker for your own projects.

### Features

- Event tracking
- Profile tracking
- Timed event tracking (event tracking met duration)
- Event Super Properties
- Push notification registration

### Getting started

### Add a submodule. 

1. Add Trekker as a submodule to your git project.
2. Drag `Trekker.xcodeproj` into the project navigator.
3. Go to the project settings and select the settings of the target you want to add Trekker too.
4. Click plus beneath the `Embedded Binaries` and select the `Trekker` framework in the Trekker project
5. Follow the steps below to add an analytics service (`TrekkerService`).

### Manually

1. Copy all Swift files from the Trekker directory to the project in your navigator.
2. Follow the steps below to add an analytics service (`TrekkerService`).

### Adding a TrekkerService

TrekkerService is the protocol that is implemented for every analytics service that is fed into Trekker.

Adding a Trekker is simple. 
First add the framework of the analytics service to your app. There are ready build implementations for some services, see the example services folder.

If the service doesn't have a ready implementation, a new subclass of NSObject should be made. It should implement the TrekkerService protocol. This requires implementing the following properties:

```Swift
var serviceName: String // The name of the analytics service

var versionString: String // The version of the SDK of the analytics service
```

Now you can implement the following protocols for the features the analytics service supports:

- `TrekkerEventAnalytics` for simple event based analytics
- `TrekkerTimedEventAnalytics` for time event analytics, these events will often have an added `duration` property
- `TrekkerPushNotificationAnalytics` for services that allow sending push notification messages
- `TrekkerUserProfileAnalytics` for services that support user profiles
- `TrekkerEventSuperPropertiesAnalytics` for services that support super properties. Properties that are included with every event.

### Documentation

> We're trying to keep our documentation as updated as possible. Here you can find more information on Trekker.

### License

> Trekker is available under the MIT license. See the LICENSE file for more info.

### Links

  - <a href="https://awkward.co/" target="_blank">Awkward</a>
  - <a href="https://beamreddit.com/" target="_blank">Beam</a>
