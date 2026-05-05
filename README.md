# Rick & Morty Character Guide

A SwiftUI app that lets you search and browse characters from the [Rick and Morty API](https://rickandmortyapi.com).

## Build & Run

- **Xcode**: 26+
- **iOS Deployment Target**: 26.0
- **Swift**: 6.0

Open `RickMortyCharGuide/RickMortyCharGuide.xcodeproj` in Xcode and run on a simulator or device.

## Architecture

- **MVVM** with SwiftUI's `@Observable` for reactive state management
- **Protocol-oriented networking**: A generic `APILoader` handles requests through `Router` (endpoint definition), `RequestHandler` (URL construction), and `ResponseHandler` (parsing) protocols
- **Separation of concerns**: The `Network/` folder is a reusable SDK layer with no app-specific logic. App-specific interpretation (e.g., treating 404 as "no results") lives in `Service/`

## Third-Party Dependencies

- [Nuke](https://github.com/kean/Nuke) (v13.0.5) — Async image loading and caching via `LazyImage`

## Design Decisions

- **Search on every keystroke**: Per the acceptance criteria, search fires immediately on each keystroke. In a production app, a debounce (~300ms) would be preferred to reduce unnecessary network traffic.
- **Tap target**: The entire grid cell is tappable for navigation (not just the image), as a deliberate UX improvement for better accessibility and touch targets.
- **Minimum loading duration**: The loading indicator is guaranteed visible for at least 300ms to avoid flickering on fast responses.

## Known Limitations

- **API rate limiting (429)**: The Rick and Morty API is prone to 429 responses. Pagination requests include automatic retry with exponential backoff (up to 5 retries). Search requests have no retries since each keystroke cancels and replaces the previous request.
- **Status bar during zoom transition**: When a grid item's image extends behind the status bar, the status bar text color (white-on-dark) doesn't update to black until the zoom navigation transition completes. This is a SwiftUI framework timing limitation — status bar style changes don't animate in sync with navigation transitions.
- **Image 429 errors**: Nuke image requests can also hit rate limits. A manual retry button is shown on image load failures. Automatic retry for images is not implemented.
- **No offline support**: The app requires an active network connection. No caching of API responses beyond Nuke's image cache.
