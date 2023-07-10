# 220217 Dropbox, RxSwift, SPM, DispatchGroup
# TIL (Today I Learned)

2월 17일 (목)

## 학습 내용

- 동기화 메모장 STEP3 진행
    - SwiftyDropbox 사용해보기
- RxSwift - 개념잡기

&nbsp;

## 고민한 점 / 해결 방법

**[RxSwift - 개념잡기]**

* 비동기로 생긴 데이터를 어떻게 반환값으로 만들까?
    * 이런 문제를 해결해주는 유틸리티가 나오게 된다.

![](https://i.imgur.com/MK6zF9J.png)

* ### RxSwift는?
    * 비동기적으로 생기는 데이터를 completion 같은 클로저를 통해서 전달하는 것이 아니라 반환값으로 전달하기 위해 만들어진 유틸리티이다.

![](https://i.imgur.com/HeEpNPn.png)

* Observable 타입으로 감싸서 반환하면 나중에 생기는 데이터가 된다.
* 나중에 생기는 데이터(Observable)을 사용할 때에는 subscribe를 호출하면 된다.
* 그럼 거기에 이벤트가 오는데, 종류는 `next`, `completed`, `error` 총 3가지이다.
* 데이터가 전달되었을 때는 `next` 케이스로 오고, 데이터가 전달되고 끝났을 때는 `completed` 케이스로 온다.


### subscribe

![](https://i.imgur.com/GjTRynF.png)

* subscribe는 `disposable`을 반환하고 있는데, 이게 뭐냐면 동작을 중간에 취소 시킬 수 있는  `dispose()`를 호출할 수 있다.
* 위처럼 호출해준다면, 다운로드를 하라고 시켜놓고 dispose를 하게되니 버튼을 눌러도 activityIndicator만 돌아가고, 다운로드는 취소되어 동작하지 않게 된다.

![](https://i.imgur.com/SKJ0Wap.png)

* ⭐️ 여기서 `순환참조 문제`가 발생할 수 있는데, `subscribe` 같은 경우에는 `completed`나 `error`에서 `클로저가 종료`되기 때문에, 작업후 작업이 완료되었다고 알려주게 되면(`onCompleted()`) 해당 문제는 해결된다.

**[배울 것]**

* 비동기로 생기는 데이터를 `Observable`로 `감싸서 리턴`하는 방법

![](https://i.imgur.com/TnCVUny.png)

```swift
func rxswiftLoadImage(from imageUrl: String) -> Observable<UIImage?> {
        return Observable.create { seal in
            asyncLoadImage(from: imageUrl) { image in
                seal.onNext(image)
                seal.onCompleted()
            }
            return Disposables.create()
        }
    }
```

![](https://i.imgur.com/66rmTfw.png)

* `Observable.create()` 만들고 들어가는 인자로 클로저가 하나 들어가는데, 뭔가(`emitter`)가 들어간다. 그리고 나서 클로저 내부에 `onNext()` 메소드로 데이터를 전달한다. 데이터는 `여러개를 전달`할 수도 있다.
* 이후 `onCompleted()`로 데이터 전달이 끝났다고 알린 후 반환한다.
* 그리고 마지막으로 `Disposables.create()`를 `호출하여 반환`하면 된다.

![](https://i.imgur.com/o1BazFV.png)

* `Observabel.create()`를 한다.
    * `task`를 만들어서 `dataTask를 호출`하고, 에러가 발생한다면 `onError로 에러를 전달`하고, data가 정상적으로 바인딩 된다면 `onNext로 데이터를 전달`하고 `onCompleted()를 실행`한다.
    * 이후 return에서 Disposables.create()를 호출할 때 `task.cancel()`을 호출해준다.
        * 아마 dispose를 했을 때 호출 되는 구현부인 듯 하다.
* Observable의 생명주기
    * `create` 
    * `subscribe`  <- 이때 Observable로 create한게 동작한다.
    * `onNext`
    * `onCompleted` / onError
    * `Disposed`
* 이렇게 동작이 끝난 `Observable`은 다시 **✨재사용할 수 없다.✨**

![](https://i.imgur.com/IRfHnAr.png)

* 어떻게 동작하는지는 중간에 debug를 호출해주면 로그를 확인할 수 있다.

![](https://i.imgur.com/5FPRnFz.png)

* Observable로 오는 데이터를 받아서 처리하는 방법

![](https://i.imgur.com/3lfeneK.jpg)

* `subscribe`는 클로저를 개행하면 `이벤트를 처리`할 수 있고, subscribe() 호출만 한다면 값만 전달받을 수도 있다.

---

**[SPM으로 라이브러리 추가하기]**

> `Targets` -> `General` -> `Frameworks, Libraries, and Embedded Content` -> `+`

![](https://i.imgur.com/MxRxY4R.png)

> `Add Package Dependency...` 를 클릭

![](https://i.imgur.com/3iPfMsZ.png)

> 사용하고 싶은 라이브러리의 주소를 기입한다.

![](https://i.imgur.com/YGUZll3.png)

> 설치 시 원하는 버전, 브랜치 및 커밋을 설정할 수 있다. 이 후 원하는 packge product를 골라서 Finish 까지 하면...

![](https://i.imgur.com/ejnhQOL.png)

> `SwiftyDropbox`가 정상적으로 설치된 것을 확인할 수 있다.

---

**[SwiftyDropbox - 프로젝트 설정하기]**

> 아래 프로젝트 설정하는 튜토리얼을 참고하여 진행하였다.
> https://github.com/dropbox/SwiftyDropbox#configure-your-project

> 먼저 Info.plist 파일을 수정해주어야 하는데, 그 전에 dropbox에 app을 등록해야 한다. 로그인 후 apps에 들어가면 아래와 같은 버튼이 있다.

![](https://i.imgur.com/xBg2zZc.png)

> 이후 필수 문항을 선택, 입력 후 create app 버튼을 눌러 만들어주면 된다.

![](https://i.imgur.com/mqSylZ5.png)

> 그러면 App key가 발급되는데, 이걸 이제 Info.plist를 수정하는데 활용할 것이다.

![](https://i.imgur.com/QuHdJk5.png)

튜토리얼에서 하라는데로 `Info.plist`를 예시와 같이 수정해준다.

```
<key>LSApplicationQueriesSchemes</key>
    <array>
        <string>dbapi-8-emm</string>
        <string>dbapi-2</string>
    </array>
```

> 아까 만들고 얻은 App key를 `db-` 뒤부터 기입해주면 된다.
```
<key>CFBundleURLTypes</key>
    <array>
        <dict>
            <key>CFBundleURLSchemes</key>
            <array>
                <string>db-<APP_KEY></string>
            </array>
            <key>CFBundleURLName</key>
            <string></string>
        </dict>
    </array>
```

![](https://i.imgur.com/ltONNs1.png)

> 이후 코드로 돌아가서 `AppDelegate`에 `DropboxClient` 인스턴스를 초기화 해준다.

```swift
import SwiftyDropbox

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    DropboxClientsManager.setupWithAppKey("<APP_KEY>")
    return true
}
```

> 그리고 `SceneDelegate`에 아래와 같은 메소드를 추가한다. 인증이 모두 완료된 후 redirection을 처리해준다.

```swift
import SwiftyDropbox

func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
     let oauthCompletion: DropboxOAuthCompletion = {
      if let authResult = $0 {
          switch authResult {
          case .success:
              print("Success! User is logged into DropboxClientsManager.")
          case .cancel:
              print("Authorization flow was manually canceled by user!")
          case .error(_, let description):
              print("Error: \(String(describing: description))")
          }
      }
    }

    for context in URLContexts {
        // stop iterating after the first handle-able url
        if DropboxClientsManager.handleRedirectURL(context.url, completion: oauthCompletion) { break }
    }
}
    }
```

> 이후 맨처음에 시작하는 뷰에 로그인을 해서 인증 토큰을 받아오는 작업을 추가한다. 이번 프로젝트 같은 경우 UISplitViewController를 사용했는데, rootView인 SplitViewController에서는 해당 작업이 정상적으로 뜨지않았다. (이유는 찾지 못했다.) 그래서 다른 UIViewController에서 진행해야하나.. 싶어서 UITableViewController의 viewDidLoad()에서 해당 작업을 실행해주니 로그인창이 정상적으로 떴다.

```swift
import SwiftyDropbox

func myButtonInControllerPressed() {
    // OAuth 2 code flow with PKCE that grants a short-lived token with scopes, and performs refreshes of the token automatically.
    let scopeRequest = ScopeRequest(scopeType: .user, scopes: ["account_info.read"], includeGrantedScopes: false)
    DropboxClientsManager.authorizeFromControllerV2(
        UIApplication.shared,
        controller: self,
        loadingStatusDelegate: nil,
        openURL: { (url: URL) -> Void in UIApplication.shared.open(url, options: [:], completionHandler: nil) },
        scopeRequest: scopeRequest
    )

    // Note: this is the DEPRECATED authorization flow that grants a long-lived token.
    // If you are still using this, please update your app to use the `authorizeFromControllerV2` call instead.
    // See https://dropbox.tech/developers/migrating-app-permissions-and-access-tokens
    DropboxClientsManager.authorizeFromController(UIApplication.shared,
                                                  controller: self,
                                                  openURL: { (url: URL) -> Void in
                                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                                  })
}
```

> 여기서 scopes라는 파라미터가 있는데, 이 부분은 앱이 Dropbox 계정 정보를 보고 관리할 수 있도록 `권한의 범위`를 뜻한다. 아까 App key를 얻었던 곳에서 `Permissions` 탭을 클릭하면 `Account의 정보`가 나온다. 따라서 필요한 Account를 `scopes`에 넣어주면 되겠다.

![](https://i.imgur.com/1O8bJws.jpg)


> 이 다음에 API에 호출할 `DropboxClient 인스턴스`를 생성한다.

```swift
import SwiftyDropbox

// Reference after programmatic auth flow
let client = DropboxClientsManager.authorizedClient
```

> `client`를 통해 `업로드`와 `다운로드`를 진행할 수 있다.

```swift
let fileData = "testing data example".data(using: String.Encoding.utf8, allowLossyConversion: false)!

let request = client.files.upload(path: "/test/path/in/Dropbox/account", input: fileData)
    .response { response, error in
        if let response = response {
            print(response)
        } else if let error = error {
            print(error)
        }
    }
    .progress { progressData in
        print(progressData)
    }

// in case you want to cancel the request
if someConditionIsSatisfied {
    request.cancel()
}
```

```swift
// Download to URL
let fileManager = FileManager.default
let directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
let destURL = directoryURL.appendingPathComponent("myTestFile")
let destination: (URL, HTTPURLResponse) -> URL = { temporaryURL, response in
    return destURL
}
client.files.download(path: "/test/path/in/Dropbox/account", overwrite: true, destination: destination)
    .response { response, error in
        if let response = response {
            print(response)
        } else if let error = error {
            print(error)
        }
    }
    .progress { progressData in
        print(progressData)
    }


// Download to Data
client.files.download(path: "/test/path/in/Dropbox/account")
    .response { response, error in
        if let response = response {
            let responseMetadata = response.0
            print(responseMetadata)
            let fileContents = response.1
            print(fileContents)
        } else if let error = error {
            print(error)
        }
    }
    .progress { progressData in
        print(progressData)
    }
```

> 두가지의 공통점은 파일을 다운로드하고, 업로드할 때 `경로`가 필요하다는 점이다. 메모장 프로젝트의 경우 CoreData를 통해서 메모를 관리하고 있기 때문에 `백업`의 형태로 CoreData의 경로를 얻어내서 `.sqlite`, `.sqlite-shm`, `.sqlite-wal` 총 3개의 파일을 업로드 및 다운로드 해주도록 구현해주었다.

> 업로드, 다운로드 모두 파일을 덮어쓸건지에 대한 옵션이 있으니 자세한건 아래 도큐먼트에서 검색해보면 되겠다.

https://dropbox.github.io/SwiftyDropbox/api-docs/latest/index.html

---

**[SwiftyDropbox - download가 끝나는 시점에 뷰를 업데이트 하기]**

> 다운로드가 끝난 후 CoreData를 fetch를 하고 TableView를 reload를 해주고 싶었으나 실패했었다.

* `이유` 파일이 여러개가 존재하여, 여러개의 파일을 다운로드 하기 위해 반복문을 돌리고 있었으나, fetch와 reload를 for-in문 내부에서 해주고 있어서, 뷰가 업데이트 될 때가 있고, 안되기도 하는 현상이 나타났다.
* `해결` 그래서 `for-in문이 종료된 시점`에 `fetch`를 하고 view를 reload를 해주기 위해, 다운로드가 모두 완료되는 시점을 `DispatchGroup`를 활용하여 `추적`하고, 반복문에서 시작되었던 다운로드 작업이 모두 끝나게 되면 아래 뷰를 다시 설정하도록 코드를 수정하였다.

```swift
func download(_ tableViewController: NotesViewController?) {
    let group = DispatchGroup() // 그룹 생성
    for fileName in fileNames {
        let destURL = applicationSupportDirectoryURL.appendingPathComponent(fileName)
        let destination: (URL, HTTPURLResponse) -> URL = { _, _ in
            return destURL
        }
        group.enter() // 작업 시작
        client?.files.download(path: fileName, overwrite: true, destination: destination)
            .response { _, error in
                if let error = error {
                    print(error)
                }
                group.leave() // 작업 끝
            }
    }
    group.notify(queue: .main) { // 모든 작업이 끝난다면 ...
        PersistentManager.shared.setUpNotes()
        tableViewController?.tableView.reloadData()
        tableViewController?.stopActivityIndicator()
    }
}
```


---

- 참고링크
    - https://www.youtube.com/watch?v=iHKBNYMWd5I
    - https://github.com/dropbox/SwiftyDropbox
