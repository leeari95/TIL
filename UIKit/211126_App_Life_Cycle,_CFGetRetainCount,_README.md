# 211126 App Life Cycle, CFGetRetainCount, README
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
&nbsp;

---

- 면접 질문은 1학기, 2학기에 공부했던 내용 위주로 나왔었다.
    - 딥하게 상세히 공부할 필요는 없다.
    - 대신 물어보면 대답할 정도의 지식은 가지고 있어야한다.
    - 질문에 답을 해보는 연습을 하면 좋을 것 같다.
        - 음.. 가볍게 하루에 하나씩 면접 질문에 답변을 달아보는 것도 괜찮을...????
- 네카라쿠배를 가려면 CS 기초지식이 탄탄해야한다.
    - 난 백지인데....쩝...
- 자신이 목표로 하는 회사를 목표삼아 공부 계획을 세워보면 좋다.
- 프로젝트 README는 면접관들이 보기 좋게 정리하는 것이 좋다.
    - 지금은 기록해두는 것만으로도 충분히 잘하고 있다.
    - 일단 기록하고 나중에 보는 사람이 편하도록 정리해두면 된다.
- 캠프가 끝난 후 2주동안 면접 준비를 해서 `경험이다` 생각하고 작은 회사들부터 면접을 보러 다닌다. 그리고 면접을 통해서 깨져보고 부족한 부분을 다시 채워가는 것이 좋다.
- **TIL이나** **README** 등 **기록하는 것**이 제일 중요하다.
- 커리어 캠프에서 배우는 것, 야곰이 주는 키워드 위주로 공부를 하면 된다.
    - 커리어 캠프는 장기간 레이스다. 남은 캠프기간동안 지치지 않도록 체력 보충을 위해 쉬는것도 중요하다.
- 점점 갈수록 힘들어지니 쉴땐 쉬어야 한다.
    - 엘렌: 저도 방학땐 공부를 했었는데... 지금 다시 방학이 온다고하면 쉴거 같습니다. ㅎㅎ
    - 샤피로: 저같은 경우에도 방학에 공부를 하긴 했는데.. 딥하게 한건 아니고 가볍게 부족했던 부분을 알아보는 시간을 가졌어요.
    - 3기 선배님들의 말씀중 캠프 막판에 아프신 분들이 많았다고 한다.
- 난 일단 놀고 시간이 남는다면 공부를 하던가 말던가... 방학인데 뭐 맘놓고 놀아야지 ㅎㅎ

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
    - 리드미만 구경해도 얻는 정보들이 많다는 것을 새삼 느낀다.
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
    - https://github.com/Fezravien/re-ios-open-market
