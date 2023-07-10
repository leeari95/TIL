# 211021 initalizer, HIG, Notification, Alert, Segue, Storyboard
# TIL (Today I Learned)

10월 21일 (목)

## 학습 내용
오늘은 프로퍼티, 이니셜라이저, 노티피케이션 등 여러가지의 강의를 들었다. 이니셜라이저는 아직도 어려운 부분인데, Convenience initalizer의 설명을 들으면서 잊었었던 지식을 다시한번 기억해냈고, 이니셜라이저를 안쓰다보니까 어떻게 활용해야할지 몰랐는데 프로젝트에서 받았던 피드백이 기억나서 바로 고쳐먹어야겠다는 생각이 들었다. 그리고 노티피케이션도 [**예습**](https://github.com/leeari95/TIL/blob/main/2021-10/211020%20KVC%2C%20Notification%2C%20NotificationCenter.md)때 너무 어려웠던 내용인데 강의를 들어도 아직 어렵다... 프로젝트에서는 어떤식으로 적용해야할지 감이 안잡힌다. 사용방법은 알겠는데 어디서 어떤식으로 적용을 시켜야 할지 모르겠다... 한방에 이해하기엔 어려운 내용이라 그래서 안심이 됬다. 무한 복습을 하는 수 밖에...

&nbsp;

## 문제점 / 고민한 점
- Convenience initalizer는 클래스에서만 사용이 가능했던가? 기억이 가물가물...
- 그렇다면 구조체에서 다른 이니셜라이저를 생성해주려면 어떻게 해야할까?
- Notification의 주요 프로퍼티중에서 object와 userInfo가 정확하게 무슨 역할을 하는 것인지?
- 프로젝트 STEP 2 내용을 봤는데 어떻게 해야하는건지 하나도 모르겠다.
- Alert을 공부하는 도중 버튼 위치 규칙같은게 있나 찾아보았다.

## 해결방법
- Convenience initalizer는 클래스에서만 사용이 가능하다. 구조체에서는 Convenience 키워드를 빼고 그냥 init으로 또다른 이니셜라이저를 생성해주면 된다. 편의 이니셜라이저와 같은 방식으로 만들 수 있다.
- Notification
    - **name** 알림을 식별하는 태그
    - **object** 발송자가 옵저버에게 보내려고 하는 객체, 주로 발송자 객체를 전달하는데 쓰인다.
    - **userInfo** 노티피케이션과 관련된 값 또는 객체의 저장소
    예) 특정 행동으로 인해 작업이 시작되거나 완료되는 시점에 다른 인스턴스로 노티피케이션이 발생 시 필요한 데이터를 같이 넘겨줄 수 있다. 간단한 예로 네트워킹을 이용하는 애플리케이션이라면 네트워킹이 시작 및 완료되는 시점, 음악 및 동영상 재생 등에도 재생이 끝나는 시점에 관련 정보를 넘겨줄 수 있다.
- Alert 만들기와 Storyboad Segue에 대해서 학습하고 예제를 만들어보았다.
- Alert을 만들때 2개 이상 액션버튼은 actionSheet으로 만들어줘야 하며 cancel 버튼은 좌측에 위치해야한다.


&nbsp;

## 공부내용 정리
<details>
<summary>Segue</summary>
<div markdown="1">

# 인터페이스 빌더에서 직접 연결하기

-  일단 2개의 View Controller를 준비한 후 ‘Go to B’ 버튼을 올려준다.
&nbsp;
-  그리고 ‘Go to B’ 버튼을 선택 후 Ctrl 키를 누른채로 B View Controller로 드래그를 하면 연결할 수 있는 Segue의 종류가 뜬다.

