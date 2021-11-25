# TIL (Today I Learned)


11월 25일 (목)

## 학습 내용
- 계산기 프로젝트의 의문점
    - 아니 왜 SE 디바이스만 버튼 frame 값이 변경되는거지?
    - OSLog에서 사용하는 StaticString은 뭐하는 애지?
- 왜 fork해온 레파지토리는 잔디가 안심어지니...?
&nbsp;

## 고민한 점 / 해결 방법
- ![](https://i.imgur.com/MiyseWl.png)
- 3기 캠퍼 갓`수박`덕분에 해당 의문점을 해결할 수 있었다.
- HIG에서 장치들의 치수를 확인해서 세로를 보면 200~300정도 차이가 나는 것을 확인할 수 있다.
- 사진에서도 볼 수 있듯이 세로 크기가 엄청 차이난다.
- 따라서 작아진 디바이스에 오토 레이아웃을 충족하기 위해 버튼의 크기를 줄일 수 밖에 없다는 추측이 가능해졌다.
- 이러한 사실을 증명해낼 수도 있다. 직접 레이아웃을 다 계산하여 치수와 맞는지 확인할 수도 있지만... 나중에 시도해봐야겠다. 😇
    - ### 답변받은 와중에 받았던 꿀팁
    - didSet으로 UI 요소들의 레이아웃을 잡아주는건 부자연스럽다. 오히려 지금처럼 view가 배치된 후 레이아웃을 잡아준 것이 자연스럽고 좋은 방법이다.
    - 그리고 UI 인스턴스를 생성할때 클로저로 선언하는 방법이 있고, 인스턴스로 선언 이후 값을 변경해줄 수도 있다. 
    - 선언 이후 값을 변경해주는 방법은 문맥상 부자연스러울 수 있으므로 지양하는게 좋은 것 같다는 의견.
        - let으로 선언후 값을 변경해주는 거니까 부자연스럽다는 늬앙스!
        - 애초에 클로저로 선언하여 요소의 속성들을 설정해주고 그대로 쭉 사용하는게 더 자연스럽다!
- ### 버튼을 원형으로 만들어보면서 얻어낸 결론 정리
    - 하위뷰 레이아웃은 viewDidLoad 이후 viewWillLayoutSubviews에서 하위뷰가 배치되면서 잡히게 된다.
    - 오토 레이아웃은 다양한 디바이스의 적절한 화면을 보여주기 위한 기능이다.
    - 디바이스 화면의 크기에 따라 frame은 일정하지 않을 수도 있다.

---

- ### StaticString이란?
    - String은 원래 바이너리에 있는 원래 문자열의 메모리 주소를 알고 그 주위에 전체 데이터 구조를 구축하지만 StaticString은 해당 주소를 저장한다.
    - 따라서 문자열을 `절대 수정하고 싶지않고 고정하고 싶을 때` 활용하는 타입이다.
    - 예제를 통해 이해해보자
    ```swift
    var myNumber = 10
    let myString = "My number is \(myNumber)"

    print(myString)
    myNumber = 20
    print(myString)
    ```
    - 기존에 String을 사용하면 문자열 보간법을 통해 런타임 때 문자열에 정보를 추가할 수 있다.
    - 따라서 위 코드의 결과는 아래와 같다.
    - ![](https://i.imgur.com/gbJAMKo.png)
    - myNumber를 변경하더라도 텍스트는 변경되지 않는 것을 볼 수 있다. 문자열 보간법은 값을 할당하는 순간의 값만 고려하므로 나중에 값을 변경해도 동일한 결과가 나오는 것이다.
    - 그러나 문자열 보간법을 사용하면 문자열의 값을 컴파일 시점에는 값이 제대로 있는지 확인할 수가 없다.
    - 따라서 컴파일 시점에 문자열의 값을 알고싶다면 StaticString 타입을 사용한다.
    ```swift
    var myNumber = 10
    let myString : StaticString = "My number is \(myNumber)"

    print(myString)
    ```
    - 위 코드는 컴파일 에러가 난다.
    - ![](https://i.imgur.com/xz0Pn9n.png)
    - 그리고 다음과 같은 동작도 불가능하다.
    ```swift
    var myNumber = 10
    let myString : StaticString = "My number is " + "\(myNumber)"

    print(myString)
    ```
    - 이런식으로 컴파일 시점에 항상 완성된 문자열을 갖도록 개발을 강제할 수 있다.
    ```swift
    let myString : StaticString = "My number is "
    let myString2 : StaticString = "23"

    myString2 = myString + myString2
    ```
    - 위와 같이 문자열을 추가하는 것도 할 수 없다.

---

- ## fork해온 repository 잔디 적용방법
    - 잔디가 심어지는 조건
    >GitHub 계정과 commit 이메일 계정이 동일하거나
    >commit이 Fork한 repository가 아닌 나만의 repository에서 이루어져야 한다.
    - 즉, commit이 fork한 repository에서 commit이 이루어졌기 때문에 잔디가 심어지지 않았던 것이다.
- ### 해결법 👉🏻 fork해온 repository를 새 레파지토리로 복사해오자.
    1. 일단 내 Github에 새 repository를 생성한다
    2. 복사하고 싶은 forked repository 주소를 copy한다.
    3. terminal을 열고 copy한 forked repository를 bare clone한다.
        > `git clone --bare <fork했던 레파지토리 주소>`

    4. cd로 방금 clone한 레파지토리 폴더로 진입
        > `cd <fork했던 레파지토리 폴더>`
    5. 맨처음 생성했던 새로운 레파지토리로 Mirror-push
        > `git push --mirror <생성했던 레파지토리 주소>`
    6. default 브랜치를 내 브랜치로 설정해주면 끝
- ### 주의
    - 복사해서 만든 레파지토리는 잔디는 심어지지만 `PR은 보낼 수 없다.` 프로젝트를 마무리한 후에 하면 좋을 것 같다.
- 나는 그래서 잔디용 레파지토리라 생각하고 fork 레파지토리를 새 레파지토리에 복제해온 다음 새 레파지토리를 private으로 바꿔버렸다.
- ![](https://i.imgur.com/m6b8qtk.png)
- 그리고 private 레파지토리도 커밋 반영되도록 설정해주었다. 깔끔!
- ![](https://i.imgur.com/ItSTgAB.png)
- 별건 아니고... 잔디 쬐금 심었다.. 뿌듯...
- ![](https://i.imgur.com/HJfkqvK.png)




&nbsp;

## 느낀점
* 역시 의문점들은 그냥 지나치지 않고 계속 파보면 깊이 학습하는데 있어서 많은 도움이 되는 것 같다.
* 그래도 의문점이 풀릴 수준 까지만 파야겠다. 그 이상은....😇

---

- 참고링크
    - https://developer.apple.com/design/human-interface-guidelines/ios/visual-design/adaptivity-and-layout/
    - https://developer.apple.com/documentation/swift/staticstring
    - https://stackoverflow.com/questions/32247387/difference-between-string-and-staticstring
    - https://holyswift.app/why-and-when-to-use-the-swifts-staticstring-struct?x-host=holyswift.app
    - https://velog.io/@whoyoung90/fork-%ED%95%B4%EC%98%A8-repository-%EC%9E%94%EB%94%94-%EC%8B%AC%EB%8A%94-%EB%B0%A9%EB%B2%95
