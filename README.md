# GYPHY Search App
GYPHY 검색 API를 활용한 iOS GIF 이미지 검색 어플리케이션

## Description
+ 최소 타겟 : iOS 14.0
+ CleanArchitecture + MVVM-C 패턴 적용
+ CoreData 프레임워크 사용으로 즐겨찾기 목록 유지
+ Storyboard를 활용하지 않고 코드로만 UI 구성
+ Pagination 구현
+ [개발 공수]()

## Feature
+ 이미지 검색 뷰
  + 카테고리별 검색 기능
  + 페이지네이션 - prefetching 방식
+ 디테일 뷰
  + 즐겨찾기 추가/제거
  + 액티비티 인디케이터
  + 기기 내부 파일 저장
+ 스크랩 뷰
  + 스크랩 목록 관리
  + 스크랩 데이터 제거

## Getting Start
> Swift, MVVM+C, CI/CD, Unit Test, CoreData, SnapKit, Alamofire, Toast-swift, RxCocoa, RxSwift, RxTest

## Issue & Reflection

### 1. Coordinator, Router 구성

기존 프로젝트에서는 코디네이터만 구성하여 활용을 하였으나, 이를 라우터도 분리하여 역할을 분담해보고 싶었습니다. 코디네이터는 ViewController 인스턴스를 구성하고 present 되는 순서(flow)를 결정, 라우터는 실질적인 present / dismiss 실행하면서 화면 전환의 구성을 모듈별로 분리하여 각자의 책임을 가능하도록 구성하고 싶었습니다.

하지만, UITabBar와 같은 전환 관련 Basic Frame이 끼이다 보니 분리하는 게 어렵다는 판단이 들었고, 여기에 대한 해결책으로 RIBs에 대해서 단초를 얻을 수 있었습니다. 라우터에 기반하여 뷰를 붙였다 떼는 아키텍쳐와 더불어 상태 관리에 있어서도 ReactorKit에 기반하여 이를 재구성할 계획입니다.

구성하면서 느낀 점은 현재와 같이 UITabBar만으로 구성된 단일한 상황에서는 modal 등 부모 코디네이터와 자식 코디네이터의 관계 등은 구상하지 않아도 되었기에 비교적 단순한 모양으로 구성되게 되었지만, 만약 이를 확장해서 화면 전환 flow가 복잡해진다면 해당 디자인 패턴을 활용하는 것이 더욱 더 좋은 방식으로 유지보수 할 수 있는 방법이라 생각합니다.

### 2. GIF Data Cache

GIF의 움직이는 프레임 기능 구현을 위해 git repo에 공개된 샘플 소스코드를 기반으로 적용했습니다. 그러나, 해당 코드에서는 데이터 캐싱을 따로 해주지 않아서 GIF 데이터 로딩이 끝난 데이터도 나중에 다시 확인하면 로딩을 또 기다려야했습니다. 다시 데이터를 받아오는 과정에 있어서 메모리의 사용과 함께 스크롤 버벅임도 상당히 심했습니다. 문제해결을 위해 해당 소스코드에 이미지 캐싱 기능을 넣어줬습니다. 싱글턴으로 구성한 이미지 캐싱 덕분에 최초에 새로운 GIF데이터를 호출할 때만 스크롤이 딜레이되고 이후에는 딜레이 현상이 없어졌습니다.

```swift
final class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()

    private init() {}
}
```

콜렉션 뷰의 GIF 이미지를 구성하고 셀을 그리는 과정을 본래는 모두 main 스레드에서 처리했었습니다. 하지만, 그리는 데에 한 가지 스레드에서 모든 일을 수행하다 보니 딜레이가 발생하였습니다. 따라서, 추가적으로 setup에서 멀티쓰레딩 처리을 해줌으로써 스크롤 딜레이를 개선했습니다.

```swift
func setup(gifItem: GIFItem, indexPath: Int) {
        cellView.indicatorAction(bool: true)
        DispatchQueue.global().async { [weak self] in
            let image = UIImage.gifImageWithURL(gifItem.images.preview.url)
            DispatchQueue.main.async {
                self?.cellView.imageView.image = image
                self?.cellView.indicatorAction(bool: false)
            }
        }
    }
```

global(background) 스레드에서 gifImageWithURL() 메서드를 통해 우선적으로 캐싱 여부를 확인하고 해당 URL에 대한 animatedImage 이미지를 프레임에 따라 array 형태로 구성하는 작업을 수행합니다. 그리고 main 스레드로 해당 view를 그리면서 안정적으로 불러올 수 있게 하였습니다.

코드는 [SwiftGif](https://github.com/swiftgif/SwiftGif/blob/master/SwiftGifCommon/UIImage%2BGif.swift) 레포를 참조하여 구성하였습니다.

### 3. Rx In/Out 형식의 ViewModel 구성 및 메서드 분리

```swift
protocol ViewModel {
    associatedtype Input
    associatedtype Output
    func transform(input: Input) -> Output
    var disposeBag: DisposeBag { get set }
}
```

패턴의 가장 큰 지향점은 모든 사용자 이벤트를 ViewModel로 넘겨 비즈니스 로직을 ViewModel에서만 처리하도록 하는 것이기 때문에 버튼의 탭 이벤트, 텍스트필드의 입력 이벤트 등을 전부 Input에 정의하고 View로 넘겨줄 데이터들을 Output에 정의하는 걸 목표로 합니다.

기존의 rx 기반으로 protocol을 구성하고 convert하는 메서드를 구현하였는데 작업을 하면서 기존 rx로 래핑되어 바인딩된 것이 아닌, BehaviorSubject 등으로 이루어진 별도의 스트림 프로퍼티들이 viewModel 내 존재하게 됩니다. 래핑을 추가적으로 구성하여 Reactive하게 처리할 것인지, 아니면 ReactorKit과 같은 상태 관리 서드파티를 활용하여 다음 프로젝트에서 개선하고자 합니다.

👉🏻 [ReactorKit으로 단방향 반응형 앱 만들기](https://www.youtube.com/watch?v=ASwBnMJNUK4)

### 4. 코어 데이터의 immutable 한 객체

### 5. 클린 아키텍쳐

### 6. Test Driving

## ScreenShot
![]()

## Video
