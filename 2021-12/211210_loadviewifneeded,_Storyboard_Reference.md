# 211210 loadviewifneeded, Storyboard Reference
# TIL (Today I Learned)


12월 10일 (금)

## 학습 내용
- 만국박람회 STEP 2 리팩토링 후 PR 작성
- `loadviewifneeded()`의 용도?
- `Storyboard Reference`가 뭘까?

&nbsp;

## 고민한 점 / 해결 방법

**[loadviewifneeded]**
* ![](https://i.imgur.com/aCfGAKg.png)
    * 제이티와 쥬스메이커 때 사용해봤던 메소드.
    * 나무와 숲재가 뷰를 전환하기 전에 loadView를 사용해서 미리 다음 화면의 View를 load하고 있는 것을 보고 이전에 피드백 받았던 내용이 떠올라서 공유해보았다.
    * 얘기를 나누다가 찾다보니까 발견하게 되었는데, 이 메소드가 알고보니 ViewController를 테스트할 때 주로 사용되는 메소드였다.

---

* 나무, 숲재, 차차와 이야기를 나누는 도중에 발견한…. 이게모야..?
* ![](https://i.imgur.com/ZXTOLzp.png)

**[Storyboard Reference]**


* **Storyboard 장점**
    * ViewController 간 연간 관계를 한눈에 볼 수 있다
    * ViewController의 형태를 시각적으로 표현해줘서 UI가 어떻게 생겼는지 확인할 수 있다.
    * 컨트롤 생성 시 Drag & Drop으로 간단히 생성할 수 있다.
* **Storyboard 단점**
    * Git Marge 시 Storyboard에서 충돌이 발생함
    * 스토리보드에 여러개의 ViewController가 추가되면 스토리보드 실행이 느려지고 심지어 Xcode가 멈춰버리는 일도 발생한다.
* 이러한 문제를 해결하기 위해 2가지 방법을 많이 사용하게 된다.
    * 스토리보드를 사용하지 않고 100% 코드로 UI 개발
    * `One Storyboard`, `One ViewController`(하나의 스토리보드에 하나의 뷰 컨트롤러만) = 스토리보드 나누기

따라서 Storyboard Reference는 스토리보드를 나눌 때, Tabbar를 사용할 때 주로 활용할 수 있다.

---

### 스토리보드 래퍼런스를 활용하여 기존 스토리보드 분할해보기

* 연결되어있는 3개의 ViewController를 나눠보자.
* ![](https://i.imgur.com/em7vnDz.png)
* 먼저 스토리보드 파일을 만들어준다.
* ![](https://i.imgur.com/mUIjBJP.png)
* 그리고 CMD + X, CMD + V를 활용하여 각 파일에 Controller를 넣어준다.
* ![](https://i.imgur.com/LuXiBFM.gif)
* 이후 스토리보드 ID와 Is Initial View Controller를 체크해준다.
* ![](https://i.imgur.com/AjeNZXf.png)
* ![](https://i.imgur.com/FkJb2sV.png)
* 체크를 해주지 않으면 에러가 발생하니까 꼭 해준다.
* 나머지 뷰로 동일한 방법으로 분할해준다.
* ![](https://i.imgur.com/2wjAblK.png)
* 메인으로 돌아가서 스토리보드 래퍼런스를 추가해준다.
* ![](https://i.imgur.com/cdPBtyb.gif)
* 그리고 아래처럼 매칭시킬 스토리보드를 지정해주고
* ID는 매칭할 ViewControllet의 Storyboard ID와 동일하게 맞춰준다.
* ![](https://i.imgur.com/YYNKKmR.png)
* 그리고 Segue를 생성해준다.
* ![](https://i.imgur.com/wslBc2G.gif)
* Segue를 활용하여 화면전환을 할 경우 아래처럼 연결해주고 Segue의 Identifier를 지정해주면 된다.
* ![](https://i.imgur.com/fKU68CG.gif)
* 적용후 정상적으로 Segue를 타고 화면 전환을 하는 모습을 확인할 수 있다.
* ![](https://i.imgur.com/9kHr778.gif)
* 요약
    * 새로운 `Storyboard` 파일을 생성
    * 컨트롤러를 새로 만든 Storyboard 파일에 분할해준다.
    * 분할해준 컨트롤러의 `Storyboard ID` 설정과 `Is Initial View Controller` 체크!!!!
    * 그리고 스토리보드 래퍼런스를 추가한 후 `Storyboard`, `Referenced ID`를 설정한다.
    * `Segue`를 연결한다. 

---

- 참고링크
    - https://felix-mr.tistory.com/15
    - https://github.com/leeari95/ios-juice-maker/tree/4-leeari95#3-2-%EC%9D%98%EB%AC%B8%EC%A0%90
