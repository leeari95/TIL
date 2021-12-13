# 211213 Accessibility, Dynamic Type, Voice over, fatalError, 함수형 프로그래밍, Vim
# TIL (Today I Learned)


12월 13일 (월)

## 학습 내용
- Accessibility 활동학습
- fatalError의 용도?
- 함수형 프로그래밍 복습
- Vim이란?

&nbsp;

## 고민한 점 / 해결 방법

**[fatalError]**

* 호출 즉시 크래시를 발생 시킨다 (프로세스를 죽임)
* 언제?
    * 에러가 치명적일 때
    * 메소드에서 리턴할 것이 없을 때
* * 주로 tableView의 customcell을 다운캐스팅으로 옵셔널바인딩을 할 때 사용하기도 한다.

**[함수형 프로그래밍]**

* 특징
    * 인풋과 아웃풋이 있다.
    * 외부 환경으로부터 철저히 독립적이다
    * 같은 인풋에 있어서 언제나 동일한 아웃풋을 생산해낸다.
* 함수형 프로그래밍이 주목받게 된 주요 이유 중 하나는 ‘부작용’에 의한 문제로부터 보다 자유롭다는 것이다.
* 부작용이란?
    * 어떤 함수의 동작에 의해 프로세스 내 특정 상태가 변경되는 상황을 말한다.

**[Accesibility]**
* 접근성
    * 접근하기 쉬운 성질, 사물이나 환경 따위를 사용자가 불편함없이 이용할 수 있는 정도
* 접근성 지원
    * 누군가의 개성, 문화, 현재 상태(건강 및 주변환경)에 무관하게 앱을 편히 쓸 수 있게 지원하는 것
    * 장애인과 비장애인의 차이에 따른 지원이 아님
* Vision, Gearing, Mobility, Cognitive
* 시각적
    * Dynamic Type. Voice Over, 대비증가, 애니메이션 줄이기 등
* 청각적
    * 화재 및 초인종 등의 소리를 감지해 화면에 표시하는 소리인식 기능, 자막 등
* 운동 능력
    * 받아쓰기, 자동완성, 뒷면 탭 등
* 인지 능력
    * Safari 읽기도구 사용법 유도 기능
