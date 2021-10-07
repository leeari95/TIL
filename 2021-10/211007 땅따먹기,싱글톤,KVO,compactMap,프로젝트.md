# TIL (Today I Learned)

10월 7일 (수)

## 학습 내용
오늘은 오전에 땅따먹기 게임을 해보았다. 두 단어를 한 문장으로 설명하면서 땅따먹는 룰이였는데, 익숙한 용어들이였지만 말로 설명하려니까 쉽지않았다. 머리로는 이해하고 있는 지식들이였지만 설명하려고 하니 좀처럼 입이 떨어지지가 않았다. 그래도 팀원들과 같이 설명해보면서 모르는 부분도 함께 토론해보며 평소에는 알고있지 않던 지식을 얻을 수 있었던 유익한 시간이였다. 이후 어제 진행하였던 팀 프로젝트를 수정한 뒤 STEP2를 진행하였다.
&nbsp;
## 문제점 / 고민한 점
- <code>싱글톤</code>, <code>KVO</code> 라는 용어는 처음보는 용어였는데, 팀원이 설명할 때 정확히 맞는 설명인건지 알고있는 지식이 아니라서 확신이 없었다.
- 내가 입으로 설명할 수 없으면 알고있는 지식이 아니라는 걸 새삼 깨달았다.
- 함수는 타입의 일종인걸까?
- 프로토콜은 일급 시민이였나?
- 프로젝트 진행 중에 <code>String 배열</code>을 <code>Int 배열</code>로 변환하는 과정에서 map을 사용하니 옵셔널 형태로 반환되어서 일반 정수배열로 반환할 수 없는지 고민하였다.
- 인수 레이블 이름 지정하는 것을 고민하였으나 파라미터가 많을 경우라 그런지 쉽지 않았었다.

&nbsp;
## 해결방법
- 구글링 해보면서 내가 이해하고 있는게 맞는지 팀원들에게 확인해보았는데, 다들 모르는 지식이였어서 다같이 찾아보면서 입으로 설명해보고 점차 이해를 넓혀갔다.
    - KVO : <code>Key-Value Observing</code>의 약자이다. 객체의 프로퍼티의 변경사항을 다른 객체에 알리기 위해 사용하는 코코아 프로그래밍 패턴이다. Model과 View와 같이 논리적으로 분리된 파크간의 변경사항을 전달하는데 유용하고 <code>NSObjec</code>를 상속한 클래스에서만 KVO를 사용할 수 있다.  
    - 싱글톤 : 특정 용도로 객체를 하나만 생성하여 공용으로 사용하고 싶을 때 사용하는 디자인 유형이다. init을 <code>private</code>로 접근제어하고 타입 내부에서 <code>static</code>을 이용하여 인스턴스를 저장할 프로퍼티를 생성한다. 여기서 인스턴스는 참조해야하기 때문에 <code>class</code>에서만 사용할 수 있는 패턴이다. 접근은 생성한 <code>static</code> 프로퍼티를 이용하면 된다. 아래는 싱글톤 패턴을 사용한 타입 FileManager의 사용법이다.
    ```swift
    // 파일매니저 인스턴스 생성
    let fileManager = FileManager.default 
    // 사용자의 문서 경로
    let documentPath: URL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    ```
- 앞으로 꼭 팀원에게 설명할 기회가 있다면 입으로 설명해보는 **설명충**이 되어야겠다.
- 함수는 이름이 없는 객체이다. 일급시민, 즉 값으로 다룰 수 있는 요소이기 때문에 타입과는 다르다는 것으로 결론이 났다. 타입은 이름이 있는 타입(<code>class, struct, enum, protocol 등</code>)이 있고, 이름이 없는 타입(<code>tuple, closure, func</code>)이 있다.
- 프로토콜은 일급시민에 해당되지 않는다. 프로토콜은 정의만 해줄 뿐, 프로퍼티에 기본값을 줄 수는 없다.
- compactMap이라는 고차함수를 사용해보았다. 공식문서를 보니 nil을 알아서 걸러주고 nil이 아닌 값들만 추려서 반환해준다고 설명이 되어있었다. 따라서 <code>nil</code>을 제거하고, 주어진 값을 <code>옵셔널 바인딩</code> 할때 유용하게 사용할 수 있을 것 같다.
- 함수 호출 시 한 문장으로 설명된다면 성공적인 인수레이블을 지을 수 있을 것 같다. Swift 기본 함수들의 인수 레이블을 참고하여 한 문장으로 읽히도록 노력해봐야겠다.
&nbsp;

---

- 참고링크
    - [Swift Type](https://docs.swift.org/swift-book/ReferenceManual/Types.html)
    - [KVO란 무엇인가?](https://zeddios.tistory.com/1220)
    - [싱글톤 패턴에 대하여...](https://babbab2.tistory.com/66)
    - [compactMap](https://developer.apple.com/documentation/swift/sequence/2950916-compactmap)
