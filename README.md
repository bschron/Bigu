# BIGU - Be Good
![Bigu logo](http://unium.site11.com/Bigu/app@180.png)

##IDE
![Xcode logo](https://devimages.apple.com.edgekey.net/xcode/images/xcode-hero_2x.png)
**Language:** Swift <br>
**UI FrameWork:** CocoaTouch

##Supported Platforms

<ul>
<li>iOS
<ul>
<li>iPhone</li>
<li>iPad</li>
<li>iPod Touch</li>
</ul>
</li>
</ul>

##Main Features

 - Tax Management
 - Users Profile Management (*Multiple*)
  - basic informations (name, nickname, profile picture...)
  - Bill Storage and Handling
  - Map Pinning
  - Ride scheduling
 - Root User Profile
  - $ weekly collection
  - basic informations

##Classes
**NOTE:** Any class will inherit from the `NSOBject` Swift/ObjectiveC class
###Models
 - `AbstractUser`
  - `RootUser`
  - `User`
 - `UserList`
 - `UsersPersistenceManager`

###Views
**NOTE:** Any view will inherit from CocoaTouch's `UIView`

- `TaxCell`
 - `DefaultTaxCell`
 - `PickerTaxCell`
- `NewUserPopUp`
- `UserCell`
- *UserDetailViewController's Cells*
 - `UserDetailMainTableViewCell`
 - `UserDetailBillSliderTableViewCell`
 - `UserDetailFirstNameTableViewCell`
 - `UserDetailLastNameTableViewCell`
 - `UserDetailNickNameTableViewCell`

###Controllers
**NOTE:** AnyController will inherit form the CocoaTouch's `UIViewController`

- `UsersViewController`
- `UserDetailViewController`

##Protocols (*Interfaces*)
- `UserHandlingDelegate`
- `BillingProtocol`
- `BillingHandlerDelegate`
- `DataPersistenceDelegate`
- `TaxHandlingDelegate`
