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

  
##External Frameworks:
- https://github.com/Thomvis/BrightFutures

##Classes
**NOTE:** Any class will inherit from the `NSOBject` Swift/ObjectiveC class
###Models
 - `AbstractUser`
  - `RootUser`
  - `User`
  	*-* `ErasedUser`
 - `UserList`
 - `UsersPersistenceManager`
 - `Bill`
 - `Ride`
 - `RideListManager`
 - `DataPersistenceDelegate`
 - `PersistenceManager`
 - `Extract`
 - `History`
 - `HistoryPersistenceManager`
 - `Collection`
 - `RGBColor`

###Views
**NOTE:** Any view will inherit from CocoaTouch's `UIView`

- `NewUserPopUp`
- `UserCell`
- *AbstractUserDetailViewController's Cells*
 - `AbstractUserDetailMainTableViewCell`
 - `UserDetailBillSliderTableViewCell`
 - `UserDetailFirstNameTableViewCell`
 - `UserDetailLastNameTableViewCell`
 - `UserDetailNickNameTableViewCell`
- *RootUserDetailViewController's Cells*
	- `RootUserDetailMainTableViewCell`
	- `RootUserTaxValueTableViewCell`
- *UserDetailViewController's Cells*
	- `UserDetailMainTableViewCell`
	- `UserDetailPayingValueTableViewCell`
- RideTableViewCell
- FakeSeparator
	
	
###Controllers
**NOTE:** AnyController will inherit form the CocoaTouch's `UIViewController`

- `UsersViewController`
- `UserDetailViewController`
- `DarkThemedViewController`
- `ExtractViewController`

##Protocols (*Interfaces*)
- `UserHandlingDelegate`
- `BillingHandlerDelegate`
- `DataPersistenceDelegate`
