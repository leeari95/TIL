# 220110 FileManager, iOS File System, Multipart/form-data
# TIL (Today I Learned)


1월 10일 (월)

## 학습 내용
- 오픈 마켓 프로젝트 STEP 2
- Multipart/form-data 때문에 9시간 삽질..


&nbsp;

## 고민한 점 / 해결 방법

**[네트워킹 할 때 dataTask 함수 내부에서 상태코드와 응답메세지 확인하는 방법]**

* 뭔가 상태코드가 에러가 났을 때 리스폰스에 상태메세지가 담기는 줄 알았는데, data에 json 형식으로 담아주더라... 일단 이거 알아내는데 삽질..

```swift
// dataTask 내부. resoponse 바인딩 처리 이후...
guard (200...299).contains(response.statusCode) else {
    completion(.failure(NetworkError.statusCode(response.statusCode))) // 에러 처리
    print("---")
    print(httpResponse.statusCode) // 상태코드 출력

    if let convertedJsonIntoDict = try? JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
        // 응답메세지를 data > Json > NSDictionary로 변환해서 출력
        print(convertedJsonIntoDict)
    }

    print("---")
    return // 클로저 리턴
}
```

* 그래서 위에 data를 JSONSerialization로 json으로 변환 후 NSDictionary로 다운캐스팅 해주면 상태메세지가 아래처럼 나온다.
* 아래 메세지는 삽질하다가 경험했던 코드랑 메세지중 하나.. 406도 보았다.
```
 {
     code = 500;
     message = "Cannot invoke \"java.awt.image.BufferedImage.getWidth()\" because \"buffer\" is null";
 }
```
**[URLRequest에 등록한 헤더, 바디를 확인하는 방법]**

* 헤더는 아래 프로퍼티에 접근해서 print를 찍으면 출력해주더라
    * `request.allHTTPHeaderFields`
* Request의 바디 내부 문자열은 String 내부 init을 활용했다.
    * `String(data: request.httpBody!, encoding: .utf8)`

**[삽질 기록]**

* 삽질하고 나면 뿌듯함보다 현타가 씨게 찾아온다... 정상인가...
* 시작은 다른 팀들이 테스트로 상품등록을 한걸 보고 우리 코드로도 상품 등록이 되나 확인차 테스트를 한게 시작이였다. 그게 저녁 9시쯤이였나...
* 근데 제대로 되질 않았다. 상태코드, 응답메세지, multipart form-data 양식을 꼼꼼히 살펴보면서 삽질하기 시작했다.
* 406 에러가 나서 헤더가 문제인 줄 알았는데, 그건 아니였다.
* 결국 문제는 하드코딩을 개선하려고 만들어 두었던 타입에서 연관값을 활용해 Data 타입과 문자열을 함께 String 타입으로 반환하는 것이 문제였다.
    * 예를 들면 이런식.. `"\(data)\r\n"`
* 그래서 문자열은 문자열대로 append 시키고, Data타입은 또 따로.. 각 타입별로 append를 분리해주니 해결되었다.
    * 편의를 위해 만들었던 `append(_ string:)`를 잘못써먹고 있었네...
* 해결하고나니 프로젝트 코드의 문제점들이 꽤나 많았었다. 리팩토링을 많이 해야할 것 같다.
```swift
body.append("--\(boundary)\r\n")
body.append("Content-Disposition: form-data; name=\"params\"\r\n")
body.append("Content-Type: application/json\r\n\r\n")
body.append(encodeData) // 앤 데이터라 따로 append
body.append("\r\n")
```
* Mock 테스트할 땐 문제 없었는데, 실제로 API를 찌르는 테스트를 하다보니 발견한 문제점들이다.
    * 그린 말대로 fake 테스트도 꼭 필요할 것 같다.
* 다 마치고나니 오전 6시였다. 3시쯤 해결못하는 나자신한태 빡쳐서 자려고 누웠었는데, 찝찝함에 잠이 오질 않았다. 결국엔 다 해결하고 쪽잠 3시간을 잤네 😇

---

**[iOS File System]**

* 파일/자료를 탐색/접근/보관 등의 기능으로 파일을 효율적으로 관리하는 시스템
        * 영구 저장소 관리
    * OS <-> File System <-> Disk
* 애플 파일 시스템
    * Apple file system, APFS로 불리며 애플에서 macOS, iOS, watchOS, tvOS 모두에서 범용으로 사용하도록 만든 파일시스템
    * 디스크 파일 시스템(디스크 드라이브 관리)
    * 기존 HFS+ 대체하는 신규 파일 시스템
    * iOS에서는 10.3 버전부터 macOS에서는 하이 시에라 버전부터 도입
* 애플 파일 시스템의 기능
    * 컨테이너 방법 사용하여 컨테이너 내 파티션 용량 조전
    * 카피 온 라이트 지원  -> 스냅샷 용이
    * 강력한 암호화 기능 추가
