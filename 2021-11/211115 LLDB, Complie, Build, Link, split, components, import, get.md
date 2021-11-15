# TIL (Today I Learned)


11월 15일 (월)

## 학습 내용
- LLDB 활동학습
- 디버깅 직접 해보기
- STEP 2 피드백 확인하며 고민해보기

&nbsp;

## 고민한 점 / 해결 방법
### 컴파일(Complie)이란?
개발자가 작성한 소스코드를 바이너리 코드로 변환하는 과정
즉, 컴퓨터가 이해할 수 있는 기계어로 변환하는 작업이다.
### 빌드(Build)란?
소스코드 파일을 실행가능한 소프트웨어 산출물로 만드는 일련의 과정을 말한다.
빌드의 단계 중 컴파일이 포함되어 있는데 컴파일은 빌드의 부분집합이라 할 수 있다. 빌드과정을 도와주는 도구는 빌드 툴이라 한다.

### 링크(Link)란?
프로젝트를 진행하다보면 소스파일이 여러개가 생성이 되고 A라는 소스파일에서 B라는 소스파일에 존재하는 함수를 호출하는 경우가 있다. 이 때 A와 B 소스파일 각각 컴파일만 하면 A가 B에 존재하는 함수를 찾질 못하기 때문에 호출할 수가 없다.
따라서 A와 B를 연결해주는 작업이 필요한데 이 작업을 링크라고 한다.
여러개로 분리된 소스파일들을 컴파일한 결과물들에서 최종 실행가능한 파일을 만들기 위해 필요한 부분을 찾아서 연결해주는 작업이다.

### 빌드 툴(Build tool)
일반적으로 빌드 툴이 제공해주는 기능으로는 다음과 같은 기능들이 있다.
전처리(Preprocess) > 컴파일(Complie) > 링크(Link)
패키징(packaging), 테스팅(testing), 배포(distribution) 등..
빌드 툴로는 Ant, Maven, Gradle 등이 있다.

## 기계어 번역 방식에 따른 프로그래밍 언어의 분류

### 컴파일 언어
구현체들이 일반적으로 컴파일러(소스코드로부터 기계어를 생성해내는 변환기)이면서 인터프리터(런타임 전 변환 과정을 거치지 않는 소스 코드의 단계별 실행기)가 아닌 프로그래밍 언어.
* C, C++, Go …

### 바이트코드 언어
특정 하드웨어가 아닌 가상 컴퓨터에서 돌아가는 실행 프로그램을 위한 이진 표현법

* Java, C# …

### 인터프리터 언어
프로그램 언어의 소스코드를 바로 실행하는 컴퓨터 프로그램 또는 환경을 말한다.
* BASIC, JavaScript, Python, Ruby …

### ViewController.swift 파일의 23번째 줄에 브레이크 포인트를 설정하려면 입력해야 하는 LLDB 명령어는?
* (lldb) breakpoint set -file viewController.swift --line 23
* (lldb) br s -file viewController.swift --line 23
* (lldb) b ViewController.swift:23
* (lldb) b 23

