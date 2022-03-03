# 220303 Clean Architecture MVVM, async, await

# TIL (Today I Learned)p
3월 3일 (목)

## 학습 내용

- 오늘은 하루종일 ViewModel 설계 삽질했다ㅎㅎ
- 비비 특강
    - `Concurrency await async actor`

&nbsp;

## 고민한 점 / 해결 방법

**[Clean architecture MVVM]**

Rx로 ViewModel 구현해보겠다고 설치다가 결국엔 다 지웠다.
일단 Rx없이 ViewModel을 구현하고 이후 리팩토링을 해야겠다...
다 지우고 클린 아키텍처라도 적용해보자고 맘먹고 ViewModel을 짜보았다.
(근데 시간이 될까..?)

### Presentation
* View 
* ViewModel: UI 이벤트가 발생하면 어떤 이벤트인지 판단 후 UseCase를 요청한 후 View에 업데이트를 하라고 알려줌

### Domain
* UseCase: 비즈니스 로직
    * Repository : 도메인과 데이터의 인터페이스 역할
### Data
* Storage : 데이터 입출력이 실행되는 곳
    * 영구 저장소, 네트워크 등...

### 데이터 흐름
* View는 ViewModel의 메소드를 호출
* ViewModel에서 어떤 이벤트인지 판단한다.
* 이벤트에 따라 UseCase를 실행
* UseCase는 User와 Repository를 결합
* 각 Repository는 네트워크, DB관련 스토리지, 메모리 관련 Storage에서 데이터 반환
* 다시 UI에 업데이트
    * Storage -> Repository -> UseCase -> ViewModel -> View

![](https://i.imgur.com/aDHA7m0.png)

![](https://i.imgur.com/9VG3JyK.png)

> 나도 한번 따라 만들어봤는데, 뭔가 기능이 중첩되는 느낌.... 아직 메모리 스토리지라 그런건가.... 파이어베이스나 코어데이터 생기면 그럴싸해질까...?

![](https://i.imgur.com/5S1tmWk.png)


---

**[Concurrency await async actor]**

### 동기 프로그래밍이란?
* 프로그램의 흐름과 이벤트의 발생 및 처리를 종속적으로 수행하는 방법
* sync programming
![](https://i.imgur.com/48YkDHs.png)

### 비동기 프로그래밍이란?
* 프로그램의 흐름과 이벤트의 발생 및 처리를 독립적으로 수행하는 방법
* async Programming
![](https://i.imgur.com/pIUIBPx.png)

```
* 비동기 프로그래밍
    * 프로그램의 흐름과 이벤트의 발생 및 처리를 독립적으로 수행하는 방법
    
* 동시성 프로그래밍
    * 여러 작업이 논리적인 관점에서 동시에 수행되는 것
    싱글 코어 또는 멀티 코어에서 멀티 스레딩을 하기 위해 적용
    
* 병렬성 프로그래밍
    * 여러 작업이 물리적인 관점에서 동시에 수행되는 것
```

---

### 기존의 동시성 프로그래밍의 문제
* 과도한 중첩 (a.k.a. 장풍 코드)
* 오류 처리의 어려움

![](https://i.imgur.com/plURgxQ.png)

![](https://i.imgur.com/eAvZzw0.png)

* 조건부 실행의 어려움

![](https://i.imgur.com/dk0bU16.png)

* swizzle
    * 런타임 시점에 조건에 따라서 다른 메소드로 바꿔서 실행한다.

함수의 실행 흐름이 자연스럽지 못하다.

* 실수하기 쉽다.

![](https://i.imgur.com/pWIZUTz.jpg)

* 하지만 async await을 사용하면 동기코드처럼 작성할 수 있다.

![](https://i.imgur.com/wv4cHt2.png)


* 간단히 살펴보는 문법

![](https://i.imgur.com/zTK5oQB.png)

* get만 가능!

![](https://i.imgur.com/PSYJDZ7.png)

---

### 동작 흐름

* async는 함수를 suspend 시킬 수 있다.
* await 키워드를 만나면 스레드 block을 해제하고 suspend 된다.
    * 즉 await 키워드가 suspend를 시키는 지점
* suspend 된 함수가 있을 때, 다른 작업은 진행될 수 있다.
    * 즉 비동기적으로 작업을 할 수 있다.

> 스레드 block을 해제하고 suspend 된다. -> 함수가 스레드에 대한 제어권을 포기한다.

* 이 개념은 코루틴(Coroutine)에서 출발했는데...
	Swift의 async/await은 코루틴 모델을 적용했다.

### 코루틴(Coroutine)이란?

* 루틴(소프트웨어에서 특정 동작을 수행하는 일정 코드 부분)의 일종
* 두 개 이상의 루틴이 서로를 호출하는 관계
    * 서브 루틴을 구분할 수 없다.
* A를 프로그래밍할 때는 B를 A의 서브루틴으로 생각 (반대도 성립)
* 실행되는 코루틴은 이전에 자신의 실행이 마지막으로 중단되었던 지점 다음의 장소에서 실행을 재개
    * 이게 가장 중요한 부분.
    * 중간에 suspend되었다가 다시 실행될 수 있다.

![](https://i.imgur.com/K61HYy5.png)

* 동기함수는 스레드의 제어권이 계속 남아있다.

![](https://i.imgur.com/QpHUXCp.png)

* await키워드를 만나면 스레드에 대한 제어권을 포기한다고 했다.
* 즉 스레드에 대한 제어권을 System에게 맡긴다.
* 그리고 작업이 완료되었다면 resume을 통해서 다시 돌아와서, 처음 suspend된 시점부터 시작되어 돌아간다.
* async 함수가 호출된 쓰레드가 메인이라면 await 이후에도 메인쓰레드에서 실행된다.
* async 프로퍼티도 가능!

---

[느낀 점]

* 비동기 코드가 동기 코드처럼 반환값을 가질 수 있게되었다.
* 이전엔 DispatchQueue로 global 스레드에 작업을 보내서 처리해준 부분이 await 키워드만 있으면, await 시점부터는 system이 알아서 스레드 관리를 해주는 느낌이다.
* 하지만.. 나온지 얼마안되서 아직은 개인 프로젝트에서만 활용할 수 있을 것 같다.
* 그리고 wwdc 영상을 꼭 보아라...

![](https://i.imgur.com/Lvu06kh.png)


---

- 참고링크
    - https://ios-development.tistory.com/555?category=978961
    - https://tech.olx.com/clean-architecture-and-mvvm-on-ios-c9d167d9f5b3
    - https://github.com/iamchiwon/whatisarchitecture
    - https://github.com/kudoleh/iOS-Clean-Architecture-MVVM
