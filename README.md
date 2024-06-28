本项目是一个Android与flutter的混合开发项目
实现了作为音乐播放器的各个基本功能
后端使用NeteaseCloudMusicApi作为后端平台进行Api调用，
此项目采用混合开发技术，其中原生页为首页，播放页，播放列表页，为保证流畅度所以音乐播放和服务都采用原生开发其余基本上都是flutter页面，利用通道来进行两端通信。
flutterEngine采用FlutterEngineGroup；采用的flutter状态管理框架是Getx
项目中还有许多未完成的模块后续有时间会一一添加：评论模块、动态模块、歌单模块、和个人页面的各个小模块...
项目总结：


项目缺点：
1.由于本人第一次做这种对我来说比较大的项目导致前期工作没有做好使项目很杂乱没有使用MVP或MVVM架构数据绑定也没有用的很好只用了他进行全局存储和页面自动更新的功能
2.没有打上注释
3.flutter说是用了Getx但还是有的界面用了有的界面没有，有的界面还是混合使用的，没有统一，
在开始做之前直接使用了FlutterEngineGroup导致我在使用后因为flutter的Isolate不共享内存的原因我规定了一个全局的GetxController导致他还是被分了模块，只有同一个entry-point才会有效
这导致我在开发阶段弄了不少麻烦
4.对于屏幕适配与屏幕组件间距没有统一配置
5.对于语言方面不是很得心应手有的地方写的就....
6.数据库缓存没有做
7.主题的模式切换时会导致崩溃
8.有些地方没有做区间处理

项目难点：
原生端：
1.因为一开始对json数据解析的不熟练导致在配置数据浪费了很多时间
2.对于网络的Api请求在获取个人信息时因为那时不知道要获取Cookie然后也拖慢开发进度
3.对于几个播放模式的切换是花费了我非常多的时间的，刚开始做完时发现点击的模式切换倒致我的旋转唱片会因为数据更新导致唱片重置，这个问题困扰了许久
后来的解决办法是在切换时记录旋转角度再次重置时就把角度重新赋给唱片，但是发现再快速点击时唱片会卡主感觉原因主要是频繁的数据更新导致他卡住了
后来想到的就是我切换模式时我当前的又不需要更新我频繁的找资料后可以用getItemPosition来规定页面是否需要更新，后发现就算限制了他当前页还是有点卡原因还是因为他其他页更新的有点多把他带卡了后来我就规定只让viewPager两边的需要预览唱片更新其他都不更新
等到歌曲切换时才更新就解决了，由于第一次做这种模块所以花费了大量时间，我在网上还找不到解决办法
4.播放列表的展开和收缩：这个view是我自己做的一个可以弹出和收缩的view在手动操纵收起和展开时的问题也是特别多，当时写了特别长的代码但还是不能解决。
flutter端：
1.在进行通信时就算发送不同的信息却还是只能显示第一次点击时显示的页面,并没有更新数据，后来是用didUpdateWidget来进行更新解决
2.使用NestedScrollView时要用两层tabbar，但在放置的时候出现了问题，导致无法嵌套滑动，内部划动无法带动外部滑动后来用三个CustomScrollView分开装才解决
3.在使用flutterEngine时FlutterFragment.withCachedEngine(OTHER_PAGE).build();时发现图层出现混乱没有应用在Android的规定图层里，flutter页直接置顶出现挡住了android的播放控制器
查看资料时没有找到这个原因后来发现说是RenderMode.texture和RenderMode.surface的问题
...

项目页面展示：

![a](https://github.com/Pass11223344/MusicPlayerApp/assets/138595065/87f2dfa3-f77d-4338-80dd-06efdb375a0b)
![b](https://github.com/Pass11223344/MusicPlayerApp/assets/138595065/41e21eb6-d908-406a-9c34-148c9c643ac7)
![c](https://github.com/Pass11223344/MusicPlayerApp/assets/138595065/2db54ff4-ce55-4d91-800e-16161f97fc1d)
![c (2)](https://github.com/Pass11223344/MusicPlayerApp/assets/138595065/9a875bae-e8af-448d-9706-92e549f9f0c7)
![d](https://github.com/Pass11223344/MusicPlayerApp/assets/138595065/6b8e1d82-8d2e-4627-87a2-c47c1d94419f)
![e](https://github.com/Pass11223344/MusicPlayerApp/assets/138595065/5aac2823-b28d-4a0a-9c5c-27da98607dd2)
![f](https://github.com/Pass11223344/MusicPlayerApp/assets/138595065/b5b46244-4b9e-4b3f-82c4-28986dc18e73)
![g](https://github.com/Pass11223344/MusicPlayerApp/assets/138595065/ad1ff71e-512f-477f-82a2-38b4ed169911)
![h](https://github.com/Pass11223344/MusicPlayerApp/assets/138595065/083a2d3a-99fa-4388-9f30-db9fb38a1043)
![i](https://github.com/Pass11223344/MusicPlayerApp/assets/138595065/bbe8e5ca-f21b-42ea-bd70-1f276137bfb8)
![j](https://github.com/Pass11223344/MusicPlayerApp/assets/138595065/bf73e11d-309d-4f19-9347-3fdc5c418402)
![k](https://github.com/Pass11223344/MusicPlayerApp/assets/138595065/3d9e90cd-fccf-4b49-a30b-6528728084e6)
![l](https://github.com/Pass11223344/MusicPlayerApp/assets/138595065/a3181181-3c1b-44bd-90c3-087aa67a927e)
![m](https://github.com/Pass11223344/MusicPlayerApp/assets/138595065/066581be-65c8-4041-9c0a-10d5eb89f7f4)
![n](https://github.com/Pass11223344/MusicPlayerApp/assets/138595065/db3ae9c5-c5a7-408f-b118-e3b00fb55af9)
![o](https://github.com/Pass11223344/MusicPlayerApp/assets/138595065/e2ac554b-cf2c-46a4-82dc-5a0acff4142d)
![p](https://github.com/Pass11223344/MusicPlayerApp/assets/138595065/33d81df6-fff0-444a-bb18-675431a86a54)
![q](https://github.com/Pass11223344/MusicPlayerApp/assets/138595065/452c9795-1b5b-42ae-a6d9-6dc708bb2523)
![r](https://github.com/Pass11223344/MusicPlayerApp/assets/138595065/676bab69-216f-47c2-8f3f-275ae6e32654)



