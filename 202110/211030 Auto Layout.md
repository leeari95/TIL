# TIL (Today I Learned)

10월 30일 (토)

## 학습 내용
오늘은 오토레이아웃을 복습하면서 알게된 새로운 지식에 대해서 정리해보았다.


# Intrinsic Content Size
Content의 기본적인 크기를 뜻한다.

## Placeholder
스토리보드 내에서만 임시적으로 크기를 조정할 수 있다. 실제 앱 실행시에는 적용한 사이즈가 반영되지 않는다.

--- 

* 코드로 UIView의 사이즈를 지정해주고, class를 연결해주면 사이즈를 갖는 View가 구성된다.
    ```swift
    @IBDesignable
    class MyView: UIView {

        override var intrinsicContentSize: CGSize {
            return CGSize(width: 50, height: 50)
        }
    }
    ```
&nbsp;

# CHCR
자신의 사이즈를 지키려는 힘을 뜻한다. Priority를 가지고 그것을 기반으로 힘의 세기를 결정하게 된다.

## Content Hugging
외부에서 압력을 줄 때 늘어나지 않으려고 버티는 힘

## 예제로 이해하기
* 예시로 레이블의 Content Hugging을 각각 다른 강도로 주어졌을때 250으로 세팅되어있는 레이블이 늘어난 것을 확인할 수 있다.
    * 1000은 절대 늘어나지 않고, 750은 조금 늘어나도 괜찮고, 250은 늘어나도 상관없다는 뜻

![](https://i.imgur.com/HBs4Xtn.png)


## Compression Resistance
외부에서 압력을 줄 때 버티는 힘

## 예제로 이해하기
* Priority가 가장 낮은 레이블은 아무리 늘어나려고 해도 옆에 Priority가 높은 레이블이 있기 때문에 더 이상 늘어나지 않는 것을 확인할 수 있다.

![](https://i.imgur.com/e5gK1Sv.png)
&nbsp;


* 반대로 Priority가 높은 레이블이 늘어나려고 한다면 Priority가 낮은 250 레이블이 덮어버리는 현상을 확인할 수 있다.

![](https://i.imgur.com/y8C00rs.png)
&nbsp;


* 아래는 제일 높은 우선순위(Priority)를 가진 레이블이 다 덮어버린 모습이다.

![](https://i.imgur.com/794jWfF.png)
&nbsp;



# 꿀팁모음
* 메뉴가 펼쳐진 상태에서 Option키를 누르면 메뉴에 옵션이 추가되는 것을 볼 수 있다.

![](https://i.imgur.com/st3n9FP.gif)
&nbsp;


* [해당 사이트](www.wtfautolayout.com)에 오토 레이아웃 오류 로그를 붙여넣으면 어떻게 해결해야하는지 힌트들이 나온다.

![](https://i.imgur.com/Mq39Dcu.gif)

&nbsp;
