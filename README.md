[![Swift](https://img.shields.io/badge/Swift-5.6-orange?style=flat-square)](https://img.shields.io/badge/Swift-5.6-Orange?style=flat-square)
[![Platforms](https://img.shields.io/badge/Platforms-macOS_iOS_tvOS_watchOS_Linux-yellowgreen?style=flat-square)](https://img.shields.io/badge/Platforms-macOS_iOS_tvOS_watchOS_Linux-Green?style=flat-square)
[![Swift Package Manager](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square)](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square)

# OpenSea Stream API - Swift SDK

A Swift SDK for receiving updates from the OpenSea Stream API - pushed over websockets. We currently support the following event types on a per-collection basis:

item listed
item sold
item transferred
item metadata updates
item cancelled
item received offer
item received bid
This is a best effort delivery messaging system. Messages that are not received due to connection errors will not be re-sent. Messages may be delievered out of order. This SDK is offered as a beta experience as we work with developers in the ecosystem to make this a more robust and reliable system.

# Installation

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. 

Once you have your Swift package set up, adding OpenSeaSwift as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/arnauddorgans/OpenSeaSwift.git", .upToNextMajor(from: "1.0.0"))
]
```

# Getting Started

## Authentication

In order to make onboarding easy, we've integrated the OpenSea Stream API with our existing API key system. The API keys you have been using for the REST API should work here as well. If you don't already have one, request an API key from us [here](https://docs.opensea.io/reference/request-an-api-key).

## Create a client

```swift
import OpenSeaSwift

let client = OpenSea(token: "openseaApiKey")
```

You can also optionally pass in:

- a `network` if you would like to access testnet networks.
  - The default value is `StreamNetwork.mainnet`, which represents the following blockchains: Ethereum, Polygon mainnet, Klaytn mainnet, and Solana mainnet
  - Can also select `StreamNetwork.testnet`, which represents the following blockchains: Rinkeby, Polygon testnet (Mumbai), and Klaytn testnet (Baobab).

## Available Networks

The OpenSea Stream API is available on the following networks:

### Mainnet

`wss://stream.openseabeta.com/socket`

Mainnet supports events from the following blockchains: Ethereum, Polygon mainnet, Klaytn mainnet, and Solana mainnet.

### Testnet

`wss://testnets-stream.openseabeta.com/socket`

Testnet supports events from the following blockchains: Rinkeby, Polygon testnet (Mumbai), and Klaytn testnet (Baobab).

To create testnet instance of the client, you can create it with the following arguments:

```swift
import OpenSeaSwift

let client = OpenSea(token: "openseaApiKey", network: .testnet)
```

## Connecting to the socket

```swift
try await client.connect(onClose: { })
```

After successfully connecting to our websocket it is time to listen to specific events you're interested in!

## Streaming metadata updates

We will only send out metadata updates when we detect that the metadata provided in `tokenURI` has changed from what OpenSea has previously cached.

```swift
try await client.onItemMetadataUpdated(collectionSlug: "collection-slug") { event in
  // handle event
}
```

## Streaming item listed events

```swift
try await client.onItemListed(collectionSlug: "collection-slug") { event in
  // handle event
}
```

## Streaming item sold events

```swift
try await client.onItemSold(collectionSlug: "collection-slug") { event in
  // handle event
}
```

## Streaming item transferred events

```swift
try await client.onItemTransferred(collectionSlug: "collection-slug") { event in
  // handle event
}
```

## Streaming bids and offers

```swift
try await client.onItemReceivedBid(collectionSlug: "collection-slug") { event in
  // handle event
}

try await client.onItemReceivedOffer(collectionSlug: "collection-slug") { event in
  // handle event
}
```

## Streaming multiple event types

```swift
try await client.onEvents(
  collectionSlug: "collection-slug",
  eventKinds: [.itemReceivedOffer, .itemTransferred],
  handler: { event in /* handle event */ }
)
```

## Streaming order cancellations events

```swift
try await client.onItemCancelled(collectionSlug: "collection-slug") { event in
  // handle event
}
```

# Subscribing to events from all collections

If you'd like to listen to an event from all collections use wildcard `*` for the `collectionSlug` parameter.

# Types

Types are included to make working with our event payload objects easier.

# Disconnecting

## From a specific stream

All subscription methods return a subscription token that will allows you to unsubscribe from a stream when invoked.

```swift
let subscriptionToken = try await client.onItemMetadataUpdated(collectionSlug: "collection-slug") { event in }
try await client.leave(subscriptionToken)
```

## From the socket

```swift
try await client.disconnect()
```
