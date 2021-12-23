Your goal is to write a class which can be used to manage events and their handlers.

The class should work like this:

- it has a .subscribe() method, which takes a block and stores it as a handler
- it has an .unsubscribe() method, which takes a block and removes it from its list of handlers
- it has an .broadcast() method, which takes an arbitrary number of arguments and calls all the stored blocks with these arguments

Note:
- this should be fully tested using RSpec (the test suite is part of the requirements)
- you should not worry about the order of handlers' execution
- the handlers will not attempt to modify an event object (e.g. add or remove handlers)
- the context of handlers' execution is not important
- each handler will be subscribed at most once at any given moment of time. It can still be unsubscribed and then subscribed again
