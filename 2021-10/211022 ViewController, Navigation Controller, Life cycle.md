# TIL (Today I Learned)

10월 21일 (목)

## 학습 내용
오늘은 프로젝트 STEP2를 진행하려면 공부해야할 것들을 학습했다. 직접 예제를 만들어보면서 공부하니까 재밌고 이해하는데 있어서 도움이 많이되었다.

&nbsp;

## 문제점 / 고민한 점
- Embed in 후 ViewController에 클래스를 지정해주고, 코드로 title을 바꿔주었는데, 적용이 제대로 안되었다.
- 프로젝트 내부 코드중 Recipe를 switch문으로 return하는 연산프로퍼티가 있는데, 다른 팀에서 하드코딩이라는 피드백을 받았다고 한다. 어떻게 하면 개선할 수 있을까...
- ViewController의 Life Cycle이 어렵진 않은 개념같은데 중요한 이유가 뭘까?

&nbsp;
## 해결방법
- 클래스를 자꾸 지웠다가 다시 만들어줘서 꼬인 것 같았다. 클래스 파일을 지우고 다시 새로 만들어 주었더니 해결...
- 여러가지 방법들을 생각하고 고민해보았지만 Recipe를 유연하게 만들 수 있는 좋은 방법을 찾지 못했다. 다른 리뷰어의 의견도 듣고싶어서 질문을 열심히 정리해서 DM을 보내보았다. 답장을 손꼽아 기다리며...
- ViewController Life Cycle이 왜 중요할까?
    * 프로그래밍은 코드가 순차적으로 실행이 되는 알고리즘의 형태로 동작한다. 그렇기 때문에 한 화면이 동작하거나 열리고 닫히는 순간에도 철저하게 미묘한 차이의 순서대로 동작한다.
    * 화면이 열리고 닫히는 시점에 맞춰 음악이 재생되거나, 어떤 애니메이션이 동작할 때, 혹은 어떤 기능을 수행하게 될 때 Life Cycle에 따라 미묘한 차이가 발생한다. 이러한 오차에 대해 정확하게 반응하기 위해서는 뷰의 생명주기를 잘 이해할 필요가 있다.
* 그렇다면 홈화면을 갔다가 오는 경우, 앱이 완전히 종료되는 경우에는 어떻게 동작하는 걸까?
    * 이 부분에 대해서는 Application의 Life Cycle을 공부해야할 것 같다.

&nbsp;

## 공부내용 정리
- [[iOS] ViewController와 종류](https://leeari95.tistory.com/55)
- [[iOS] Navigation Controller 맛보기](https://leeari95.tistory.com/56)
- [[iOS] ViewController의 Life cycle](https://leeari95.tistory.com/57)
---

- 참고링크
    - [ViewControllers](https://developer.apple.com/documentation/uikit/view_controllers)
    - [UINavigationController](https://developer.apple.com/documentation/uikit/uinavigationcontroller)
    - [App Life Cycle](https://developer.apple.com/documentation/uikit/app_and_environment/managing_your_app_s_life_cycle)
