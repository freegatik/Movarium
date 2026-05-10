<img src="Movarium/Resourses/Assets.xcassets/Images/AppIcon.appiconset/180.png" width="200">

# Movarium
![Static Badge](https://img.shields.io/badge/platform-iOS-white)
![Static Badge](https://img.shields.io/badge/latest_release-v1.0.0-green)
![Static Badge](https://img.shields.io/badge/swift-v5.10-orange)

[![Build](https://github.com/freegatik/Movarium/actions/workflows/build.yml/badge.svg)](https://github.com/freegatik/Movarium/actions/workflows/build.yml)
[![Unit Tests](https://github.com/freegatik/Movarium/actions/workflows/unit-tests.yml/badge.svg)](https://github.com/freegatik/Movarium/actions/workflows/unit-tests.yml)
[![Swift Lint](https://github.com/freegatik/Movarium/actions/workflows/lint.yml/badge.svg)](https://github.com/freegatik/Movarium/actions/workflows/lint.yml)

# 📖 About
An application for viewing a catalog of films with the ability to rate, add to favorites and view reviews.

## 👨‍💻 iOS Deployment Target: 17.0 

## Architecture

Presentation → domain protocols / entities ← data (repos, DTOs, `AlamofireHTTPClient`, Core Data, Keychain). `Core/ApplicationSupport.swift`: loggers, plist URLs. `Data/Network/AppError.swift`: HTTP errors. `docs/adr/0001-architecture.md`.

## Configuration

`Info.plist`: `KREOSOFT_BASE_URL`, `KINOPOISK_BASE_URL`. Overrides: xcconfig (`Config/Example.xcconfig`). Local: `Config/Debug.local.xcconfig` (gitignored).

## Privacy

`PrivacyInfo.xcprivacy` in app target; extend when you use APIs that need privacy manifest entries.

## CI

Three workflows on [GitHub Actions](https://github.com/freegatik/Movarium/actions):

| Workflow       | What it runs |
|----------------|----------------|
| **Build**      | `xcodebuild build` on a dedicated **Movarium CI** simulator (iOS runtime ≥ app deployment target) |
| **Unit Tests** | `xcodebuild test` (unit + UI), code coverage + short `xccov` summary; uploads `.xcresult` on failure |
| **Swift Lint** | `swiftlint lint --strict` on Xcode **16.2** (non-blocking until style backlog is cleared) |

Build and Unit Tests share the composite action [`.github/actions/setup-ios-ci`](.github/actions/setup-ios-ci/action.yml) (Xcode **16.2**, first launch, iOS Simulator platform download) and [`.github/scripts/ensure-movarium-simulator.sh`](.github/scripts/ensure-movarium-simulator.sh) to create **`Movarium CI`**, then pass `platform=iOS Simulator,id=<UDID>,OS=<runtime version>` to `xcodebuild` so the destination does not depend on `OS:latest` name resolution and Xcode is less likely to warn about multiple matching destinations for the same UDID.

Dependabot: [`.github/dependabot.yml`](.github/dependabot.yml) bumps GitHub Actions pins weekly.

## Tooling

SwiftLint: `.swiftlint.yml`. CI uses Xcode **16.2** with split workflows under `.github/workflows/` (build, unit tests, lint).

## 💻 Tech Stack
- Swift
- UIKit + SwiftUI
- MVVM
- Clean Architecture
- SnapKit
- Alamofire
  
- Kingfisher (for download/upload images from URL)
- Keychain
- KeychainAccess
- Lottie (for animations)

## 🌟 Features

### Authentication & User Management
- Sign In and Sign Up functionality
- Profile customization
- Secure token-based authentication
- Auto logout on token expiration

### Movie Catalog
- Genre and date filtering
- Rating-based sorting
- Random movie suggestion
- Integration with Kinopoisk API
- Detailed movie information:
  - Cast and crew
  - Release date and runtime
  - Budget and rating
  - Genres
  - Description

### Social Features
- Movie reviews system
- Friends system
- Like/Dislike reviews
- Tinder-like movie swiping
- Instagram-style movie stories
- Favorite movies collection
- User activity feed

### Technical Features
- Intuitive tab-based navigation
- Smooth animations
- Image caching
- Russian/English localization
- Adaptive UI for all iPhone models

## 📱 Screenshots

<h3 align="center">Welcome Screen</h3>
<p align="center">
    <img src="Movarium/Resourses/Assets.xcassets/Images/screenshots/Image1.imageset/Image.png" width="200">
</p>

<h3 align="center">Authorization/Registration Screens</h3>
<p align="center">
    <img src="Movarium/Resourses/Assets.xcassets/Images/screenshots/Image2.imageset/Image.png" width="200">
    <img src="Movarium/Resourses/Assets.xcassets/Images/screenshots/Image4.imageset/Image.png" width="200">
    <img src="Movarium/Resourses/Assets.xcassets/Images/screenshots/Image7.imageset/Image.png" width="200">
    <img src="Movarium/Resourses/Assets.xcassets/Images/screenshots/Image8.imageset/Image.png" width="200">
</p>
<p align="center">
    <img src="Movarium/Resourses/Assets.xcassets/Images/screenshots/Image3.imageset/Image.png" width="200">
    <img src="Movarium/Resourses/Assets.xcassets/Images/screenshots/Image5.imageset/Image.png" width="200">
    <img src="Movarium/Resourses/Assets.xcassets/Images/screenshots/Image6.imageset/Image.png" width="200">
</p>

<h3 align="center">Feed Screen</h3>
<p align="center">
    <img src="Movarium/Resourses/Assets.xcassets/Images/screenshots/Image9.imageset/Image.png" width="200">
    <img src="Movarium/Resourses/Assets.xcassets/Images/screenshots/Image10.imageset/Image.png" width="200">
</p>

<h3 align="center">Movies Screen</h3>
<p align="center">
    <img src="Movarium/Resourses/Assets.xcassets/Images/screenshots/Image11.imageset/Image.png" width="200">
    <img src="Movarium/Resourses/Assets.xcassets/Images/screenshots/Image12.imageset/Image.png" width="200">
    <img src="Movarium/Resourses/Assets.xcassets/Images/screenshots/Image13.imageset/Image.png" width="200">
</p>

<h3 align="center">Favorites Screen</h3>
<p align="center">
    <img src="Movarium/Resourses/Assets.xcassets/Images/screenshots/Image14.imageset/Image.png" width="200">
</p>

<h3 align="center">Profile Screen</h3>
<p align="center">
    <img src="Movarium/Resourses/Assets.xcassets/Images/screenshots/Image15.imageset/Image.png" width="200">
</p>

<h3 align="center">Movie Details Screen</h3>
<p align="center">
    <img src="Movarium/Resourses/Assets.xcassets/Images/screenshots/Image16.imageset/Image.png" width="200">
    <img src="Movarium/Resourses/Assets.xcassets/Images/screenshots/Image17.imageset/Image.png" width="200">
    <img src="Movarium/Resourses/Assets.xcassets/Images/screenshots/Image18.imageset/Image.png" width="200">
    <img src="Movarium/Resourses/Assets.xcassets/Images/screenshots/Image19.imageset/Image.png" width="200">
    <img src="Movarium/Resourses/Assets.xcassets/Images/screenshots/Image21.imageset/Image.png" width="200">
</p>

<h3 align="center">Friends Screen</h3>
<p align="center">
    <img src="Movarium/Resourses/Assets.xcassets/Images/screenshots/Image20.imageset/Image.png" width="200">
</p>

## 🧑‍⚖️ License
```
MIT License

Copyright (c) 2024 Anton Solovev

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

```
