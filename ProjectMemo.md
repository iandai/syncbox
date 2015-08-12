SyncBox开发经历

===========SyncBox开发需求经历

重新定义需求，面向的是有基础编程能力的人
A gem that can sync data to s3 using SDK. 
There is already command line tools, so I am going for gem used in other application. 

开始做SyncBox是因为需要完成一个任务，将本地的代码同步到S3中。
于是打算顺手做一个gem，方便使用。
完成一小半之后，觉得可以增加备份到其他云存储空间功能，于是将名字由syncs3改称了syncbox。

后有发现其他的许多工具已经实现的很好，决定放弃原先要做成syncbox的打算，改名回到s3box。

后又发现一个可能的需求：同一文件每次上传必须覆盖原文件，这会增加许多网络流量。
找到rsync可以实现增量上传。
但是最后发现rsync在S3上无法使用，因为S3上的文件，只能存在或者不存在，不能进行增量操作。

又发现解决此问题的一个workout，先上传到EC2，再上传到S3。因为EC2到S3不花流量费，就能够减少总体流量费用。
因为S3不再对网络流量收费，因而不再有必要使用rsync。

最后决定研究哪些现有工具可以实现rsync到s3。
duplicity是可以实现的。
在本地将大文件分割成较小的文件，再分别生成etag，上传到s3。
遇到文件更新，则只更新内容被修改的那部分。

===========rsync与s3
AWS的S3使用自己特殊的协议进行传输，写入一个文件，要么0，要么全部。
因而，无法直接使用rsync传输到s3。

local to ec2 to s3
对于文件update就会浪费网络了。
浪费网络不要紧，要紧的是要花钱，所有就有了一个折衷方案。先传送到EC2，再传输到S3.

在2011年的时候，S3取消了inbound data transfer fee. 于是，这个折衷方案便不再必要了。
https://aws.amazon.com/s3/pricing/
http://aws.typepad.com/aws/2011/06/aws-lowers-its-pricing-again-free-inbound-data-transfer-and-lower-outbound-data-transfer-for-all-ser.html?utm_source=feedburner

===========使用rsync节约网络流量
The rsync algorithm 简单清晰原理资料
http://rsync.samba.org/tech_report/
简单步骤：
1 远程的文件，按照字节长度S，分成若干段；对每一段进行Rolling checksum的计算，获得一个数据校验数值；
2 本地文件也按照字节长度S分段，对每段进行Rolling Checksum计算，获得一个数据校验数值；
3 远程文件的 任意一段字节S的数据校验数值与本地文件的一段字节相同的话，说明这段内容没有改变，不需要进行传输；
4 之所以能够证明两段相同，是因为Rolling Checksum是一种数据完整性的校验手段，类似MD5，只是相对简单，以节省时间。

===========SyncBox实现中参考的比较好的文献
Daemon功能
优化guard-daemon，提供daemon模式https://github.com/substantial/guard-daemon （有没有上传之类的，可暂不提供）
https://gist.github.com/sbusso/1978385

做checksum 再覆盖  
http://developers.appoxy.com/2010/05/md5-hash-of-file-in-ruby.html
http://gist.github.com/mattgaidica/2891945
https://gist.github.com/andrewbroman/3099117

参考dropbox 分析论文，写可能实现的方案
	然后呢，继续看那片dropbox的论文／继续寻找如何分开本地文件，然后上传倒s3
	dropbox分析论文： http://eprints.eemcs.utwente.nl/22286/01/imc140-drago.pdf