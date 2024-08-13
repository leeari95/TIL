# 240813 WidgetKit, App Groups, Keychain Access Group

앱과 위젯간에 Keychain, UserDefaults를 공유하는 방법에 대해 알아보자!


8월 13일 (화)


# 학습내용

위젯에서 앱에 저장되어있는 UserDefaults와 Keychain에 접근했는데, 아무 데이터도 조회되지 않아서 이를 해결해보았다.


## App Groups이란?

App Groups은 하나 이상의 앱이나 위젯이 데이터를 공유할 수 있도록 도와주는 기능이다.
예를 들어, 앱과 앱에 연결된 위젯이 동일한 데이터를 사용해야할 때 App Groups를 사용하면 쉽게 데이터를 공유할 수 있다.

[주요 개념](https://developer.apple.com/library/archive/documentation/Miscellaneous/Reference/EntitlementKeyReference/Chapters/EnablingAppSandbox.html#//apple_ref/doc/uid/TP40011195-CH4-SW19)은 다음과 같다:

* App Group 설정
    * 그룹을 설정하면 같은 개발팀에서 만든 여러 앱이 저장 공간을 공유할 수 있다. 이 공간은 캐시나 데이터베이스 같은 중요한 데이터가 저장되는 곳이다.
* 공유 메커니즘
    * App Group에 속한 앱들은 "Mach IPC and POSIX Semaphores and Shared Memory"와 같은 특정 기술을 통해 서로 데이터를 주고받을 수 있다. 이 기술들은 앱들이 안전하게 데이터를 주고받도록 해준다.
* 설정 방법
    * App Group을 설정하려면 설정 파일에서 `com.apple.security.application-groups`라는 키를 사용해야 한다. 이 키는 배열 형태로 이루어져 있으며, 배열 안에는 한개 이상의 문자열이 들어가야 한다.
    * 보통 문자열은 개발팀 ID와 임의로 정한 이름으로 이루어져 있다.

```xml
<key>com.apple.security.application-groups</key>
<array>
    <string>DG29478A379Q6483R9214.MyAppGroup1</string>
    <string>DG29478A379Q6483R9214.MyAppGroup2</string>
</array>
```

## UserDefaults를 앱과 위젯이 같이 공유하는 방법

먼저 앱과 위젯 Target에 App Group을 추가해주어야 한다.

### 1. **Xcode에서** App Group 추가하는 방법

* Xcode에서 프로젝트 내 왼쪽 사이드바에서 '프로젝트 이름'을 클릭한 후 Targets 리스트에서 해당하는 앱을 선택한다.
* 상단의 'Signing & Capabilities' 탭을 클릭한다.
* 화면 왼쪽에 '+ Capability' 버튼을 클릭하고 `App Groups`를 선택한다.
* App Groups가 추가되면,  'Add a new App Group' 버튼을 눌러 새로운 그룹을 추가할 수 있다.
* 새로운 그룹을 추가할 때 식별자를 입력한다. 나중에 데이터 공유를 위해 사용된다.

### 2. **entitlements** 파일에서 App Group 추가하는 방법

  * 프로젝트 내에서 `.entitlements` 파일에서 `<key>`와 `<array>` 태그를 사용해 다음과 같이 App Group을 추가한다.

```xml
<key>com.apple.security.application-groups</key>
<array>
    <string>group.com.domain.appName</string>
</array>
```

#

이렇게 앱 타겟과 위젯 타겟에 App Group을 추가하면 공유 컨테이너를 통해 File, UserDefaults, Core Data 등을 공유할 수 있게 된다.

추가한 앱 그룹을 통해 UserDefaults의 데이터를 접근하려면 아래와 같이 접근할 수 있다:
```swift
let userDefaults = UserDefaults(suiteName: "group.com.domain.appName") // 앱 그룹의 식별자
```

## Keychain을 앱과 위젯이 같이 공유하는 방법

기존에 우리 프로젝트는 비밀번호 같은 credential한 정보는 keychain을 통해 저장하고 있다.
이런 정보가 위젯에서도 필요한 경우가 있어서 알아보았다. 방법은 App Groups을 추가하는 방법과 꽤나 유사하다.

### 1. **Xcode에서** App Group 추가하는 방법

* Xcode에서 프로젝트 내 왼쪽 사이드바에서 '프로젝트 이름'을 클릭한 후 Targets 리스트에서 해당하는 앱을 선택한다.
* 상단의 'Signing & Capabilities' 탭을 클릭한다.
* 화면 왼쪽에 '+ Capability' 버튼을 클릭하고 `Keychain Sharing`를 선택한다.
* 같은 키체인 아이템을 공유하고자 하는 모든 앱에 동일한 키체인 접근 그룹을 설정한다.
* 키체인의 식별자의 경우 prefix로 `AppIdentifierPrefix`가 필수로 포함되어야 한다.
  * 포함하지 않았더니 다음과 같은 에러가 나면서 빌드가 안됐었다.
  * `Provisioning profile "iOS Team Provisioning Profile: <# Team ID #>" doesn't match the entitlements file's value for the keychain-access-groups entitlement.` 
* 앱의 팀 ID에 해당하는 값으로 동일한 개발자 팀이 만든 앱들만 키체인 항목을 공유할 수 있도록 보안을 강화하기 위함이다.

### 2. **entitlements** 파일에서 App Group 추가하는 방법

  * 프로젝트 내에서 다음과 같이 키체인 접근 그룹을 추가한다.

```xml
<key>keychain-access-groups</key>
<array>
    <string>$(AppIdentifierPrefix)com.yourcompany.sharedgroup</string>
</array>
```

#

이후 키체인 데이터를 접근 할 때에는 아래와 같이 쿼리를 설정해서 접근하면 된다.

```swift
let accessGroup = "<# Your Team ID #>.com.example.SharedItems"
let query = [kSecClass: kSecClassGenericPassword,
             kSecAttrService: service,
             kSecAttrAccount: username,
             kSecReturnAttributes: true,
             kSecAttrAccessGroup: accessGroup,
             kSecReturnData: true] as [String: Any]
var item: CFTypeRef?
let readStatus = SecItemCopyMatching(query as CFDictionary, &item)
```

---


# 참고 링크

- [https://developer.apple.com/library/archive/documentation/Miscellaneous/Reference/EntitlementKeyReference/Chapters/EnablingAppSandbox.html#//apple_ref/doc/uid/TP40011195-CH4-SW19](https://developer.apple.com/library/archive/documentation/Miscellaneous/Reference/EntitlementKeyReference/Chapters/EnablingAppSandbox.html#//apple_ref/doc/uid/TP40011195-CH4-SW19)
- [https://developer.apple.com/library/archive/documentation/General/Conceptual/ExtensibilityPG/ExtensionScenarios.html#//apple_ref/doc/uid/TP40014214-CH21-SW1](https://developer.apple.com/library/archive/documentation/General/Conceptual/ExtensibilityPG/ExtensionScenarios.html#//apple_ref/doc/uid/TP40014214-CH21-SW1)
- [https://developer.apple.com/documentation/security/keychain_services/keychain_items/sharing_access_to_keychain_items_among_a_collection_of_apps/](https://developer.apple.com/documentation/security/keychain_services/keychain_items/sharing_access_to_keychain_items_among_a_collection_of_apps/)