### Breakpoint Navigator를 통해 titleLabel의 text가 "두 번째 뷰 컨트롤러!"인 경우에만 작동을 일시정지하고 titleLabel의 text를 출력하는 액션을 실행하도록 설정해보세요
* breakpoint를 잡고나서 우클릭을 한 후 `Edit Breakpoint...`를 클릭

    ![](https://i.imgur.com/xn3B9R1.png)

* 이후 Condition을 기재해주고 엔터를 한다.

    ![](https://i.imgur.com/bPLHhvx.png)

* Add Action을 눌러서 출력하는 액션을 만드는 것 같다[?]

    ![](https://i.imgur.com/VEqeNS5.png)

### View Controller의 사용자 눈에 보이지 않는 뷰의 오토레이아웃 제약을 확인하기

* ![](https://i.imgur.com/8USVLJf.png)

* ![](https://i.imgur.com/DAtArE5.png)


### 디버그 모드로 실행중인 상태에서 사용자 눈에 보이지 않는 뷰의 색상을 분홍색으로 변겅해보세요
* **expression**
Command는 Runtime에 여러 정보를 출력할 수 있을 뿐 아니라 값을 변경해 줄수도 있다. LLDB는 내부적으로 값이 출력될 때마다 local variable을 $R-의 형태로 만들어 저장한다. 이 값들은 해당 break context가 벗어나도 사용 가능한 값들이고 심지어 수정해서 사용할 수도 있다.

* (lldb) e self.view.subviews
([UIView]) $R1 = 3 values {
  [0] = 0x0000000153609ec0
  [1] = 0x0000000153617fd0
  [2] = 0x00000001536182b0
}
* (lldb) e $R1[0].backgroundColor = UIColor.systemPink
() $R2 = {}
* (lldb) continue

### 두 번째 뷰 컨트롤러의 뷰가 화면에 표시된 상태에서, 두 번째 뷰 컨트롤러 까지의 메모리 그래프를 캡쳐해보기

* ![](https://i.imgur.com/SfMvKXO.png)

* ![](https://i.imgur.com/Ti8Kutb.png)

### LLDB의 특정 명령어의 별칭을 설정해줄 수 있는 명령어는 무엇일까?
* alias
* (lldb) command alias 별명 "줄이고 싶은 Command"
* (lldb) command alias pojc expression -l objc -O --

### LLDB의 v, po, p 명령어의 차이에 대해 알아봅시다
```
  v         -- Show variables for the current stack frame. Defaults to all
  po        -- Evaluate an expression on the current thread.  Displays any
  p         -- Evaluate an expression on the current thread.  ​Displays any

'po' is an abbreviation for 'expression -O  --'
'p' is an abbreviation for 'expression --'
'v' is an abbreviation for 'frame variable'
```
`실제로 차이점 테스트 해보기`
```
(lldb) po titleLabel.text
▿ Optional<String>
  - some : "두 번째 뷰 컨트롤러!"

(lldb) p titleLabel.text
(String?) $R1 = some {
  _guts = {
    _object = (_countAndFlagsBits = 12, _object = 0x50006000036c88a0)
  }
}
(lldb) 
```

![](https://i.imgur.com/lLtyk8v.png)

---
&nbsp;

## split vs components

### import 여부
* split은 swift 표준 라이브러리에 속해있다.
* components는 Foundation 프레임워크에 속해있어 import하여 사용할 수 있다.

### 파라미터
* split(separator: Character, maxSplits: Int = Int.max, omittingEmptySubsequences: Bool = true) 
* components(separatedBy separator: String)

### 공백으로 처리할 때의 다른 결과
```swift
    let str = "My name is Sudhir " // trailing space

    str.split(separator: " ")
    // ["My", "name", "is", "Sudhir"]

    str.components(separatedBy: " ")
    // ["My", "name", "is", "Sudhir", ""] ← Additional empty string
```
둘다 동일한 결과가 나오게 하려면 split의 파라미터 `omittingEmptySubsequences`를 false로 옵션을 따로 줘야 가능하다.
```swift
str.split(separator: " ", omittingEmptySubsequences: false)
    // ["My", "name", "is", "Sudhir", ""]
```

### 반환타입의 차이
* split -> [Substring]
* components -> [String]

### 성능 차이
반환타입에서 볼 수 있듯 `split`은 원본 문자열을 참조(SubString)하고 있기 때문에, 새 문자열을 할당하지 않는다.
따라서 split이 components보다 성능측면에서 빠르다고 볼 수 있다.

>Substring이란?
원본 문자열의 메모리를 공유한다.
값을 읽기만 할 때는 원본메모리를 공유하고, 값을 변경하는 시점에만 새로운 메모리가 생성된다.

Substring은 주로 문자열을 처리할 때 메모리를 절약하기 위해서 쓰이는 타입으로 알고있다!

&nbsp;

---

## 메소드명에 get을 쓰는 것을 왜 지양해야할까?
- [링크](https://github.com/yagom-academy/ios-calculator-app/pull/87#discussion_r749280823)


--- 

&nbsp;
## 해결하지 못한 점
- 디버깅 시 오류(Error) 혹은 익셉션(Exception)이 발생한 경우 프로세스의 동작을 멈추도록 하는 방법


&nbsp;

---

- 참고링크
    - [컴파일과 빌드 차이점](https://freezboi.tistory.com/39)
    - [컴파일 언어](https://ko.wikipedia.org/wiki/%EC%BB%B4%ED%8C%8C%EC%9D%BC_%EC%96%B8%EC%96%B4)
    - [바이트코드 언어](https://ko.wikipedia.org/wiki/%EB%B0%94%EC%9D%B4%ED%8A%B8%EC%BD%94%EB%93%9C)
    - [인터프리터 언어](https://ko.wikipedia.org/wiki/%EC%9D%B8%ED%84%B0%ED%94%84%EB%A6%AC%ED%84%B0)
    - [LLDB 정복](https://yagom.net/courses/start-lldb/)
    - [split vs components](https://stackoverflow.com/questions/46344649/componentseparatedby-versus-splitseparator)
