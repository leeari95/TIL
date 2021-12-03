# TIL (Today I Learned)

10월 15일 (금)

## 학습 내용
오늘은 어제 디버깅을 하면서 알게된 키워드에 대해서 공부해보기로 하였다. 키워드를 얻어서 검색만 해보았는데 생각보다 많은 양의 정보가 쏟아졌다. 또한 앞으로 개발하는데 있어서 중요한 지식이라고 기재되어있는 곳들이 많았다. (보통 면접 준비로...) 아직은 내가 이해하기엔 어려운 내용이라고 느껴지기도 했고, 질문방에가서 의논해보니 나중에 배울 내용이라고 생각되어 오늘은 그냥 어떤 개념인지만 숙지하고 넘어가기로 하였다. 이후 서포터즈인 `Steven`과 크루 `Summer`와 함께 이야기를 나누면서 뭘배우면 좋을까 의논하다가 지금은 디버깅을 어떻게 하는지만 배워도 충분하다고 조언을 들어서 강의를 추천받아 보기 시작했다!
&nbsp;

## 문제점 / 고민한 점
- Thread... serial queue... async sync..이게 다 뭐야!!!!!!
- GCD는 또 뭐야...? 모르는 용어는 다 찾아보자.
- 모르는걸 찾다보니 공부할 내용이 너무 많네.. 이걸 다 지금 공부하는게 맞는걸까?
- 디버깅을 잘하는 간지나는 개발자가 되고싶다.

    
&nbsp;

## 해결방법
- 공부하다가 이걸 다 이해하기에 지금은 역부족이라고 느꼈고, 서포터즈인 `Steven`과 크루 `Summer`가 계셔서 바로 들어가서 물어보았더니 해결이 되었다.
    - **받았던 답변**
 GCD, Dispath Queue 등등 아직은 배울 내용이 아니다. 디버깅 하는 법만 간단히 배워도 충분하다.
    - 디버깅 잘하는 간지나는 개발자가 되고 싶다고 했더니, 간지나는 개발자가 되려면 마우스 없이 키보드로만 개발할 수 있는 방법이 있다면서 나중에 `vim`에 대해서 알아보라고 조언을 주셨다. 꿀팁 굿...ㅋ 나중에 배워서 꼭 써먹어봐야지.
    

&nbsp;

## 공부내용 정리
<details>
<summary>LLDB</summary>
<div markdown="1">

LLDB가 무엇인지 알기 위해서는 먼저 LLVM에 대한 간단한 이해를 하는 것이 좋다.

### LLVM
Apple에서 진행한 Compiler에 필요한 Toolchain 개발 프로젝트

### 특징
컴포넌트들의 재사용성을 중시해서 모듈화가 잘 되어있다.

### 서브 프로젝트
모듈화 되어있는 컴포넌트들을 이용해 진행된 프로젝트로 LLVM Core, Clang, libc++, LLDB 등이 있다.

## LLDB
LLVM의 Debugger Component를 개발하는 서브 프로젝트다. LLVM 프로젝트를 통해 개발된 Clang Expression Parser, LLVM Diassembler 등 Low-Level 컨트롤이 가능한 모듈들로 이루어져 있어, 기계어에 가까운 영역까지 디버깅 가능하다는 장점이 있다. C, C++, Objective-C, Swift를 지원하며 현재 Xcode의 기본 디버거로 내장되어 있다. LLDB와 함께라면 실제 프로그램이 어떤 식으로 동작하는지 더 깊이 이해할 수 있다.

Xcode IDE에서 LLDB 콘솔은 실행중인 프로젝트의 프로세스가 Breakpoint에서 멈추거나, pause 버튼을 통해 실행이 일시정지 되면 Xcode 화면 하단 Debug 콘솔에 나타난다.
￼


### LLDB 명령어 기초 문법

`(lldb) command [subcommand] -option "this is argument"`

Command, Subcommand, Option, Argument들로 이루어져 있고, 띄어쓰기로 구분한다.