* ![](https://i.imgur.com/XNuBm1z.png)
* iOS file system
    * iOS 파일 시스템은 해당 각각의 앱에 맞춰져있다. (시스템 간결성 및 보안 측면)
    * 앱 SandBox 디렉토리 내부에서 파일 시스템과 상호작용 (앱 설치시 각 기능의 컨테이너를 SandBox에 담음)
    * budle Container: 앱 번들
    * Data Container: 앱/유저 데이터 해당 컨테이너 안에 서브 디렉토리가 생성되어 데이터를 관리
    * iCloud Container: iCloud 관련 데이터
* 다양한 디렉토리
    * Bundle(MyApp.app)
        * 이 디렉토리는 앱과 모든 리소스를 포함한다.
        * 쓰기가 불가능하다.
        * 변조를 방지하기 위해 bundle 디렉토리는 app 설치시 서명된다.
        * 이 디렉토리에서 쓰기를 하게 되면 서명이 변경되고, app이 launch되지 않는다.
        * app bundle에 저장된 모든 리소스에 대한 읽기 전용 접근 권한을 얻을 수 있다.
        * iCloud / iTunes 백업불가
        * iTunes는 App Store에서 구입한 모든 응용 프로그램의 초기 동기화를 수행한다.
    * Documents
        * 사용자 생성 콘텐츠 저장
        * 파일 공유를 통해 사용자가 사용할 수 있다. 따라서 사용자에게 공개할 수 있는 파일만 포함되어야 한다.
        * 사용자가 수정/추가/삭제 가능(iTunes 파일 공유)
        * 사용자에게 노출 가능
        * iCloud / iTunes 백업
        * Inbox
            * 외부 애플리케이션 전달 자료 저장
            * iCloud / iTunes 백업
    * Documents/Inbox
        * 앱이 외부 엔티티에서 열도록 요청한 파일에 접근한다.
        * 특이 메일은 앱과 관련된 이메일 첨부 파일을 inbox에 저장한다.
        * Document interaction controllers는 파일을 파일 app에 배치할 수도 있다.
        * 다른 앱을 통해 전송받은 파일이 저장되는 디렉토리
        * 파일을 읽거나 삭제는 가능하지만 추가 및 수정은 안된다.
        * 사용자가 이 디렉토리의 파일을 편집하려고 하면 변경하기 전에 디렉토리에서 앱을 이동해야한다.
        * 유저가 직접 생성 불가
        * iCloud / iTunes 백업 가능
    * Library
        * 사용자 데이터 파일이 아닌 파일의 최상위 디렉토리
        * 여러 표준 하위 디렉토리 중 하나에 파일을 저장한다
        * iOS app은 일반적으로 Application support와 Caches의 하위 디렉토리를 사용
        * 사용자 지정 하위 디렉토리 생성 가능
        * 사용자에게 노출시키지 않으려는 파일에는 라이브러리 서브 디렉토리를 사용해야한다.
        * 앱에서 사용자 데이터 파일용으로 이러한 디렉토리를 사용하지 않아야 한다.
        * 라이브러리 디렉토리의 Contents (Caches 서브 디렉토리 제외)는 iCloud / iTunes에 의해 백업된다.
    * Library/Application Support
        * 앱의 기능 관리를 위해 지속적으로 관리해주어야하는 파일을 저장하는 경로
        * CoreData 기본 저장 경로
        * 핸드폰 기기 내에 앱 폴더(sandbox)가 생기고, 사용자는 Application Support는 열어볼 수 없다.
        * Document는 앱에서 허용했을 경우에만 접근 가능하다.
        * 당연히 개발자 입장에서도 Application Support에도 접근 가능하다.
    * Library/Caches
        * 앱의 동작 속도, 데이터 절약 등을 위해 사용하는 공간
        * 쉽게 재생성하고 다운로드 할 수 있는 파일만 저장
        * 디스크 공간이 부족하거나 시스템 복원의 경우 시스템에 의해 자동으로 파일이 삭제될 수 있는 디렉토리
        * 삭제되어도 무방한 파일만 저장하자.
        * iCloud / iTunes 백업 불가
    * tmp
        * 앱 실행 사이에 유지할 필요가 없는 임시파일을 저장하는 곳
        * 더이상 필요하지 않으면 앱에서 이 디렉토리의 파일을 삭제해야 한다.
        * 앱이 실행되고 있지 않을 때도 시스템에서 이 디렉토리를 제거할 수 있다.
        * iCloud / iTunes 백업 불가

**[FileManager]**

* 문자열을 담은 .txt 파일을 생성
```swift
let fileManager = FileManager.default

// 디렉토리 경로
let applicationSupportURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
let tmpURL = fileManager.temporaryDirectory

// 생성할 파일 경로
let fileURL = tmpURL.appendingPathComponent("abc.txt")

// 삽입할 문자열
let text = NSString(string: "Hello, Files!")

do {
    try text.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8.rawValue)
    print(fileURL)
} catch {
    print("실패")
}
```

* 파일을 읽어서 출력하기
```swift
do {
    let dataFromPath: Data = try Data(contentsOf: fileURL) // URL을 불러와서 Data타입으로 초기화
    let text: String = String(data: dataFromPath, encoding: .utf8) ?? "문서없음" // Data to String
    print(text) // 출력
} catch let e {
    print(e.localizedDescription)
}
```
* 파일을 삭제하기
```swift
do {
    try fileManager.removeItem(at: fileURL) // 삭제할 파일의 경로
    print(fileURL)
} catch {
    print("실패")
}
```

---

- 참고링크
    - https://jinshine.github.io/2018/12/06/iOS/ContentOffset%EA%B3%BC%20ContentInset/
    - https://www.raywenderlich.com/16906182-ios-14-tutorial-uicollectionview-list
    - https://shoveller.tistory.com/entry/WWDC20-Lists-in-UICollectionView
    - https://developer.apple.com/videos/all-videos/?q=collectionView
