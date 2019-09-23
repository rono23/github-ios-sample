## WIP

- [x] Authentication
- [x] Fetch own repositories
- [ ] Search own repositories by keyword

## Setup

```
brew install carthage xcodegen swiftformat swiftlint
git clone git@github.com:rono23/github-ios-sample.git
cd github-ios-sample
git checkout oauth
carthage update --platform iOS

# https://github.com/settings/applications/xxx
## Set your Client ID, Client Secret and so on
cp Configs/Secrets.swift.example GitHub/Configs/Secrets.swift
vim GitHub/Configs/Secrets.swift

## Replace `rono23-github` with your `Secrets.OAuth.scheme`
vim GitHub/Info.plist

xcodegen generate
open GitHub.xcodeproj
```
