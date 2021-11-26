# TIL (Today I Learned)


11월 26일 (금)

## 학습 내용
- App Life Cycle 활동학습
- CFGetRetainCount
- 2기, 3기 선배분들과 이야기
&nbsp;

## 고민한 점 / 해결 방법
- ### iOS 13에서 Scene Delegate로 이관된 App Delegate의 역할은 무엇무엇이 있을까?
    active, inactive, background, foreground 상태 관여한다.
    즉 UI Lifecycle에 대한 역할이 이관된 것으로 볼 수 있다.
    UI Lifecycle은 Application UI의 상태(state)를 알게 해준다.

---

- ### App Delegate와 Scene Delegate의 각각의 역할은 무엇일까?
    > App Delegate의 역할은 Process Lifecycle과 Session Lifecycle을 관리한다.

    * **Process Lifecycle?**
       프로세스의 상태 관여
    * **Session Lifecycle?**
       Scene Delegate에서 새로운 Scene Session이 생성되거나 이미 존재하는 Scene 버려질때 AppDelegate에 알려준다.

> Scene Delegate는 UI Lifecycle을 관리한다.

* **UI Lifecycle**
   active, inactive, background, foreground 상태에 관여한다.

---

- ### Scene의 개념이 생긴 이유는 무엇이고, 언제 어디서 활용해볼 수 있을까?
> 아래 그림처럼 하나의 앱이 하나의 process와 하나의 user interface 객체와만 matching되었던 iOS 12 이전까지는 괜찮았다.
![](https://i.imgur.com/eoD7lSy.png)
* 그러나 iOS 13 부터는 이전처럼 하나의 process를 사용하긴 하지만 다수의 UI 객체나 Scene Session들을 가지게 되면서 위와 같은 방식이 유효하지 않게 되었다.
![](https://i.imgur.com/sQ485Ez.png)

* iOS 12까지는 하나의 앱에 하나의 window, 즉 한 앱을 여러개 키는 것이 불가능 했다.
* iOS 13부터는 window의 개념이 Scene으로 대체되고 아래의 그림처럼 하나의 앱에서 여러개의 Scene을 가질 수 있게 되었다.
* 즉 하나의 앱을 여러개 켜는 것이 가능해졌다.
![](https://i.imgur.com/AdK6tJB.jpg)

---

- ### Life Cycle에서 Unattached, Suspended, Not Running의 메모리와 프로세스의 관점에서의 차이는 무엇일까?
> **Unattached**
   시스템이 connection notification을 주기전 까지는 이 상태를 유지한다.
   따라서 메모리를 점유하고 있고 실행중인 상태이다.
> **Suspended**
   Scene이 background 상태에 있으며 아무것도 실행되지 않는 상태를 의미한다.
   따라서 메모리는 점유하고 있지만 대기중인 상태라고 할 수 있다.
> **Not Running**
   아예 App이 실행되지 않았거나 실행이 되었지만 시스템에 의해서 종료된 상태이다.
   따라서 메모리에도 없고 프로세스의 관점에서도 아무것도 실행되지 않는다.

---

- ### App Life Cycle 모식도의 점선과 실선의 차이는 무엇일까?

![](https://i.imgur.com/laUoP7a.png)

>  **점선**
    특별한 event가 없어도 시스템이 자동으로 수행해주는 상태의 전환이라고 할 수 있다.
> **실선**
   사용자나 시스템에 의해 발생한 event로 인해서 발생하는 상태의 전환이라고 할 수 있다.
    
--- 

- CFGetRetainCount?
    - 참조 카운트를 확인할 때 사용하는 타입이다.
    - 파라미터를 보니 CFTypeRef 라는 타입을 받고있다.
    ```swift
    func CFGetRetainCount(_ cf: CFTypeRef!) -> CFIndex
    ```
    - 공식문서를 확인해보니 AnyObject를 typealias로 선언한 타입이였다.
    ```swift
    typealias CFTypeRef = AnyObject
    ```
    - 파라미터로 객체를 받고 간단히 그 객체에 대한 참조카운트를 반환해주는 타입으로 이해하면 될 것 같다.

---

- ### 깃모지?
    - 2기 캠퍼 [Fezz의 README](https://github.com/Fezravien/re-ios-open-market)를 구경하다가 발견했다.

![](https://i.imgur.com/3tuKs4C.png)



#### ✏️ Commit Message

기능 단위로 나눠 개발하는 과정의 커밋 메시지는 `깃 이모지`를 활용해서 가시성과 일관성을 높혔다. 


| Type     | Emoji | Description                                                  |
| :------- | :---: | :----------------------------------------------------------- |
| Feat     |   ✨   | 기능 (새로운 기능)                                           |
| Fix      |   🐛   | 버그 (버그 수정)                                             |
| Refactor |   ♻️   | 리팩토링 `기능 변경 없음`                                    |
| Style    |   🚚   | 파일 형식/네이밍, 폴더 구조/네이밍 수정하거나 옮기는 작업 `비즈니스 로직에 변경 없음` |
| Style    |   💄   | 스타일 (UI 스타일 변경)  `비즈니스 로직에 변경 없음`         |
| Docs     |   📝   | 문서 (문서 추가, 수정, 삭제)                                 |
| Test     |   ✅   | 테스트 (테스트 코드 추가, 수정, 삭제) `비즈니스 로직에 변경 없음` |
| Chore    |   🔧   | 기타 (빌드, 시스템 파일 및 설정 변경)                        |
| Comment  |   💡   | 필요한 주석 추가 및 변경                                     |
| Remove   |   🔥   | 파일, 폴더 삭제 작업                                         |

- 와.. 이거 너무 귀여운데? 나도 써먹어야지~~~ 하고 긁어왔다.
- 그리고 프로젝트를 살펴보니 브랜치를 기능단위로 나누셨다.
    - 나도 기능단위 브랜치 파보기 도전~~~!!!
---

## 느낀점
* 쉴땐 쉬고 공부할땐 예습학습복습 열심히 하자~
* 기록도 잊지말자
---

- 참고링크
    - https://hyerios.tistory.com/148
    - https://velog.io/@minni/iOS-Application-Life-Cycle
    - https://developer.apple.com/documentation/corefoundation/1521288-cfgetretaincount
    - https://developer.apple.com/documentation/corefoundation/cftyperef
    - https://ios-development.tistory.com/692
    - https://daheenallwhite.github.io/ios/interview/2020/07/16/Interview-Review/
