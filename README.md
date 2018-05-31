# Osprey
A compositive kit for iOS App pages management. From a new version to arrange the UIViewController and router.

# Osprey - Navigator
Navigator 为应用提供了通用的导航解决方案，包括导航的转场动画，转场手势，导航栈管理等。在使用导航相关功能时，NavigationController 需要继承 ALNavigatonController 以使用整个Osprey.Navigator 提供的功能。

### 与Navigator相关的常量
页面之间数据传递是通过PageFactory的params参数进行的。通过向 params 参数传入预置的KEY, 用于完成页面之间的路由与导航工作

|     常量名     |       备注       | 
|:--------------- |:---------------|
| kPageReuseFlag      | 不配置该KEY值 总是通过PageFactory 来取传入页面的实例配置该KEY值，并且传入@(YES), 会触发 findPageWhenReuse 回调(如果页面实现该方法)，`默认行为: 在当前导航栈中查找页面实例所属类为传入类的实例返回`|
| kPageReuseAssociateKey      | 通过读取该key的值，用户获取到当页面复用传入的相关信息 |
| kPageFromPage |通过读取该key值， 在当前页面获取到上一个页面的实例|
| kPagePushAnimated |通过配置该值，决定push 时的animation参数值|
| PageInjectionForbidden | 不配置该参数，允许对页面的属性进行注入;配置该参数并且配置值为@(YES), 禁止对页面属性进行注入 |

### 与转场相关的属性设置
对转场动画与手势的配置通过下表的两个属性进行自定义配置，如果不配置默认遵循的是系统的行为左滑PushFromLeftToRight

| UIViewController的扩展属性|       备注       | 
|:----------------------- |:---------------|
| animationTransition  | 转场动画样式 |
| interactiveTransition | 转场手势行为 |

### PageNavigatorProtocol 说明
Osprey.Navigator 支持页面导航的自定义行为，提供一个类方法和一个实例方法

|    协议方法               |       类别       | 备注 |
|:------------------------ |:---------------|:-------------|
| -(BOOL)customizeNaivgatorImplement:(UINavigationController*)navigatorViewController tabController:(TabController*)tabController params:(NSDictionary*)params;  | 实例方法 |覆盖该方法，开发可以做自定义的Push 操作；返回 NO 表示走默认的push 行为；返回 YES 以阻断默认的行为|
| interactiveTransition | 类方法 |如果路由参数配置了PageReuse 的键值会回调该方法，如果覆盖了该方法，开发者可以自定义的PageReuse行为|

### UIViewController+PageRouter
UIViewController 扩展了路由的方法，提供了从协议查找，页面实例，push管理  整个操作的方法，建议开发使用该方法完成页面之间的路由操作

### 相关API说明


# License
Ortrofit is released under the MIT license. See LICENSE for details.
