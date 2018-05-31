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

# Osprey - PageFactory
PageFactory 是Osprey 推荐使用的统一化的页面实例化工厂。

### PageFactory 设计说明
OrienteBase 针对页面(ViewController)推荐采用统一的实例化方式，即从PageFactory工厂中实例化。通过工厂模式实例化页面，可以对页面做实例化前后拦截与重定向、生命周期管、生命周期监听、事件流控制等操作。本节的余下内容主要介绍PageFactory的具体设计。

![PageFactoryFlow](https://github.com/Oriente-iOS/Osprey/blob/master/PageFactoryFlow.png)

#### Tapable 的作用
* Tapable(事件流)用于分发其本身对应的事件。
* 每一个Tapable 是一类事件(TapableEvent)的控制中心。
* 例如PageTapable 对应处理 pageEvent 的事件(pageEvent 注册了页面生命周期相关的事件: PageLoaded, PageBecomeActive ...).
* `一类pageEvent 只支持8个互斥的事件 ！`
* pageEvent 使用类似于抽象工厂模式
* 通用事件流目前支持三种：

pageEvent|页面生命周期相关事件
---------|-------------
switchEvent|tabbar 切换相关事件
appEvent|应用生命周期相关事件

#### Filter 的作用

* Filter 用于在页面实例化前后做一些拦截并且响应页面Tapable分发的事件。
* Filter 分为PreFilter 与 PostFilter。
* PreFilter 在页面实例化之前调用，可以用来处理页面重定向。
* PostFilter 在页面实例化之后调用，一般用来处理Tapable分发的事件。

### PageFactory 相关 Api 设计说明

PageFactory 类

+(PageFactory*)defaultFactory;|类方法： 获取默认的页面工厂句柄
------------------------------|--------------------------
-(__kindof UIViewController*)intialPageWithClassNameString:(NSString*)classNameString withParams:(NSDictionary*)params;|根据类的名称与传入的参数返回对应的UIViewController的实例 @param classNameString  类名的字符串表示 @param params 字典类型表示的参数 @return 对应class的UIViewController的实例

>**注意事项**: 
>* 整个应用生命周期只需要实例化一次的页面，最好声明为单例页面，交由PageFactory来管理其生命周期
>* 声明单例页面 需要在该类的 @implementation 中声明 IsSingletonPage(YES) //默认为NO
>* PageFactory 通过construct 方法实例页面，同时可以实现属性的注入
>* PageFactory 支持自定义实例化方法，但是只允许传入一个参数 。传递的参数需要在params中声明。声明格式如下:在params 声明key值为 @"init" 对应的值为初始化化方法with后面的局部方法名 如果自定义方法为initWithContext: 那么@“init”对应的值为 @"context"初始化方法对应的参数对应的KEY为@“init”键对应的值, 如果初始化方法名为initWithDictionary: 那么忽略改键，直接将整个params作为参数传入初始化方法

>```
// 对应初始化方法为 (instanceType)initWithContext:(NSString)context;
{ @"init":@"context"
  @"context":@"dev"
}
```
>* PageFactory 支持页面属性的注入，在params中声明键值为属性名对应的字符串，键值所对应的内容便注入到属性中了

# Osprey - Router

Router 用于以URL的方式，实现界面路由。将路由协议与与协议对应的页面注册到配置文件中，在应用中通过相应的协议来找到对应的页面，并且通过Navigator 将页面展现出来。

### 路由协议设计

路由的协议设计参照了URL的协议标准，相当于URL的一个子集，格式如下。

```
路由协议格式

scheme://host/path1/path2/path3?key1=val1&key2=val

scheme: 必选

host: 必选

path: 可选

query: 可选

示例  cashalo://user/setting?userId=20180101
```

### 路由配置文件

每一应用都需要一个路由配置文件。 路由配置文件的后缀为".properties"; 需要主动注册到 BaseRouter 中。配置文件的格式要求示例如下
```
#注释格式
#对应寻址的URL协议为cashalo://user/settings/changepassword
#采用 "." 做路径的区分 按照 scheme.host.pathComponent0.pathComponent1 的格式注册协议
cashalo.user.settings.changepassword = CAUserSettingChangePwdPage
```
### 默认路由配置项
Osprey 为每个应用提供了一些默认配置项，配置项的路由协议如下，具体的应用示情况实现相关路由的配置。
协议|KEY的表示|备注
-----|-----|-----
base://tabviewcontroller|base.tabviewcontroller| 如果应用使用了OrienteBase.TabController的Tabbar需要按照该协议注册继承 TabViewController 的子类到路由的 .properties 文件中


# Osprey - TabController

TabController 是为整个Oriente工程设计的自定义TabBar 控制器。

### 设计说明

* TabController 的构成如下图所示， 整个页面的容器放在TabViewController 中， 一个TabViewController 承载多个BaseNavigatorViewController。 
* TabController类负责下方TabBar的显示，TabBar下方TabItemView的点击事件响应于页面切换。
* TabItem类表示每个TabBar的子项，每个TabItem都包含一个TabItemView, BaseNavigatorViewController.
* TabItem类的配置是通过TabItemConfiguration完成。

![TabController](https://github.com/Oriente-iOS/Osprey/blob/master/TabController.png)

### 使用说明与注意事项

#### TabViewController类的使用
* TabViewController 类声明为虚基类(必须通过继承使用)
* 一个App 需要且只需要实例一个TabViewController子类，作为业务页面的容器。最好该类声明为单例页面，通过PageFactory管理
* 子类可以通过覆写 customizeTabContainerView: 方法，对TabBar的视图样式进行定制

#### TabItemConfiguration的配置说明
TabItemConfiguration 用于为TabItem进行配置
* 配置 TabItemView 需要的文本和icon样式
* 配置点击对应Item 展现的基页面(一般声明为单例)
* 分配TabItem的categoryID 用于检索TabItem使用

#### TabController的使用说明与注意事项
TabController 组合生成的TabViewController实现类与对应的TabItemConfigurations，已完成整个TabController 的构建TabController 支持配置插件，插件遵循 TabControllerTabSwitchProtocol 协议，用来从外部控制TabController 事件的切换 `TabController 声明了 extern 的变量 tabBarHeight，必须在业务工程中实现，用来定义整个应用的TabBarHeight`

#### RACChannel的原理图
![RACChannel](https://github.com/Oriente-iOS/Osprey/blob/master/RACChannel.png)

# License
Ortrofit is released under the MIT license. See LICENSE for details.
