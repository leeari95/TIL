# 230915 UIImage, withTintColor, renderingMode
# TIL (Today I Learned)


9월 15일 (금)

## 학습 내용
- UIImage에 tintColor를 적용했는데 원하는 색상이 제대로 입혀지지 않아서 알아보았다.

&nbsp;

## 고민한 점 / 해결 방법

- 원래 내가 tintColor를 적용하려고 했던 이미지의 원본 색상은 회색이였다.
- 해당 이미지에 더 밝은 색상의 회색을 적용하려고 했지만, 원하는 밝기의 회색 색상이 적용되지 않았다.
- UIImage의 withTintColor의 동작 방식
    - UIImage에 색상을 입히려면 renderingMode의 `alwaysTemplate` 모드를 사용해야한다.
    - 해당 모드는 `이미지의 원래 색상 정보는 무시되고 알파값만 사용`하게 된다.
        - 즉, 이미지의 색상 대신 `투명도만이 중요`해진다.
    - 즉, 원본 이미지의 색상 정보는 무시하고 지정된 틴트 색상으로 이미지를 렌더링하는 효과를 얻게 된다.
    - 지정된 틴트 색상은 원본 이미지의 투명도에 따라 적용된다.
- 따라서 제대로 적용되지 않았던 이유는, 원본 이미지의 알파값이 100% 가 아니였기 때문에 내가 원했던 색상이 적용되지 않았던 것이다. 
- 그래서 이미지의 원본 색상을 회색에서 흰색으로 수정해주고 withTintColor를 적용해주었더니 원하는 색상 값이 적용되었다.

---

- 참고링크
    - https://developer.apple.com/documentation/uikit/uiimage/3327300-withtintcolor
    - https://developer.apple.com/documentation/uikit/uiimage/renderingmode
    - https://www.zehye.kr/ios/2021/06/12/iOS_tintColor_image_rendering/
