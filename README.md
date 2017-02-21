# hello-girl-iOS
练习iOS，疑问：[UIImage imageWithData:]会把图片数据保存在手机磁盘么？  
场景：用一个UIImageView展示图片，图片不断从服务器获取，不断覆盖UIImageView的``image``属性。  
那么问题来了：每一张图片是通过URL获取data，然后使用``[UIImage imageWithData:]``实例化一个UIImage对象，最后把这个对象复制给UIImageView的``image``属性。这样会不会导致设备的磁盘（注意不是内存）爆满？  
**目前还在测试中，尚无结论，有待进一步研究，欢迎讨论**
###说明
此Demo的后台数据使用一个[小爬虫](https://github.com/blackmatch/hello-girl)实现，仅供学习使用。
###预览
![record](./readme/record.gif)