- Command와 Subcommand는 LLDB 내 Object의 이름이다. (Etc, breakpoint, watchpoint, set, list … ) 이들은 모두 계층화 되어있어 Command에 따라 사용가능한 Subcommand 종류가 다르다.
- Option의 경우 Command 뒤 어느 곳에든 위치 가능하며, `-`(hyphen)으로 시작한다.
- Argument에 공백이 포함되는 경우도 있기 때문에 “”로 묶어줄 수 있다.

`(lldb) breakpoint set --file test.c --line 12`

breakpoint (Command)와 set (Subcommand)을 이용하며
--file option을 통해 test.c 파일 내
--line option을 통해 12번째 라인에
중단점을 set 해준다.

LLDB에는 수많은 명령어와 해당하는 Subcommand, Option들이 존재한다. 기억이 가물가물 하거나 필요한 기능이 있는지 확인할 때는 도움 받을만한 Command를 유용하게 사용할 수 있다.

### Help
해당 문법으로 사용가능한 Subcommand, Option 리스트나 사용법을 보여주는 명령어

### LLDB에서 제공하는 Command가 궁금하다면,
`(lldb) help`

### 특정 Command의 Subcommand나, Option이 궁금하다면,
`(lldb) help breakpoint`
`(lldb) help breakpoint set`

### Apropos
원하는 기능의 명령어가 있는지 관련 키워드를 통해 알아볼 수 있는 명령어

### **referent count를 체크**할 수 있는 명령어가 있을까? 궁금하다면,
`(lldb) apropos "refernce count"`
- 결과
The following commands may relate to 'reference count':
refcount -- Inspect the reference count data for a Swift object


# Breakpoint 다루는 방법

### Breakpoint를 만드는 기본적인 명령어 구조
`(lldb) breakpoint set [option] “arguments”`

줄여서는,
`(lldb) br s [option] “arguments”`

* 대부분의 명령어와 옵션들은 command 맨 앞 1~2개 알파벳으로 줄여서 사용할 수 있다.

### Function Name
특정 이름을 가진 모든 함수에 -name (-n) option을 이용해 break를 걸 수 있다.
`(lldb) breakpoint —name viewDidLoad`
`(lldb) b -n viewDidLoad` // 줄여서 사용.

또한 -func-regex (-r) option을 이용해 정규표현식을 활용할 수도 있다.
`(lldb) breakpoint set —func-regex ‘^hello’`
`(lldb) br s -r ‘^hello’`
- `breakpoint set —func-regex` 는 줄여서 `rb`로도 사용 가능
`(lldb) rb ‘^hello’`

### File
파일의 이름과 line 번호를 이용해 break를 걸기 위해서는 -file (`-f`), -line (`-n`) option을 이용할 수 있다.

### 특정 파일의 20번째 line에서 break
`(lldb) br s. -file viewController.swift —line 20`
`(lldb) br s -f ViewController.swift -l 20`

* Breakpoint에 멈춰있는 프로세스의 실행 지점을 변경할 수 있다. 멈춰있는 breakpoint line의 우측에 `녹색 햄버거 버튼`을 위 아래로 잡고 드래그하면 다음 실행 지점을 변경할 수 있다.

### Condition
-condition (`-c`) option을 이용하면 breakpoint에서 원하는 조건을 걸 수도 있다. -c option 뒤의 expression이 `true인 경우`에만 breakpoint에서 멈춥니다.

### viewWillAppear 호출시, animated가 true인 경우에만 
`lldb) breakpoint set —name “viewWillAppear” —condition animated`
`(lldb) br s -n “viewWillAppear” -c animated`

### Command 실행 & AutoContinue
-command (-C) option을 이용하면 `break시 원하는 lldb command를 실행`할 수 있다.

`(lldb) breakpoint set -n “viewDidLoad” —command “po &arg1 -G1”`
`(lldb) br s -n “viewDidLoad” -C “po $arg1” -G1`

-auto-continue (-G) option의 기능은 auto continue로, command 실행 후 `break에 걸린 채로 있지 않고 프로그램을 자동 진행`하게 해준다.

`(lldb) regex-brea`는 간단하게 Breakpoint 생성을 할 수 있도록 도와주는 Shorthand Command이다. `(lldb) b`로 줄여서 사용할 수 있다.

