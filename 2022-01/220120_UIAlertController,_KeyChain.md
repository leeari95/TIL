# 220120 UIAlertController, KeyChain
# TIL (Today I Learned)


1월 20일 (수)

## 학습 내용
- 오픈마켓2 STEP 1 PR 구현 및 작성
    - Alert에 TextField 추가해보기
- KeyChain 활동학습

&nbsp;

## 고민한 점 / 해결 방법

**[Alert에 TexField를 추가하여 텍스트를 입력 받아보자]**

```swift
func alertInputPassword(complection: @escaping (String) -> Void) {
    var resultTextField = UITextField()
    let alert = UIAlertController(title: "비밀번호를 입력해주세요", message: nil, preferredStyle: .alert)
    alert.addTextField { userTextField in
        userTextField.isSecureTextEntry = true // 텍스트를 암호화해준다.
        resultTextField = userTextField
    }
    let okAcrion = UIAlertAction(title: "OK", style: .default) { _ in
        guard let text = resultTextField.text else {
            DispatchQueue.main.async {
                self.showAlert(message: Message.unknownError) // 에러처리
            }
            return
        }
        complection(secret)
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    alert.addAction(okAcrion)
    alert.addAction(cancelAction)
    self.present(alert, animated: true, completion: nil)
}
```
* 비밀번호를 입력받고 검증하는 alert을 만들어보았다.
    * 먼저 대입할 TextField 인스턴스를 생성한다.
    * 이후 alert을 선언할 때 textfield를 추가하고 resultTextField에 대입해준다.
        * 텍스트필드를 추가로 구현하고 싶다면 alert.addTextField를 호출하면 된다.
    * 이후 okAction 핸들러 내부에서 resultTextField를 바인딩하여 해당 text를 사용할 수 있도록 completion 클로저에 담아준다.

```swift
self.alertInputPassword { secret in
    // 사용시에 secret을 활용하여 코드를 짜주면 된다.
}
```
* 주의해야하는 점은 ActionSheet에서는 TextField 구현이 불가능하다.

---

**[KeyChain]**

* iOS 앱 개발 프로젝트를 할 때 민감한 정보를 어디에 저장해야할까?
* UserDefaults
    * 데이터를 쉽게 저장할 수 있지만, 단순히 info 파일에 키-값 쌍을 텍스트 형태로 저장하기 때문에 OS를 탈옥하면 내용물을 볼 수 있다는 문제가 있다.
    * 따라서 보안이 필요한 데이터에는 적합하지 않다.
* 이를 방지하기 위해 암호나 API Token과 같은 민감한 정보를 KeyChain에 저장하는 것이 좋다.
* KeyChain은 디바이스 안에 암호화된 데이터 저장 공간을 의미한다. 사용자는 암호화된 공간에 데이터를 안전하게 보관할 수 있다.
* 무엇을 저장할까?
    * 로그인 및 암호 (해시)
    * 결제 데이터
    * 알고리즘 암호화를 위한 키
    * 등등.. 단순한 구조의 비밀을 유지하고 싶은 것들을 저장
* 특징
    * 사용자가 직접 제거하지 않는 이상 앱을 제거하고 설치해도 데이터는 남아있다.
    * 디바이스를 Lock하면 KeyChain도 잠기고 디바이스를 UnLock하면 KeyChain 역시 풀린다.
        * KeyChain이 잠긴 상태에서는 item들에 접근할 수도 복호화할 수도 없다.
        * KeyChain이 풀린 상태에서도 해당 item을 생성하고 저장한 어플리케이션에서만 접근이 가능하다.
    * 같은 개발자가 개발한 여러 앱에서 키체인 정보를 공유할 수 있다.