* `Xcode → Open Developer Tool → Accesibility Inspector`
    * 해당 경로에 Audit 탭을 활용하면 어떤 부분이 문제점이 있는지 확인할 수 있다.
    * ![](https://i.imgur.com/YBhQgMa.png)

**[Dynamic Type]**
* 모든 사용자가 시력이 같진 않다. 어떤 사용자는 글씨를 크게 키워서 앱을 이용할 수도 있는데, 우리가 앱을 개발할 때 font 크기를 지정해버리면 사용자가 아무리 글씨를 크게 키운다고 해도 앱의 font 크기는 그대로일 것이다.
* 그래서 그런 요구사항을 유연하게 충족할 수 있도록 Dynamic Type을 사용한다면 훨씬 접근성을 구현하기가 좋아질 수 있겠다.
* **Dynamic Type을 적용하려면?**
    * 폰트 크기를 System이 아니라 Dynamic Type으로 설정해준다.
        * ![](https://i.imgur.com/7ntEh1o.png)
    * **Automatically Adjusts Font**
        * 앱이 실행되는 동안에 글씨 크기가 바꾸는 것을 허용하는지의 대한 것
        * 체크를 해주지 않으면 앱을 종료하고 다시 실행시켜서 폰트가 커졌는지 확인해야하는 번거로움이 생기기 때문에 체크를 해주는 것이 바람직하다.
        * Label은 스토리보드의 Inspector에서 적용할 수 있지만 버튼의 경우는 불가하기 때문에 코드로 직접 설정해주어야 한다.
        ```swift
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        ```

**[Voice over]**
화면을 보지 않고도 사용자가 장치를 제어할 수 있게 해주는 Apple의 혁신적인 화면 읽기 기술이다. 앱의 객체와 상호 작용하는 스크린 리더로, 사용자가 볼 수 없더라도 인터페이스를 사용할 수 있다.
* Voice over 기능을 통해 사용자가 잘 알아듣도록 읽게 하려면?
    * 각 요소에 모두 Accessibility Label을 설정해야 한다.
    * UI 요소 타입은 자동으로 읽어주기 때문에 이름에 포함하지 않는다.
        * `Add button` Not Good
        * `Add` Good
    * 아래 +와 같은 버튼의 Accessibility Label은 단순히 Add라 짓지 않고 어떤 것의 Add인지 자세히 설명해준다.
        * `Add` Not Good
        * `Add Peanut Butter` Good
    * 반복된 단어의 사용은 지양한다.
    * 예를 들어 음악 재생 애플리케이션에 있는 버튼의 Accessibility Label은 당연히 음악과 관련된 버튼일 것이므로 song, music과 같은 이름을 생략한다.
        * `Previous song, Play song, Next song` Not Good
        * `Previous, Play, Next` Good
    * 애니메이션에 의미 있는 이름을 지어준다.
        * `spinner` Not Good
        * `Loading...`` Good
    * 너무 장황한 설명은 지양한다.
        * `Delete item from the current folder and add it to the trash` Not Good
        * `Delete` Good
    * 적절한 상황에는 장황한 이름을 지어도 좋다.
        * 예를 들어, 이모티콘과 같은 요소는 느낌과 감정을 표현하기 위해 약간은 긴 설명이 포함되어도 좋다.
* 시스템 언어를 바꾸면 한글이여도 해당 언어로 번역하여 voice over를 실행시켜준다.

**[Vim이란?]**
* 마우스 없이 단축키를 이용하여 코드를 편집할 수 있는 프로그램이다.
* Xcode에서 Vim 모드 설정하기
* ![](https://i.imgur.com/WckyZl8.png)
* Vim의 간단한 단축키 모음
* ![](https://i.imgur.com/Up9GMP7.png)
* 단축키모드와 입력모드

| 단축키 | 설명 |
|:---:|:---|
|  `i`   | 커서 앞에서 입력모드 시작 |
| `I` | 줄 맨앞에서 입력모드 시작 |
| `a` | 커서 뒤에서 입력모드 시작 |
| `A` | 줄 맨뒤에서 입력모드 시작 |
| `ESC` | 입력모드에서 단축키모드로 전환 |

* 커서 이동

| 단축키 | 설명 |
|:---:|:---|
| `h` | 👈🏻 |
| `j` | 👇🏻 |
| `k` | 👆🏻 |
| `l` | 👉🏻 |
| `w` | 다음 단어로 |
| `b` | 이전 단어로 |
| `{` | 문단 시작으로 |
| `}` | 문단 끝으로 |

* 복사, 붙여넣기, 선택모드

| 단축키 | 설명 |
|:---:|:---|
| `v` | 선택모드 |
| `V` | 줄 단위 선택모드 |
| `y` | 복사 |
| `p` | 붙여넣기 |
| `x` | 선택 부분 오려두기 |
| `d` | 선택 부분 지우기 |

* 수정모드, 내어쓰기, 들여쓰기

| 단축키 | 설명 |
|:---:|:---|
| `R` | 수정모드 |
| `r` | 한 글자 수정 |
| `o` | 빈 줄 넣고 입력모드 |
| `<` | 내어쓰기 |
| `>` | 들여쓰기 | 

* 화면 이동

| 단축키 | 설명 |
|:---:|:---|
| `H` | 화면 맨 위로 이동|
| `L` | 화면 맨 아래 이동 |
| `M` | 화면 한 가운데 이동 |
| `Ctrl + u` | 반 페이지씩 화면 위로 이동 |
| `Ctrl + d` | 반 페이지씩 화면 아래로 이동 |


---

- 참고링크
    - https://gwangyonglee.tistory.com/52
    - https://velog.io/@ryan-son/Xcode-Accessibility-Accessibility-Inspector
    - https://eunjin3786.tistory.com/366
    - https://www.youtube.com/watch?v=jVG5jvOzu9Y
    - https://www.youtube.com/watch?v=qn1soztN7k4
    - https://github.com/johngrib/simple_vim_guide
    - https://vim-adventures.com/
    - https://www.sungdoo.dev/programming/why-xcode-supporthttps://vim-adventures.com/s-vim
