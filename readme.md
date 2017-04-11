Student-Management-System-iOS-Firebase
======================================

[![Platform](http://img.shields.io/badge/platform-ios-blue.svg?style=flat
)](https://developer.apple.com/iphone/index.action)
[![Language](http://img.shields.io/badge/language-swift-brightgreen.svg?style=flat
)](https://developer.apple.com/swift)

Student Information Management System deals with all kind of student details, academic related reports, college details, course details, curriculum, batch details and other resource related details too.
<br> *** This software system only stores and retrieves students’ partial information in the current semester and other basic information.

<a href="https://imgflip.com/gif/1n2rg8"><img src="https://i.imgflip.com/1n2rg8.gif" title="made at imgflip.com"/></a>
<a href="https://imgflip.com/gif/1n2s63"><img src="https://i.imgflip.com/1n2s63.gif" title="made at imgflip.com"/></a>
<a href="https://imgflip.com/gif/1n2srl"><img src="https://i.imgflip.com/1n2srl.gif" title="made at imgflip.com"/></a>

## Features
#### Login as an admin:
- Manage student's information including ADD, DELETE, UPDATE taking courses and grades.
- Manage all the courses in the school system.

#### Login as a student:
- Able to VIEW persional information such as number of taking courses, total credits, GPA and change profile picture.

#### Bonus:
- Implementation of Remote Push Notification whenever getting updates by admin using Firebase Message Clouding * Run only real device.

## Installation
### Requirements
- Xcode 8+, Swift 3+ with ARC

### CocoaPods
If your OSX has CocoaPods already, just ignore this step. Otherwise, open `Terminal`, then run `sudo gem install cocoapods` to install. [(link)](https://cocoapods.org)

### Setup Firebase
- Add Firebase to the iOS Project. [(link)](https://firebase.google.com/docs/ios/setup)
- Make sure the project has `GoogleService-Info.plist` file.
- Import database from `/Documents/database.json`
