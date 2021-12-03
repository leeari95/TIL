# TIL (Today I Learned)

11월 5일 (금)

## 학습 내용
오늘은 오전부터 제이티와 함께 흰에게 코드리뷰를 받는 시간을 가지고, 피드백을 반영하여 리팩토링을 하는 것으로 시간을 보냈다. 이후 느낀점들이 많아서 기록하고 잊을때 쯤 다시 보면서 리마인드하는 시간을 가져야겠다. 이후 README를 다듬으며 시간을 보냈다.

&nbsp;

## 문제점 / 고민한 점
- 흰에게 코드를 설명하는 과정에서 제이티와 나의 의견이 다르다는 것을 깨달았다.
- 디자인 패턴이나 코드나 무엇이든 사용을 할때 정확한 근거와 이유를 가지고 사용해야겠다는 생각이 들었다.
- 프로젝트 STEP 진행에 있어서 중요한 것이 뭘까?
- 배운 것을 무조건 프로젝트에 적용해보는게 좋은 걸까?
- UILabel들을 배열에 담는 좋은 방법이 있을까?
- 가끔 UIButton 같은 내부 속성들을 스토리보드에서 다룰 수 없는 경우가 있는데, 이럴땐 코드로 구현해야한다. 근데 좀더 간결화할 순 없을까?

&nbsp;
## 해결방법
- 코드 리뷰를 하며 깨달았던 부분을 통해 프로젝트 코드 방향성에 대해서 다시한번 생각해보며 제이티와 다시 이야기를 나누었다. 프로젝트 진행함에 있어서 팀원과의 코드 방향성에 대해서 정확한 의사소통이 필요하다고 느꼈던 시간이였다.
- `배웠으니 사용해보면 좋겠다` 라는 이유로 싱글톤을 적용해보았는데, 그건 아주 잘못된 생각이였다. 또한 나름의 이유가 있어서 싱글톤을 적용해보면 좋겠다고 생각이 들었었는데, 다시 생각해보니 싱글톤이 없어도 충분히 구현할 수 있는 부분이였다는 걸 깨달았다. 그래도 싱글톤을 직접 겪으면서 장단점을 잘 파악할 수 있어서 뜻 깊었던 시간이였다.
- 흰이 리뷰를 해주면서 깨달음을 주었다. STEP 진행에 있어서 중요한 것은 스텝을 진행하면서 점점 **코드를 개선하고 나아가는 방향**으로 진행해야 된다는 것이다. 따라서 이전 스텝의 요구사항을 현재 진행하고 있는 스텝에서 신경 쓸 필요는 없는 것 같다는 생각이 들었다.
- 배운 것을 프로젝트에 적용해보는 것은 경험상 아주 좋은 것 같다. 특히나 배우는 입장에서는 말이다. 그러나 사용할 때 `정확한 근거`와 `이유`를 토대로 사용을 해야할 것 같다. 막연히 `배워보았으니 써볼까?` 라는 안일한 생각으로 사용하는 것은 이유없이 쓰는 것이나 마찬가지다.
- 디스코드 돌아다니다가 캠퍼 `namu`가 준 꿀팁이다. 프로젝트 진행시 배열로 뭔가 손쉽게 만들 수 있을 것 같은데 방법을 몰랐는데, 마침 나무가 엘리네 팀을 도와주면서 주었던 팁이다. (주섬주섬...)
   
   ![](https://i.imgur.com/6cqk3pd.png)
   
   ![](https://i.imgur.com/JUh5XXf.png)
  
  Outlet Collection을 사용하여 View를 배열로 만들 수 있었다.
- 흰에게 조언을 구해서 알려주셨던 꿀팁인데 보통 현업에서는 UIButton에 extension해서 원하는 기능을 추가하고 적용하는 방식으로 작성한다고 한다. 이번 프로젝트를 개선해보면서 적용시켜보았다. 그랬더니 어느정도 코드를 간결화해줄 수 있었다.
```swift
// 개선하기 전 코드
func setUpbuttonLabelFontAttributes() {
    orderStrawberryBananaJuiceButton.titleLabel?.adjustsFontForContentSizeCategory = true
    orderMangoKiwiJuiceButton.titleLabel?.adjustsFontForContentSizeCategory = true
    orderStrawberryJuiceButton.titleLabel?.adjustsFontForContentSizeCategory = true
    orderBananaJuiceButton.titleLabel?.adjustsFontForContentSizeCategory = true
    orderPineappleJuiceButton.titleLabel?.adjustsFontForContentSizeCategory = true
    orderKiwiJuiceButton.titleLabel?.adjustsFontForContentSizeCategory = true
    orderMangoJuiceButton.titleLabel?.adjustsFontForContentSizeCategory = true

    orderStrawberryBananaJuiceButton.titleLabel?.adjustsFontSizeToFitWidth = true
    orderMangoKiwiJuiceButton.titleLabel?.adjustsFontSizeToFitWidth = true
    orderStrawberryJuiceButton.titleLabel?.adjustsFontSizeToFitWidth = true
    orderBananaJuiceButton.titleLabel?.adjustsFontSizeToFitWidth = true
    orderPineappleJuiceButton.titleLabel?.adjustsFontSizeToFitWidth = true
    orderKiwiJuiceButton.titleLabel?.adjustsFontSizeToFitWidth = true
    orderMangoJuiceButton.titleLabel?.adjustsFontSizeToFitWidth = true
}

// 개선 후 코드
extension UIButton {
    func setUpTitleLabelFontAttributes() {
        titleLabel?.adjustsFontForContentSizeCategory = true
        titleLabel?.adjustsFontSizeToFitWidth = true
    }
}

func setUpbuttonLabelFontAttributes() {
    orderStrawberryBananaJuiceButton.setUpTitleLabelFontAttributes()
    orderMangoKiwiJuiceButton.setUpTitleLabelFontAttributes()
    orderStrawberryJuiceButton.setUpTitleLabelFontAttributes()
    orderBananaJuiceButton.setUpTitleLabelFontAttributes()
    orderPineappleJuiceButton.setUpTitleLabelFontAttributes()
    orderKiwiJuiceButton.setUpTitleLabelFontAttributes()
    orderMangoJuiceButton.setUpTitleLabelFontAttributes()
    }
```
