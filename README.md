# iOS-WB-Test-Template  

## Project & Overview

**1. Data Layer**
- [x] Add timestamp tracking for cached data
- [x] Implement core data persistence for offline support

**2. Network Layer**
- [x] Implement proper error handling
- [x] Add request retry mechanism
- [x] Add remaining API endpoints

**3. UI Features (Any Two)**
- [x] Implement loading states, animations, and error messages UI
- [x] Add offline mode indicator
- [x] Complete AssetDetailView implementation
- [x] Add pull-to-refresh functionality

**4. State Management**
- [ ] Save and restore the app state
	- *Had issues with the NavigationPath being saved and restored, didn't want to lose to much time on this one.*
- [x] Add the last update timestamp display
- [x] Implement favorites persistence

## Bugs to Fix

**1. Memory Management**
- [x] Fix memory leak in NetworkService closure
- [x] Correct strong reference cycle in async operations

**2. Concurrency Issues**
- [x] Fix @MainActor implementation
- [x] Handle proper thread management for core data
- [x] Resolve race condition in AssetListViewModel

**3. Testing**
- [x] Add unit tests for ViewModels
- [ ] Add unit tests for the network layer
	- *I usually don't unit test the network layer as I don't see the value in mocking data to just see if the mapping works, as the mocked data is fixed, not dynamic as expected in the real-world.*
- [ ] Add integration tests for NetworkService
	- *Skipped due to not wanting to take too much time.*
- [ ] Add UI tests for critical user flows
	- *Skipped due to not wanting to take too much time and lack of experience in the UI tests department.*
- [x] Implement test coverage reporting
	- *Implemented out of the box by Xcode.*

## Bonus Points
- [ ] Implement a widget for favorite cryptocurrencies
	- *Skipped due to not wanting to take too much time.*
- [ ] Add price alert functionality
	- *Skipped due to not wanting to take too much time.*
- [ ] Implement charts for price history
	- *Skipped due to not wanting to take too much time.*
- [x] Add localization support
