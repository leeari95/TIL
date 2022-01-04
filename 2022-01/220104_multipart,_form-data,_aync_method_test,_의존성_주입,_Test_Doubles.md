# 220104 multipart, form-data, aync method test, 의존성 주입, Test Doubles
# TIL (Today I Learned)


1월 4일 (화)

## 학습 내용
- 오픈 마켓 프로젝트 STEP 1 진행
- multipart/form-data
- 비동기 메소드 테스트 하는 방법
- 의존성 주입이란?
- Test Doubles

&nbsp;

## 고민한 점 / 해결 방법

**[multipart/form-data]**

* multipart 타입을 통해 MIME은 트리 구조의 메세지 형식을 정의할 수 있다.
    * 어떤 것이 첨부된 텍스트(multipart/mixed)
    * 텍스트와 HTML과 같이 다른 포맷을 함께 보낸 메세지(multipart/alternative)
* multipart 메세지
    * 서로 붙어있는 여러개의 메세지를 포함하여 하나의 복합 메세지로 보내진다.
    * MIME multipart 메세지는 "Content-Type:" 헤더에 boundary 파라미터를 포함한다
    * boundary는 메세지 파트를 구분하는 역할을 하며 메세지의 시작과 끝 부분도 나타난다.
    * 첫번째 Boundary 전에 나오는 내용은 MIME을 지원하지 않는 클라이언트를 위해 제공된다.
    * boundary를 선택하는 것은 클라이언트의 몫이다. 보통 부작위의 문자를 선택해 메세지의 본문과 충돌을 피한다.
        * UUID
* multipart form 제출
    * HTTP form을 채워서 제출하면 가변 길이 텍스트 필드와 업로드 될 객체는 각각 멀티파트 본문을 구성하는 하나의 파트가 보내진다. 멀티파트 본문은 여러 다른 종류와 길이의 값으로 채워진 form을 허용한다.
* multipart/form-data
    * 사용자가 양식을 작성한 결과 값의 집합을 번들로 만드는데 사용한다.