* KeyChain Service API
* ![](https://i.imgur.com/Wt1zzEL.png)
    * 민감한 데이터를 암호화, 복호화 하며 재사용하는 행위를 보다 쉽고 안전하게 사용할 수 있게 한다.
* KeyChain Items
* ![](https://i.imgur.com/Zt3ZRXg.png)
    * 키체인에 저장된 Data 단위. 키체인은 하나 이상의 KeyChain item을 가질 수 있다.
* KeyChain Item Class
    * 저장할 Data의 종류
        * kSecClassInternetPassword
        * kSecClassCertificate
        * kSecClassGenericPassword
        * kSecClassIdentity
        * kSecClassKey
    * 대표적으로 인터넷용 아이디/패스워드를 저장할 때 사용하는 kSecClassInternetPassword
    * 인증서를 저장할 때 사용하는 kSecClassCertificate
    * 일반 비밀번호를 저장할 때 사용하는 kSecClassGenericPassword 등이 있다.
* Attributes
    * KeyChain item을 설명하는 특성. item class에 따라 설정할 수 있는 attributes가 달라진다.
    * 애플 문서를 보면 아래와 같이 각 아이템 클래스 별로 다양한 어트리뷰트가 존재한다.
    * ![](https://i.imgur.com/rBv9yRb.png)

---

**[활동학습 정리]**

* ### 키체인이란 무엇일까?
    * OAuth 기반 서버에서 인증이 필요한 API를 호출할 경우 Access Toekn 사용해서 호출하는데, 해당 Access Token을 발급받았을 경우 어디에 저장을 할까?
    * UserDefaults나 다른 방법을 이용하는 경우에는 암호화 과정이 거쳐지지 않아서 좋지 않다.
    * 이럴 경우 KeyChain을 활용한다.
    * Passwords, Cryptographic keys, Certs & identities, Notes 등을 암호화해서 저장해둘 수 있는 열쇠 묶음
    * Password 뿐만 아니라 알아야하는 정보인 신용카드나 note도 저장할 수 있고, 인식할 필요는 없지만 필요한 것 (보안통신에 있어 필요한 정보, 다른 유저나 디바이스와 신뢰를 쌓기 위해서 필요한 정보)도 저장이 가능하다.
    * 앱을 삭제해도 키체인 정보는 남아있다.
    * 특징
        * 기본적으로 App은 자기 자신의 키 체인에만 접근할 수 있다.
        * iOS에서 키체인의 위치는 샌드박스(외부에서 받은 파일을 바로 실행하지 않고 보호된 영역에서 실행시켜봄으로써 잘못된 파일과 프로그램이 내부 시스템 전체에 악영향을 주는 것을 미연에 방지하는 기술) 외부이므로, 앱을 삭제해도 키체인에 저장된 정보는 삭제되지 않는다.
        * 앱의 프로비저닝 파일을 이용해서 앱 간의 사용 경로를 구분하기 때문에, 동일한 앱이라도 프로비저닝 파일을 변경해서 빌드하면 기존 정보를 더이상 조회할 수 없다.
        * 키체인 그룹을 사용하여 서로 다른 앱에서도 저장된 데이터를 공유할 수 있다.
        * 비밀번호 또는 개인 키처럼 보호가 필요한 항목은 암호화되어 키 체인으로 보호되며, 인증서처럼 보호가 필요하지 않은 항목은 암호화되지 않은 채로 저장된다.
        * 키체인은 잠글 수 있어서, 잠기면 해제하기 전까지 저장된 데이터에 접근할 수 없지만 iOS에서는 기기의 잠금이 해제되는 순간 키체인의 잠금도 함께 해제된다.
    * 샌드박스
        * 외부에서 받은 파일을 바로 실행하지 않고 보호된 영역에서 실행시켜 봄으로써 잘못된 파일과 프로그램이 내부 시스템 전체에 악영향을 주는지 확인하는 기술. 이를 확장해서 iOS에서는 애플리케이션간에 데이터 공유가 불가능하도록 격리된 각자의 샌드박스 공간을 제공하는데, iOS 시스템 자체에는 파일을 함부로 쓸 수 없지만 샌드박스 내에서는 파일 쓰기가 허용된다.
    * 구조
        * 단순하게도 키체인은 파일시스템에 저장된 데이터베이스다. SQLite 데이터베이스로 구현되어 있다.
        * macOS에서 사용자나 애플리케이션은 원하는 만큼 키체인을 만들 수 있지만 iOS에서는 모든 앱에서 사용할 수 있는 하나의 키체인만 사용한다.
        * 키체인 아이템(key chain item) 
            * 키체인에 저장되는 데이터로 키체인은 여러개의 키체인 아이템을 가질 수 있다.
        * 아이템 클래스(Item class)
            * 저장할 데이터의 종류이다.
                * ID/PW, 인증서, 인터넷 비밀번호 및 클래스로는 인터넷용 아이디 패스워드를 저장할 때 사용하는 kSecClassInternetPassword
                * 인증서를 저장할 때 사용하는 kSecClassCertificate
                * 일반 비밀번호를 저장할 때 사용하는 kSecClassGenericPassword 등이 있다.
        * 어트리뷰트(Attributed)
            * 아이템 클래스에 대한 속성이다. 아이템 클래스에 따라 설정할 수 있는 어트리뷰트 종류가 달라진다.
        * 키체인은 아이템을 정의할 때에는 저장할 데이터에 맞는 아이템 클래스를 선택해야 한다. 각 아이템 클래스는 저장값의 특성에 따라 서로 다른 어트리뷰트를 제공하기 때문이다.
                * 예시로 kSecClassGenericPassword 라는 아이템 클래스를 통해서 인증 토큰을 저장하려고 하는데, 여기에는 핵심 어트리뷰트가 kSecAttrAccount / kSecAttrService가 있다.
                    * kSecAttrAccount
                        * 앱을 식별할 수 있는 서비스 아이디
                    * kSecAttrService
                        * 저장할 비밀번호에 대한 사용자 계정
                * 그래서 키체인은 이 두개의 어트리뷰트를 메인 키로 하여 저장된 비밀번호를 식별한다.
* ### Keyed Archiver, User Defaults, CoreData와 다른 점은 무엇일까?
    * Keyed Archiver
        * https://developer.apple.com/documentation/foundation/nskeyedarchiver
        * 객체같은 사용자 정의 타입을 USerDefaults에 데이터의 형태로 저장
        * NSCoding 프로토콜을 채택하고 NSKeyedArchiver, NSKeyedUnarchoiver 인코딩/디코딩하여 사용
        * 앱을 삭제하면 함께 삭제된다
        * 인스턴스의 정보를 시스템에 저장
        * 딕셔너리와 같이 key-value 쌍으로 저장하기 위해 썼던 클래스
        * Objective-C에서 사용하기 위해 설계되었지만 현재도 사용할 수 있음
        * Swift에서는 사용하는 일이 많이 없다
        * Serialization 인스턴스를 파일 형태로 저장하기 위한 클래스
        * Key-value 형태로 아카이빙
        * 암호화 지원하지 않음
    * User Defaults
        * https://developer.apple.com/documentation/foundation/userdefaults/
        * 앱 이용자의 환경설정 등 키-값 형태로 저장해둘 수 있다.
        * 주로 단일 데이터인 값을 저장
        * 앱 삭제 전까지 유지
        * key-value 쌍으로 저장
        * 앱 전역적으로 사용하는 가벼운 저장소
        * 암호화 지원하지 않음
    * CoreData
        * https://developer.apple.com/documentation/coredata/
        * 복잡하고 큰 데이터를 저장
        * 앱이 많은 데이터를 필요로 하고 여러 다른 객체 간의 관계를 관리하고 객체에 빠르고 쉽게 접근해야한다면 CoreData를 사용하는 것이 좋다.
        * 역할
            * Persistence - 데이터 지속 관리
            * Undo and Redo of individual or Batched Changes 데이터 변경사항에 대한 실행취소/ 재실행 가능
            * 재실행 가능
                * 코어데이터의 변경 사항을 추적하여 이에 대한 취소작업이 가능
            * Background Data Tasks 백그라운드 상의 데이터 작업 지원
            * View Synchronization 뷰 동기화
                * 테이블뷰/컬렉션뷰 등의 UI에게 섹션, 행, 열 아이템을 관리해주는 DataSource를 제공하여 뷰와 데이터가 동기화 되도록 함
            * Versioning and Migration 버전 관리 및 데이터 이전 기능
            * 오프라인 활용
            * undo, redo 이용
    * 개략적인 비교
        * Though core data is slightly more complicated, it is useful when the stored information requires structure
        * NSKeyedArchiver is less complex and slower than core data, but is much simpler to use
        * UserDefaults is the simplest method to persist data
* iOS의 키체인과 macOS의 키체인의 차이는?
    * In iOS, apps have access to a single keychain (which logically encompasses the iCloud keychain). This keychain is automatically unlocked when the user unlocks the device then locked when the device is locked. An app can access only its own keychain items, or those shared with a group to which the app belongs. It can't manage the keychain container itself.
    * In macOS, however, the system supports an arbitrary number of keychains. You typically rely on the user to manage these with the Keychain Access app and work implicitly with the default keychain, much as you would in iOS. Nevertheless, the keychain services API does provide functions that you can use to manipulate keychains directly. For example, you can create and manage a keychain that is private to your app. On the other hand, robust access control mechanisms typically make this unnecessary for anything other than an app trying to replicate the keychain access utility.
    * 키체인의 개수가 다르다 (1개 vs 여러개)
    * macOS는 앱마다 다른 keychain을 사용할 수도 있고 iOS 같이 기본 keychain을 다 같이 사용할 수도 있다.
    * macOS는 keychain services API가 직접적으로 keychain을 관리할 수 있는 기능을 제공한다.
* ### 키체인 서비스를 사용하기 위해 k- 접두어를 사용하는 여러 타입과 값을 사용합니다
    * ### k- 접두어의 비밀은?
        * 상수의 의미로 표현되는 것(변하지 않는 값)
        * https://developer.apple.com/library/archive/documentation/CoreFoundation/Conceptual/CFDesignConcepts/Articles/NamingConventions.html#//apple_ref/doc/uid/20001110-CJBEJBHH
        * https://green1229.tistory.com/56
        * https://metalkin.tistory.com/20
        * Core Foundation 등의 Core Framework 헤더 파일들을 보면, 헝가리언 네이밍 규칙을 따른 흔적들을 제법 볼 수 있다.
        * 일단 ‘k’는 헝가리언 네이밍에 따라 사용된 걸로 보인다. 
        * Constants의 c는 이미 헝가리안에서 ‘char’의 ‘c’로 예약이 되어있는 상황이니 중복을 피하기 위해 동일한 발음 기호인 ‘k’를 사용한 것으로 추측된다. 
        * Core Foundation의 역사를 고려하면 헝가리언 네이밍을 따른 것이 어느정도 이해가 된다.
    * ### 어떤 프레임워크의 값일까?
        * CoreFoundation
        * ![](https://i.imgur.com/4ekh36u.png)
    * 그 프레임워크와 Foundation 프레임워크와의 차이는?
        * ![](https://i.imgur.com/vb3U81l.png)
        * CoreFoundation: C 기반의 프레임워크. low-level functions이기 때문에 속도 측면에서 우수하나 메모리 누수 이슈(ARC를 지원하지 않음)가 존재한다.
        * ![](https://i.imgur.com/1ZEM0En.png)
        * Foundation: objective-C 기반의 프레임워크. high-level functions. CoreFoundation과 동일한 Core Services Layer 계층에 속해있다.
* ### 키체인은 언제 사용하면 좋을까?
    * 로그인 비밀번호
    * 결제 데이터 
    * 암호화를 위한 키
* ### 웹 세션과 쿠키는 무엇일까?
    * 쿠키: 서버가 사용자의 웹 브라우저에 저장하는 데이터로, key: value의 형태로 저장된다. (예: 장바구니, 자동 로그인, 팝업 다시 보지않기 등)
    * 세션: 쿠키를 기반으로 하며, 사용자 정보파일을 서버 측에서 관리한다. 비교적 느린 처리 속도를 가지며 동시에 서버의 자원을 사용하기 때문에 사용에 한계가 있다. (예: 로그인 상태유지 등)
* ### 웹 세션과 쿠키와 키체인을 접목해서 활용해 볼 수 있을까?
    * 활용해볼 수 있을 것 같다. 실제로도 활용하고 있는 듯 하다. 로그인을 한적이 있는 웹페이지를 접속하면 키체인으로 로그인하겠냐는 알림이 뜨기도 한다.

- 참고링크
    - https://velog.io/@leeyoungwoozz/TIL-2021.05.21-Mon
    - https://green1229.tistory.com/56
    - https://velog.io/@rose6649/IOS-Keychain-%ED%82%A4%EC%B2%B4%EC%9D%B8-%EC%82%AC%EC%9A%A9%EB%B2%95
    - https://adora-y.tistory.com/entry/iOS-KeyChain%EC%9D%B4%EB%9E%80-Swift%EC%BD%94%EB%93%9C%EB%A5%BC-%ED%86%B5%ED%95%B4-%EC%82%B4%ED%8E%B4%EB%B3%B4%EA%B8%B0
    - https://velog.io/@rose6649/IOS-Keychain-%ED%82%A4%EC%B2%B4%EC%9D%B8-%EC%82%AC%EC%9A%A9%EB%B2%95
    - https://developer.apple.com/documentation/security/certificate_key_and_trust_services/keys/storing_keys_in_the_keychain
    - https://developer.apple.com/documentation/security/keychain_services
