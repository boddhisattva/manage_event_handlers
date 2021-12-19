# Manage Event Handlers

## About

This is a program to manage events and their handlers.

## Code Related Design Decisions

* The key concepts related to the problem domain are `EventsManager` and `Event`.
  - An EventManager allows one to subscribe to, unsubscribe from and perform a broadcast in the context of an event
  - An Event basically has a name and a listener as part of its properties

* Since an event ideally cannot be complete without an event name and the code/action that gets triggerred as part of an event related broadcast, with this in mind, **it is assumed** that an **Event handler has two main parts** - an `event name` and the `block of code` that it executes upon being triggerred
  * With this in mind, although it's not explicitly specified in the problem statement, I've added an event name as an additional paramater with regard to `subscribe`, `unsubscribe` and `broadcast` events. With this addition, only if a listener/subscriber, listens to/on a particular event or is capable of responding to it, only then we initiate a listener call as part of a broadcast.

* In order to ensure that each handler will be subscribed at most once, the following things have been accounted for:
  * The subscribers are stored as part of a `Set`(please see `#initialize` implementation in `EventsManager` class) which as a data structure has inherent properties like not allowing duplicates by default.
  * Even if two different Event instances having the same event name and block of code try to be subscribed to, at a given point in time, only one of them is stored among the list of subscribers(please see `#subscribe` implementation in `EventsManager` class) and the other event instance having the same details doesn't get stored

* Exceptions(including custom ones like `DuplicateHandlerError`) with appropriate error messages are added at appropriate places to handle edge cases. These are also accompanied with corresponding tests in addition to the tests that cover the happy path.

## Usage

### Dependencies
* Ruby 3.0
* Please refer to the Gemfile for the other dependencies

### Setup
* Run `bundle` from a project's root directory to install the related dependencies.

### Running the tests
* One can run the specs from the project's root directory with the command `rspec`

## Future Scope
* Handling of objects(in addition to blocks).
* Subscribing to multiple event names(that use the same code block) at once
