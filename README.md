# Use runtime

## Method swizzling
Method swizzling 用于改变一个已经存在的`selector`的实现。通过改变`selector`在类的消息分发列表中的映射从而改变方法的调用。

### Q1: 为什么在 +laod 方法中完成。
在 `Objective-C` 的运行时中，每个类有两个方法都会自动调用。`+load` 是在一个类被初始装载时调用，`+initialize`是在应用*第一次调用该类的类方法或实例方法前调用*的。两个方法都是可选的，并且只有在方法被实现的情况下才会被调用。
**swizzling应该只在+load中完成。**

### 为什么使用dispatch_once
由于`swizzling`改变了全局的状态，所以我们需要确保每个预防措施在运行时都是可用的。原子操作就是这样一个用于确保代码只会被执行一次的预防措施，就算是在不同的线程中也能确保代码只执行一次。`Grand Central Dispatch` 的 `dispatch_once` 满足了所需要的需求，并且应该被当做使用 swizzling 的初始化单例方法的标准。

在运行时，类（Class）维护了一个消息分发列表来解决消息的正确发送。每一个消息列表的入口是一个方法（Method），这个方法映射了一对键值对，其中键值是这个方法的名字 selector（SEL），值是指向这个方法实现的函数指针 implementation（IMP）。 Method swizzling 修改了类的消息分发列表使得已经存在的 selector 映射了另一个实现 implementation，同时重命名了原生方法的实现为一个新的 selector。


参考: [Method swizzling](http://nshipster.cn/method-swizzling/)

## 属性，变量，方法。

通过 runtime 可以获取类的属性，变量方法，并且动态修改。代码仅展示对它们的获取方式。

## 归档

由于自定义的类并没有实现`NSCoding`协议，所以要对其归档，要自己实现`NSCoding`，重写`initWithCoder:` 和 `encodeObject:forKey:`。

`runtime` 实现过程:

1. 使用`class_copyIvarList` 方法获取到变量数组。
2. 遍历数组, 实现`encode`和`decode`。


## runtime 关联对象 AssociatedObject

为某个对象添加关联对象。【类因为某些情况无法创建子类实例 】

例如 catagery 中，为类添加属性。