![](https://i.imgur.com/iOCdlT5.gif)

&nbsp;

- Segue로 Show를 선택하면 화살표가 하나 생기는데, 이게 Segue가 연결되었다는 의미이고, Segue를 선택한 후 Inspector에서 여러 설정을 바꿀 수도 있다.

![](https://i.imgur.com/QQzdEg6.png)

&nbsp;
- 결과 화면
이 예제에서는 Modal처럼 화면이 아래서 올라오는데, 옆으로 넘어가는 효과를 적용하려면 A ViewController를 Navigation Controller에 Embed 해주어야 한다.

![](https://i.imgur.com/edhPXRj.gif)

---

직접 연결하는 방법은 ViewController 간의 상관관계를 직관적으로 알기는 좋지만 코드 내에서 ViewController 간의 관계에 따라 코드를 작성하기는 좀 어렵다. 그리고 하다보면 내가 Segue를 어디에 연결했는지 계속 확인해야하고, 처음에 연결할 때는 편리하긴 하지만 뒤로 갈수록 불편한 점이 많다.)

또한 Segue가 여러개 필요하다던지 ViewController 간의 데이터 전달이 필요하다던지 할 때는 performSegue나 present를 쓰는 것이 훨씬 편하다.

---

# Segue의 Identifier 설정 후 코드에서 performSegue 하기

이번에는 Inspector에서 Segue의 Identifier를 설정한 후 코드에서 화면 전환이 필요한 때에 performSegue 메소드를 사용하여 Segue 객체를 생성해보자.

* 우선 위의 예제처럼 스토리보드에서 Segue를 연결해준다. 근데 Button에서 Ctrl로 끌어가는 것이 아니라 A View Controller의 위에있는 버튼에서 끌고 간다.

![](https://i.imgur.com/KjEibf7.gif)

&nbsp;

* 그리고 Segue 화살표를 누른다.

![](https://i.imgur.com/QpQ39Rd.png)

&nbsp;
* Inspector에 보면 Segue의 Identifier를 설정할 수 있다.

![](https://i.imgur.com/P45hMeT.png)

&nbsp;
* 그리고 ‘Go to B’ 버튼을 IBAction 메서드를 만들어 준 후 메소드 안에서 performSegue(withIdentifier: sender:) 를 구현해준다. 이렇게 하면 내가 원하는 Segue의 identifier를 넣어주기만 하면 원하는 View로의 전환이 가능하다.

![](https://i.imgur.com/WobhDWx.gif)

![](https://i.imgur.com/2dhh3c7.gif)

&nbsp;
> performSegue 메소드가 실행되기 전에 prepare(for segue: sender:) 메소드가 항상 먼저 실행되는데, ViewController 간에 데이터를 전달해야 할 때 이 prepare(for segue: sender:)를 이용한다.

&nbsp;
# StoryBoard ID 설정 후 코드에서 present 하기

이번에는 Ctrl로 드래그앤드롭 하여 Segue를 연결해줄 필요 없이 각 ViewController의 StoryBoard ID를 지정해주고 코드에서 present(_: animated: completion:) 라는 메서드를 이용해보자.
&nbsp;
* B View Controller를 선택 후 Inspector에서 Identity > Storyboard ID를 “ViewB”로 설정해준다.

![](https://i.imgur.com/wjFDUI5.png)

&nbsp;
* IBAction 버튼 메서드 내부에서 instantiateViewController(identifier:) 메서드를 이용하여 UIViewController를 가져온다. 이때 옵셔널 타입이므로 옵셔널 바인딩해준다.
```swift
@IBAction func goToB(_ sender: UIButton) {
    guard let viewB = self.storyboard?.instantiateViewController(identifier: "ViewB") else {
        return
    }
    present(viewB, animated: true, completion: nil)
}
```
&nbsp;
* 그런 다음 위와 같이 present 메소드를 써서 ViewB를 보여달라고 말하면 된다.


</div>
</details>
<details>
<summary>Alert</summary>
<div markdown="1">

알림창을 만들어보자.

# IBAction 만들기

* 버튼을 Ctrl을 누르면서 코드쪽으로 드래그하면 된다.

![](https://i.imgur.com/lSNTWk6.png)

&nbsp;
* Name칸을 채워주고, Type을 UIButton으로 설정해준 뒤 Connect 버튼을 클릭해준다.

![](https://i.imgur.com/Th6xCfz.png)

&nbsp;
* 그럼 이러한 함수가 뙇! 생기는데 이 내부에다가 코드를 적어줄 것이다.

![](https://i.imgur.com/TXDwzpA.png)

&nbsp;
## Alert 제목과 메세지내용 만들기.

```swift
let alret = UIAlertController(title: "알림", message: "알림창 내용", preferredStyle: .alert)
```

위와 같이 UIAlertController를 이용하여 파라미터를 채워준다. preferredStyle은 아래와 같이 두가지가 있다.

&nbsp;
* Alert 

![](https://i.imgur.com/SgDL69z.png)

&nbsp;
* actionSheet

![](https://i.imgur.com/3MCmYER.png)

&nbsp;
## Alert에 들어갈 액션버튼 만들기

위 사진과 같은 Yes, No 같은 버튼을 따로 구현해줘야 한다.

```swift
let yes = UIAlertAction(title: "Yes", style: .default, handler: nil)
let no = UIAlertAction(title: "No", style: .destructive, handler: nil)
```
### style

* cancel과 default는 글씨 굵기 빼고 동일하다. 
* destructive는 빨간 글씨로 표시된다.
&nbsp;

### handler

* 버튼을 눌렀을 때 실행해야하는 행동을 추가하는 부분이다. 추가를 하겠다면 

![](https://i.imgur.com/iWQ02Mr.png)
&nbsp;

* 이 파란색 부분에서 엔터를 치면

![](https://i.imgur.com/X1e0pjp.png)
&nbsp;

* 이렇게 클로저가 생기는데 내부에 코드를 작성해주면 된다.
&nbsp;
나는 아무것도 안할거기 때문에 nil을 넣어주었다.
&nbsp;
## 만들어준 UIAlertController와 UIAlertAction을 연결해주기

지금까지 alert의 제목과 메세지, 그리고 액션버튼을 만들어주었다.
이것들을 합쳐주는 작업이 필요하다.
```swift
alret.addAction(no)
alret.addAction(yes)
```
이렇게 말이다.
&nbsp;
## alert view를 화면에 뜨게 만들어주기

```swift
present(alret, animated: true, completion: nil)
```
Present 메서드를 통해서 alert을 뜨게 만들어준다.
### animated
animated를 true하면 애니메이션 같이 부드럽게 뜨고, false로 하면 그냥 빡!!! 하고 나타난다.
잘 모르겠다면 true, false를 바꿔가면서 테스트 해보자.

### completion
이것도 위에서 봤던 핸들러랑 같은 의미의 파라미터다.

![](https://i.imgur.com/fpbegh7.png)

ompletion을 위와 같은 방법으로 엔터를 친다면 위와 같이 클로저가 생기면서 코드를 적을 수 있다.
해당 alret이 성공적으로 수행되고 나서 이 함수가 끝난 뒤 뭘 할거냐? 라고 지정해주는 부분이라고 보면 된다.

&nbsp;
## 요약
1. 만들고 싶은 alert을 만든다
`let alret = UIAlertController(title: "알림", message: "알림창 내용", preferredStyle: .alert)`
2. 액션 버튼을 만든다.
`let yes = UIAlertAction(title: "Yes", style: .default, handler: nil)`
`let no = UIAlertAction(title: "No", style: .destructive, handler: nil)`
3. alert 컨트롤러와 내가 만든 액션버튼을 addAction 메서드를 이용해서 바인딩해준다.
`alret.addAction(no)`
`alret.addAction(yes)`
4. present 한다.
`present(alret, animated: true, completion: nil)`
&nbsp;
## 주의해야할 점
1. alert에 추가하는 순서대로 왼쪽부터 나타나게 된다.
alertAction을 만드는 순서는 상관없고 추가하는 순서가 중요하다.
2.  UIAlertController 안에 UIAlertActionStyle이 cancel인 액션버튼이 두개이상 들어갈 수 없다.
3. 액션버튼을 두가지 이상으로 사용하고 싶다면 .alert 대신 .actionSheet style을 사용한다.
&nbsp;
## Full Code
```swift
    @IBAction func printAlret(_ sender: UIButton) {
        let alret = UIAlertController(title: "알림", message: "알림창 내용", preferredStyle: .alert)
        let yes = UIAlertAction(title: "Yes", style: .default, handler: nil)
        let no = UIAlertAction(title: "No", style: .destructive, handler: nil)
        
        alret.addAction(no)
        alret.addAction(yes)

        present(alret, animated: true, completion: nil)
    }
```


</div>
</details>

---

- 참고링크
    - [HIG-Undo and Redo](https://developer.apple.com/design/human-interface-guidelines/ios/user-interaction/undo-and-redo/)
    - [야곰 iOS 왕초보 강의](https://yagom.net/courses/ios-starter-uikit/)
    - [initalizer](https://docs.swift.org/swift-book/LanguageGuide/Initialization.html)
    - [Blog - Alert만들기](https://zeddios.tistory.com/111?category=682195)