### 사용방법
* 특정 이름을 가진 function에서 break
`(lldb) b viewDidLoad`
* 현재 파일 20번째 line에서 break
`(lldb) b 20`
* 특정 파일 20번째 line에서 break
`(lldb) b ViewController.swift:12`
* 현재 파일 내 특정 text를 포함한 line에서 break
`(lldb) b /stop here/`
* 특정 주소값에서 break
`(lldb) b 0x1234000  `

### Breakpoint 리스트 확인하기
`(lldb) breakpoint list command`를 통해 현재 프로그램에 생성되어있는 `Breakpoint의 목록`을 확인할 수 있다. 또한 이 목록 정보에는 Breakpoint의 id와 이름 hit-count 정보, enable 여부, source 상의 위치, 주소값 등등 유용한 정보가 포함되어 있다.

### hit-count란?
프로그램 실행 중 활성 상태인 Breakpoint 지점이 실행되면, Debugger는 hit count를 1씩 늘려가며 기록한다. 하지만 Breakpoint가 걸려있다 하더라도 **disable 상태**이면 count되지 않는다.

Breakpoint id를 통해 원하는 내용만 출력하거나, -brief (`-b`) option을 통해 간단한 내용을 확인해 볼 수도 있다.

### breakpoint 목록 전체 출력
`(lldb) breakpoint list`
`(lldb) br list`

### breakpoint 목록 간단하게 출력
`(lldb) br list -b`

### 특정 id를 가진 breapoint의 정보만 출력
`(lldb) br list 1`

## Breakpoint 삭제 또는 비활성화 시키기
Delete, disable, Subcommand를 이용해 Breakpoint를 삭제하거나, 비활성화 할 수 있다.

### breakpoint 전체 삭제
`(lldb) breakpoint delete`
`(lldb) br de`

### 특정 breakpoint 삭제
`(lldb) br de 1`

### breakpoint 전체 비활성화
`(lldb) breakpoint disable`
`(lldb) br di`

### 특정 breakpoint 비활성화
`(lldb) br di 1.1`

</div>
</details>
<details>
<summary>Thread는 뭐지?</summary>
<div markdown="1">

- Thread
스레드는 하나의 프로세스 내에서 실행되는 작업흐름의 단위를 말한다. 보통 한 프로세스는 하나의 스레드를 가지고 있지만 환경에 따라 둘 이상의 스레드를 동시에 실행할 수도 있다. 이러한 방식을 멀티스레딩이라고 한다. 프로그램 실행이 시작될 때부터 동작하는 스레드를 메인 스레드라고 하고 나중에 생성된 스레드를 서브 스레드 또는 세컨더리 스레드라고 한다.

- 프로세서
컴퓨터 내에서 프로그램을 수행하는 하드웨어 유닛으로 CPU(Central Processing Unit)가 여기에 속한다. 한 컴퓨터가 여러개의 프로세서를 갖는다면 멀티 프로세서라고 한다. (듀얼 프로세서 등)

- 코어
프로세서 내부의 주요 연산회로를 말한다. 싱글코어는 하나의 연산회로가 내장되어 있는 것이고 듀얼코어는 두 개의 연산회로가 내장된 것을 말한다.

- 프로그램과 프로세스
프로그램은 보조기억 장치에 저장된 실행코드를 말한다. 프로세스는 이 프로그램을 구동하여 실행코드와 그 상태가 실제 메모리상에서 실행되는 작업 단위를 말한다. 동시에 여러개의 프로세스를 운용하는 시분할 방식을 멀티태스킹이라고 한다. 이러한 프로세스 관리는 운영체제에서 담당한다.

- 비동기 프로그래밍
프로그램의 주 실행 흐름을 멈추어서 기다리지 않고 다음 작업을 실행할 수 있게 하는 방식이다. 코드의 실행 및 결과 처리를 별도의 공간에 맡겨둔 뒤 그 실행결과를 기다리지 않고 다음 코드를 실행하는 병렬처리 방식이다. 비동기 프로그래밍은 언어 및 프레임워크에서 지원하는 여러 방법으로 구현할 수 있다.

- 동시성 프로그래밍
논리적인 용어로 동시에 실행되는 것처럼 보이는 방식이다. 싱글 코어에서 멀티스레드를 동작시키기 위한 방식으로 멀티 태스킹을 위해 여러 개의 스레드가 번갈아 가면서 실행되는 방식이다.