> First, there’s the Content-Type header. It contains information about the type of data you’re sending (multipart/form-data;) and a boundary. This boundary should always have a unique, somewhat random value. In the example above I used a UUID. Since multipart forms are not always sent to the server all at once but rather in chunks, the server needs some way to know when a certain part of the form you’re sending it ends or begins. This is what the boundary value is used for. This must be communicated in the headers since that’s the first thing the receiving server will be able to read.
* 파일 업로드할 때 알아야하는 HTTP 규약
* ![](https://i.imgur.com/allgCmS.png)
* 서버에 `multipart/form-data`로 데이터를 보낼 때의 request header와 body는 위 이미지와 같이 구성되어있다.
    * Content-Type이 multipart/form-data로 지정되어있어야 서버에서 정상적으로 데이터를 처리할 수 있다.
    * 전송되는 파일 데이터의 구분자로 boundary에 지정되어 있는 문자열을 이용한다.
    * boundary의 문자열 마지막 `**------WebKitFormBoundaryQGvWeNAiOE4g2VM5--**` 값은 다른값과 다르게 `--`가 마지막에 붙어있는데, body의 끝을 알리는 의미를 가진다.
* 이 규격에 맞게 http header와 body 데이터를 생성한 후 HTTP server에 요청하게 되면 서버에서도 HTTP 통신 규격에 맞게 데이터를 파싱한 후 처리하게 된다.
* 아래는 HTTP Request Data, HTTP Response Data 예시다.
```
## HTTP Request Data

POST /file/upload HTTP/1.1[\r][\n]

Content-Length: 344[\r][\n]

Content-Type: multipart/form-data; boundary=Uee--r1_eDOWu7FpA0LJdLwCMLJQapQGu[\r][\n]

Host: localhost:8080[\r][\n]

Connection: Keep-Alive[\r][\n]

User-Agent: Apache-HttpClient/4.3.4 (java 1.5)[\r][\n]

Accept-Encoding: gzip,deflate[\r][\n]

[\r][\n]

--Uee--r1_eDOWu7FpA0LJdLwCMLJQapQGu[\r][\n]

Content-Disposition: form-data; name=files; filename=test.txt[\r][\n]

Content-Type: application/octet-stream[\r][\n]

[\r][\n]

aaaa

[\r][\n]

--Uee--r1_eDOWu7FpA0LJdLwCMLJQapQGu[\r][\n]

Content-Disposition: form-data; name=files; filename=test1.txt[\r][\n]

Content-Type: application/octet-stream[\r][\n]

[\r][\n]

1111

[\r][\n]

--Uee--r1_eDOWu7FpA0LJdLwCMLJQapQGu--[\r][\n]


## HTTP Response Data

HTTPHTTP/1.1 200 OK[\r][\n]

Server: Apache-Coyote/1.1[\r][\n]

Accept-Charset: big5, big5-hkscs, euc-jp, euc-kr...[\r][\n]

Content-Type: text/html;charset=UTF-8[\r][\n]

Content-Length: 7[\r][\n]

Date: Mon, 30 Jun 2014 01:28:19 GMT[\r][\n]

[\r][\n]

SUCCESS
```
* 추가적으로 header와 header를 구분하는 것은 개행 문자이다.
* header와 body를 구분하는 것은 개행문자 2개이다.
* body에 포함되어있는 file data를 구분하는 것은 boundary이다.
> (개행)바운더리문자열(개행)을 기준으로 구분하게 된다. 또 이 때의 개행은 플랫폼에 상관없이 CRLF로 \r\n을 사용해야 한다.

**[비동기 메소드 테스트 하기]**

* 비동기 메서드는 파생된 스레드에서의 작업을 기다리지 않고 바로 끝나기 때문에, 일반적인 방법으로는 정상적인 테스트가 불가능하다.
* 따라서 파생된 스레드에서의 작업을 기다리게 하는 방법을 알아보자.
    * 세가지 테스트 메소드를 통해 해결해줄 수 있다.
* `expectation(description:)`
    * 어떤 것이 수행되어야 하는지 문자열로 정해준다.
* `fulfill()`
    * 정의해둔 expectation이 충족되는 시점에 호출하여 동작을 수행했음을 알린다.
* `wait(for:timeout:)`
    * expectation을 배열로 담아 전달하여 배열 속의 expectation이 모두 `fulfuill`될 때 까지 기다린다. timeout을 설정하여 시간을 제한할 수 있다.
    * 비동기 작업을 기다리는 제한 시간 같은건데, 만약 비동기 메서드가 끝없이 동작하고 있다면 테스트가 진행되지 않을 것이다.
```swift
// 공식문서의 비동기 메소드 테스트 예제코드
func testDownloadWebData() {
    
    // Create an expectation for a background download task.
    let expectation = XCTestExpectation(description: "Download apple.com home page")
    
    // Create a URL for a web page to be downloaded.
    let url = URL(string: "https://apple.com")!
    
    // Create a background task to download the web page.
    let dataTask = URLSession.shared.dataTask(with: url) { (data, _, _) in
        
        // Make sure we downloaded some data.
        XCTAssertNotNil(data, "No data was downloaded.")
        
        // Fulfill the expectation to indicate that the background task has finished successfully.
        expectation.fulfill()
        
    }
    
    // Start the download task.
    dataTask.resume()
    
    // Wait until the expectation is fulfilled, with a timeout of 10 seconds.
    wait(for: [expectation], timeout: 10.0)
}
```

---

**[의존성 주입]**

* 의존성이란?
    * 어떤 객체가 내부에서 생성하여 가지고 있는 객체를 의존성이라고 한다.
* 의존성 주입이란?
    * 말 그대로 의존성을 주입시킨다는 뜻. 내부에서 초기화가 이루어지는 것이 아니라 외부에서 객체를 생성하여 내부에 주입해주는 것을 뜻한다.
* 의존성 주입을 왜 사용하지?
    * 객체간의 결합도를 낮추기 위함이다. 객체 간의 결합도가 낮으면 리팩토링이 쉽고 테스트 코드 작성이 쉬워진다는 장점이 있다.
    * 코드 재사용이 용이하다. 공통적인 로직은 한번만 구현하고 필요한 정보 혹은 기능만 끼워넣어서 커스터마이징이 가능하기 때문에 여러곳에서 재사용이 가능하다.
    * 객체의 책임을 명확히 알 수 있다.

---

**[Test Doubles]**

* Dummy
    * 객체는 전달되지만 사용되지 않는 객체
    * 예를 들면 함수 파라미터에 전달되는 빈 객체등이 있다.
* Fake
    * 동작하는 구현을 가지고 있지만 실제 프로덕션에는 적합하지 않은 객체
    * 단순화 된 버전의 동작을 제공하기도 한다.
    * 예를 들어 [인메모리 데이터 베이스](https://martinfowler.com/bliki/InMemoryTestDatabase.html)가 있다.
    * 
* Stub
    * 테스트에서 호출된 요청에 대해 미리 준비해둔 결과를 제공한다.
    * 테스트를 위해 프로그래밍 된 내용 이외에는 응답하지 않는다.
    * 주로 사용되는 경우
        * 구현이 되지 않은 함수나, 라이브러리에서 제공하는 함수를 사용하고자 할 때
        * 함수가 반환하는 값을 임의로 생성하고 싶을 때
        * 복잡한 논리 흐름을 가지는 경우 테스트를 단순화 하고 싶을 때
        * 의존성을 가지는 유닛의 응답을 모사하여 독립적인 시험 수행을 하고자 할 때
    * 얻는 이점
        * 의존하는 것에 대하여 독립적으로 개발과 테스트가 가능해진다.
            * interface만 존재하는 것을 stub으로 개발하고 테스트할 수 있다.
        * 촘촘한 테스트가 가능해진다.
            * stub으로 다양한 응답결과 케이스를 만들어 테스트할 수 있다.
* Spy
    * Stub의 역할을 가지면서 호출된 내용에 대해 약간의 정보를 기록한다.
    * 테스트에서 확인하기 위한 정보이다.
    * 예를 들면 메일링 서비스에서 발송된 메일의 갯수를 기록
    * 함수가 얼마나 많이 호출되었는지, 어떤 인수가 전달되었는지 확인
* Mock
    * 호출에 대한 기대를 명세하고 해당 내용에 따라 동작하도록 프로그래밍 된 객체
    * 테스트 작성을 위한 환경 구축이 어려울 때
        * 환경 구축을 위한 작업 시간이 많이 필요한 경우 Mock 객체를 사용
        * 특정 모듈을 아직 갖고 있지 않아서 테스트 환경을 구축하지 못할 경우
        * 타 부서와의 협의나 정책이 필요한 경우에도 Mock이 필요
        * 연계 모듈이라서 다른 쪽에서 승인을 해줘야 테스트가 가능한 경우, 방화벽으로 막혀 있어서 통과가 어려운 경우 등이 이에 속함
    * 테스트가 특정 경우나 순간에 의존적일 때
    * 테스트 시간이 오래 걸리는 경우
> 일반적인 테스트 더블은 상태를 기반으로 테스트 케이스를 작성한다.
> Mock 객체는 행위를 기반으로 테스트 케이스를 작성한다.

---

- 참고링크
    - https://www.donnywals.com/uploading-images-and-forms-to-a-server-using-urlsession/
    - https://soooprmx.com/multipart-form-data-%ed%83%80%ec%9e%85%ec%9d%98-http-%eb%a9%94%ec%8b%9c%ec%a7%80-%ea%b5%ac%ec%84%b1-%eb%b0%a9%eb%b2%95/
    - https://lena-chamna.netlify.app/post/http_multipart_form-data/
    - https://www.iana.org/assignments/media-types/media-types.xhtml#multipart
    - https://lena-chamna.netlify.app/post/uploading_array_of_images_using_multipart_form-data_in_swift/
    - https://developer.apple.com/documentation/xctest/asynchronous_tests_and_expectations/testing_asynchronous_operations_with_expectations
    - https://wody.tistory.com/10
    - https://dongminyoon.tistory.com/55
    - https://velog.io/@leeyoungwoozz/Test-Doubles
    - https://hyunsikwon.github.io/swift/Swift-DI-01/
    - https://wody.tistory.com/16
    - https://zeddios.tistory.com/1103
