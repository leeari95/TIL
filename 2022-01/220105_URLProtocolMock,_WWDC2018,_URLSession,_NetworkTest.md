# 220105 URLProtocolMock, WWDC2018, URLSession, NetworkTest
# TIL (Today I Learned)


1월 5일 (수)

## 학습 내용
- 오픈 마켓 프로젝트 STEP 1 테스트 진행
    - URLProtocol을 Mock으로 만들어서 네트워크 테스트 진행하기

&nbsp;

## 고민한 점 / 해결 방법

**[URLProtocol?]**
* 야곰닷넷의 Unit Test강의를 참고하여 테스트코드를 위한 Mock 객체를 구현하다가 마주하게 된 경고
```swift
class StubURLSessionDataTask: URLSessionDataTask {
    var dummyData: DummyData?

    // init 부분에서 에러가 났다.
    init(dummy: DummyData?, completionHandler: DataTaskCompletionHandler?) {
        self.dummyData = dummy
        self.dummyData?.completionHandler = completionHandler
    }

    override func resume() {
        dummyData?.completion()
    }
}
```
> `'init()' was deprecated in iOS 13.0: Please use -[NSURLSession dataTaskWithRequest:] or other NSURLSession methods to create instances`
* 해당 경고를 없애고 싶어 구글링 중에 `URLProtocol`을 발견하게 되었다.
    * https://forums.raywenderlich.com/t/chapter-8-init-deprecated-in-ios-13/102050/7
* 코드만으로 이해가 어려워서 [WWDC 2018 Testing Tips & Tricks](https://developer.apple.com/videos/play/wwdc2018/417/) 부분을 공부해보았다.
    * 요약
        * Testing Network Requests
            * Decompose code for testability
            * URLProtocol as a mocking tool
            * Tiered testing strategy
    * [How to Use URLProtocol](https://developer.apple.com/documentation/foundation/urlprotocol)
    * ![](https://i.imgur.com/YGO4AZM.png) 
    * URLSession은 네트워크 통신을 할 수 있는 high level API를 제공한다.
    * 반면에 URLProtocol이라는 low level API도 제공한다.
        * 네트워크 연결을 열고, request를 쓰고, respnse를 주는 역할이다.
    * URLProtocol은 단독으로 쓰이지 않고 상속을 받도록 설계되어져있다. URL 로딩 시스템을 확장할 수 있게 한다.
    * URLProtocol을 사용해서 Mock객체를 만들고 Mock response를 만들어서 테스트를 진행할 수 있다.
* 테스트 피라미드
    * Unit Test
        * 한개의 메소드나 클래스를 테스트하는 가장 작은 단위이다.
        * 메소드의 성공, 실패등을 테스트한다.
        * 1분당 수백, 수천개의 테스트를 진행할 수 있다.
    * Integration
        * 한 개의 기능이 잘 작동하는 지를 테스트 하는 것
        * 여러 계층으로 연결된 클래스나 메소드가 잘 동작하는지 확인한다.
    * End-to-end
        * 하나의 프로그램이나 앱이 잘 동작하는지를 테스트 하는 것이다.
        * 사용자가 기기에서 수행하는 동작들을 테스트 한다.
        * 주로 UI Test로 진행한다.
        * 앱 내부 뿐만 아니라 OS나 외부 리소스와도 잘 상호작용 하는지 확인한다.
* ![](https://i.imgur.com/ffJ16Vh.png)
* URLRequest를 준비하고
* task가 서버와 통신을 하고
* 통신한 데이터를 파싱하고
* 파싱한 데이터를 뷰에 뿌려준다.

---

**[공부하다 메모한 흔적]**
* 테스트 기법중 하나를 메모...
    * 네트워크나 혹은 여러 side-effact에 강하게 커플링이 되어있는 객체를 가지고 테스트를 할 때에는 외부에서 가짜 데이터를 제공하는 어떤 Stub, 혹은 Mock 객체를 넣고 그 동작을 테스트 할 수 있는 것
* resume()은 왜 호출해주는 걸까?
    * dataTask는 기본적으로 일시정지(suspended)상태로 시작하기 때문이다. dataTask를 시작해주기 위해 resume()을 호출하는 것이다.
* 몰랐는데… URLRequest의 HTTPMethod의 기본값은 GET이였다.

---

**[이해를 위해 프로젝트에서 작성한 코드 설명해보기]**
* `MockURLProtocol`
    * URL 데이터 로딩을 다루는 추상클래스
    * URLProtocol은 URLProtocolClient 프로토콜을 통해 네트워크 진행 상황을 전달한다.
    * 테스트 번들에서 MockURLProtocol 클래스를 만들고 메소드를 재정의 해준다.
    * 로드를 할 때 설정한 후 전달할 Data, Error, Response를 딕셔너리로 설정해준다.
        * 이 값은 URLProtocol에 연결하여 설정값을 세팅해주기 위한 값이 된다.
    * Unit Test를 위해 상속받아서 오버라이드 함으로써 커스텀 하여 Mock 객체를 새롭게 만들 수 있다.
        * 기존처럼 외부 네트워크에 요청을 직접 보내는 동작이 아니라, 요청을 가로채서 원하는 응답을 반환하게 끔 커스텀 하는 작업이다.
        * 즉 원래 같이 웹 서버에서 데이터를 불러오는 과정이 아니고, 내가 설정한 값(data, response)을 그대로 반환하게 만들어 주는 과정인 것이다.
* `MockSession`
    * 앞서 만든 프로토콜을 URLSession의 configuration에 넣어주면 개발자가 임의로 작성한 로직이 URLSession 내부에서 실행될 것이다.
* `NetworkManager 테스트코드`
    * 테스트코드를 작성할 때에는 원하는 결과 값(url, data, response)을 mockURLs 딕셔너리 값에 대입해주고 그걸 토대로 성공, 혹은 실패에 대한 네트워크 테스트를 진행한다.

---

- 참고링크
    - https://developer.apple.com/videos/play/wwdc2018/417/
    - https://developer.apple.com/documentation/foundation/urlprotocol
    - https://velog.io/@seunkim/WWDC18-Testing-Tips-Tricks1-Testing-network-requests
    - https://velog.io/@leeyoungwoozz/TIL-2021.05.21-Fri
    - https://velog.io/@minni/URLSession-URLSessionConfiguration-URLSessionTask
    - https://www.youtube.com/watch?v=meTnd09Pf_M&t=229s
    - https://forums.raywenderlich.com/t/chapter-8-init-deprecated-in-ios-13/102050/7