- 병렬성 프로그래밍
물리적으로 정확히 동시에 실행되는 것을 말한다. 멀티 코어에서 멀티 스레드를 동작시키는 방식으로 데이터 병렬성(Data Parallenlism)과 작업 병렬성(Task Parallelism)으로 구분된다.
`데이터 병렬성` 전체 데이터를 나누어 서브 데이터들로 만든 뒤, 서브 데이터들을 병렬 처리해서 작업을 빠르게 수행하는 방법이다.
`작업 병렬성` 서로 다른 작업을 병렬 처리하는 것을 말한다.

- 동시성과 병렬성의 차이
동시성 프로그래밍과 병렬성 프로그래밍 모두 비동기 동작을 구현할 수 있지만 동작 원리가 다르다.
예를 들어 꼬치 가게에서 꼬치를 사려고 기다리고 있다고 생각해보자. 꼬치 가게 판매 직원이 2명이여서 사람들은 줄을 2줄로 섰다. 그래서  판매직원 한명이 한줄을 담당해서 N:N으로 업무처리를 진행하는 게 된다. 이게 병렬성이다. 병렬성은 물리적으로 동시에 여러작업을 처리할 수 있다. 판매직원이 하나의 코어가 되고, 줄이 처리해야하는 데이터나 작업인 것이다. 이 병렬성을 구현하기 위해서는 멀티 코어 환경이 필요하다.
그렇다면 이 상황에서 판매직원 하나가 급하게 자리를 비운다면 어떻게 될까? 한 줄만 계속해서 판매된다면 다른 줄의 사람들의 원성을 사게 될 것이다. 그래서 한명의 판매직원이 두줄의 손님을 번갈아가면서 판매한다. 논리적으로는 하나의 코어가 여러줄을 작업을 동시에 처리하는 것처럼 보이지만 물리적으로 동시에 처리하는 것은 아니다.

- iOS 환경에서의 동시성 프로그래밍 지원 종류
`GCD (Grand Central Dispatch)` 멀티 코어와 멀티 프로세싱 환경에서 최적화된 프로그래밍을 할 수 있도록 애플이 개발한 기술이다.
`Operation Queue` 비동기적으로 실행되어야 하는 작업을 객체 지향적인 방법으로 사용한다


</div>
<details>
<summary>Serial Queue가 뭐야?</summary>
<div markdown="1">

### Serial vs Concurrent
### 직렬처리 vs 병렬처리

Serial인 경우 직렬이기때문에 앞에 작업이 있고 그 뒤에 작업이 있다면 앞의 작업이 끝나기 전까지는 뒤에 작업을 실행하지 않는다. 반대로 Concurrent인 경우는 병렬이기때문에 여러가지 작업을 동시에 실행할 수 있다. 즉, 조금이라도 먼저온 작업 순으로 바로바로 처리해줄 수 있다.

### Async vs Sync
### 비동기 vs 동기

Async는 비동기다. 비동기란 내가 작업을 맡기고 실행되는 동안에 나는 또 다른 일을 할 수 있는 것을 뜻한다. 예를 들어 커피를 주문하고 기다리는 동안 아무것도 못하는게 아니라 다른일을 할 수 있는 그런 느낌이다. 반대로 Sync는 해당 작업이 끝날 때까지 기다려야 한다.

Serial과 Concurrent는 `Thread 수와 관련이 있는 개념`이고,
Async와 Sync는 `Thread 위에서의 흐름을 나타내는 개념`이라고 생각하면 될 것 같다.

그리고 Cocoa Aplication에서는 2개의 Queue를 지원한다.
- Main
    - Serial queue
    - 반드시 UI 관련 작업(task)은 이곳에서 실행
- Global
    - Concurrent queue (global dispatch queue)
    - 동시에 하나 이상의 작업(task)을 실행
    - 큐에 추가된 순서대로 시작한다.


</div>
</details>

---

- 참고링크
    - [LLDB에 대한 강의](https://yagom.net/courses/start-lldb/)
    - [GCd vs Operation Queue](https://caution-dev.github.io/ios/2019/03/15/iOS-GCD-vs-Operation-Queue.html)
