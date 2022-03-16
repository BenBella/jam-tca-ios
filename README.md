# The Composable Architecture + Swift UI

The Composable Architecture (TCA, for short) is a library for building applications in a consistent and understandable way, with composition, testing, and ergonomics in mind. It can be used in SwiftUI, UIKit, and more, and on any Apple platform (iOS, macOS, tvOS, and watchOS).

## Key features

* **State management:** How to manage the state of your application using simple value types, and share state across many screens so that mutations in one screen can be immediately observed in another screen.
* **Composition:** How to break down large features into smaller components that can be extracted to their own, isolated modules and be easily glued back together to form the feature.
* **Side effects:** How to let certain parts of the application talk to the outside world in the most testable and understandable way possible.
* **Testing:** How to not only test a feature built in the architecture, but also write integration tests for features that have been composed of many parts, and write end-to-end tests to understand how side effects influence your application. This allows you to make strong guarantees that your business logic is running in the way you expect.
* **Ergonomics:** How to accomplish all of the above in a simple API with as few concepts and moving parts as possible.

## Architecture overview

* **State:** A type that describes the data your feature needs to perform its logic and render its UI.
* **Action:** A type that represents all of the actions that can happen in your feature, such as user actions, notifications, event sources and more.
* **Environment:** A type that holds any dependencies the feature needs, such as API clients, analytics clients, etc.
* **Reducer:** A function that describes how to evolve the current state of the app to the next state given an action. The reducer is also responsible for returning any effects that should be run, such as API requests, which can be done by returning an `Effect` value.
* **Store:** The runtime that actually drives your feature. You send all user actions to the store so that the store can run the reducer and effects, and you can observe state changes in the store so that you can update UI.


# Modern Concurrency in Swift

## Await

Each time you see the await keyword, think `suspension point`. await means the following:

* The current code will suspend execution.
* The method you await will execute either immediately or later, depending on the system load. If there are other pending tasks with higher priority, it might need to wait.
* If the method or one of its child tasks throws an error, that error will bubble up the call hierarchy to the nearest `catch` statement.

Using await funnels each and every asynchronous call through the central dispatch system in the runtime, which:

* Prioritizes jobs.
* Propagates cancellation.
* Bubbles up errors.
* And more.

## Using async let binding

Swift offers a special syntax that lets you group several asynchronous calls and await them all together. An `async let` binding feels similar to a `promise` in other languages, but in Swift, the syntax integrates much more tightly with the runtime. It’s not just syntactic sugar but a feature implemented into the language.

To group concurrent bindings and extract their values, you have two options:

* Group them in a collection, such as an array.
* Wrap them in parentheses as a tuple and then destructure the result.