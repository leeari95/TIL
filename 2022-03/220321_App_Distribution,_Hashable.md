# 220321 App Distribution, Hashable

# TIL (Today I Learned)

3월 21일 (월)

## 학습 내용

- App Distribution 활동학습
- Hashable

&nbsp;

## 고민한 점 / 해결 방법

**[App Distribution]**

[Xcode Help](https://help.apple.com/xcode/mac/11.4/) 문서에서 아래와 같은 용어들의 내용을 알아보고 내 프로젝트에는 어떻게 적용되어야 하는지 확인해보자.

### [Project](https://help.apple.com/xcode/mac/11.4/#/devc8c2a6be1)

* 앱 개발에 필요한 파일과 리소스를 체계적으로 보관하는 공간.

### Bundle ID / App ID

* 앱의 식별자
* 애플에서 앱을 구분하는 구분자이다.

### [Target](https://help.apple.com/xcode/mac/11.4/#/devb3575be3e)

* 빌드하기 위한 제품 지정

### [Scheme](https://help.apple.com/xcode/mac/11.4/#/dev0bee46f46)

* '이 환경에서 실행이 될거에요.' 라는 환경설정 값 같은 것
* Target이랑 다른 점은 Target은 사용자에게 영향을 미치는 값이라면, Scheme은 테스트만을 위한 환경설정 값이라고 볼 수 있다.

### [Distribution methods](https://help.apple.com/xcode/mac/11.4/#/dev31de635e5)

* App Store Connenct
    * Provisioning Profile로 서명된 TestFlight 또는 App Store를 통해 앱을 배포하는 것.
    * 즉 앱스토어에 직접 배포하는 것을 뜻한다.
* Ad Hoc
    * 내부 테스트용으로 베포하는 것을 말한다.
* Enterprise
    * 사내 배포하는 것을 뜻함
    * 라이센스가 따로있다.
* Copy App
    * macOS에서 배포하는 방식
    * 주로 사이트 들어가서 다운받는 방식
* Development
    * 테스터에게 배포하는 것을 뜻함
* Developer ID
    * macOS 앱의 경우 Apple에서 공증을 받았거나 방금 개발자 ID 인증서로 서명한 앱을 Mac App Store 외부에 배포하여 사용자에게 신뢰할 수 있는 개발자임을 보증하는 것을 뜻한다.

### Provisioning Profile

![](https://i.imgur.com/IUTmwGx.png)

* 소프트웨어를 신뢰하는 건 Cretificate가 담당하고, Provisioning Profile는 각 디바이스가 개발자를 신뢰할 수 있는지 확인한다.
* Provisioning Profile은 앱을 앱스토어 or 테스트 배포를 하기 위해 Cretificate, Devices, AppID를 하나로 묶는 역할을 한다.
* 앱을 디바이스에 컴파일 하는데 사용한다.
    * 이 때 애플 개발자 페이지에 등록한 App Id와 실제 컴파일하려는 앱에 설정된 Bundle ID가 일치해야 설치된다.
* 누가(Certificate) / 어디서(Device) / 무엇을(App ID)


### [Signing certificate](https://help.apple.com/xcode/mac/11.4/#/dev3a05256b8)

* 애플이 개발자를 신뢰할 수 있는 보증서이다.
* 애플의 하드웨어에서 특정 소프트웨어가 동작하는데, 이 때 애플의 허가가 필요하다.
* 이 허가는 개발자가 Certificates를 생성하고 실행하여 xcode에 설치하면, 애플의 신뢰 대상이 되어 개발한 소프트웨어를 실행할 수 있다.

### Code signing

![](https://i.imgur.com/0tvW2W1.png)

* 앱에 서명한 사람을 식별하고 앱이 서명된 이후 수정되지 않았는지 확인할 수 있다.
* App Store에서 다운로드한 앱의 서명을 확인하여 서명이 잘못된 앱이 실행되지 않도록 한다.
* 앱 번들의 실행 코드가 변경되면 서명이 무효화되기 때문에 앱의 실행코드는 서명으로 보호된다.
* 유효한 서명을 통해 사용자는 앱이 Apple 소스에서 서명되었으며 서명된 이후 수정되지 않았음을 신뢰할 수 있다.


### Provisioning Profile

![](https://i.imgur.com/m3dY7og.png)

* 빌드된 앱이 실행될 환경
* 앱을 지정된 장치에 설치하고 앱 서비스를 사용할 수 있도록 하는 provisioning profile이다.

![](https://i.imgur.com/ncV7wd7.png)


### QnA

![](https://i.imgur.com/TZ4ZMNp.png)

* 보통 개인 프로젝트 같은 경우 Provisioning profile, signing 등등... 모두 자동으로 되어있지만, 현업에 가면 자동으로 하지않는다.


* 왜 Test도 Target으로 분류되는걸까요?
    * 테스트라는 것 자체도 하나의 앱으로 볼 수 있다.
    * 동작 주체이기 때문에 하나의 타깃으로 지정해줄 수 있다.

---

**[Hashable]**

### Hash란?

![](https://i.imgur.com/qVkOfXe.png)

데이터를 간단한 숫자로 변환한 것을 말한다.
원본 데이터를 특정 규칙에 따라 처리하여 간단한 숫자로 만든 것을 Hash Value라고 한다.

* hashing
    * 임의의 길이를 갖는 데이터(key)를 고정된 길이의 데이터(value)로 매핑하는 의미
* hash function
    * key > value 매핑하는 함수
* hash code
    * index 값
* hash value
    * hash code에 해당되는 value 값

### Hashable

hashing 기능 프로토콜.
임의의 길이를 갖는 데이터(key)를 고정된 길이의 데이터(value로) 매핑한다.

준수할 때 유의해야할 점
* 구조체의 경우 추가 구현없이 채택하는 것만으로도 사용 가능
* 클래스의 경우 직접 hash(into:)함수를 구현해주어야 함
* 열거형의 경우 
    * 연관값이 없는 경우면 채택하지않아도 자동으로 구현된다.
    * 연관값이 있는 경우에는 연관값의 타입, 열거형 모두 채택하고 있어야 한다.

### 코드예제

```swift
struct Project {
    let id: UUID
    var title: String
    var description: String
    var date: Date
    var status: ProjectState
    
}
extension Project: Hashable{
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
```

나의 경우는 id가 UUID 타입이기도하고 고유하기 때문에, id로만 값을 비교했으면 했다.
따라서 위 코드의 경우는 id의 값을 해쉬하겠다고, combine 메소드 파라미터로 전달해주고 있다.
그리고 == 연산자를 재정의하여 hashValue를 비교하도록 구현해주었다.




---

- 참고링크
    - https://ios-development.tistory.com/675
    - https://babbab2.tistory.com/149
