# luaForAd

用触动精灵lua脚本刷各种广告，由后台下发个广告SDK任务，支持23种分辨率，支持水军，留存上报，留存可后台设置百分比，10多个平台广告同时刷，实时上报刷量数据

### QQ群 720098517 微信：15817321796  验证注明：luaforad

本脚本建议配合盘古后台系统，fakeapk hook 等工具使用。

|工具名称| 下载链接|备注|
|----|-----|---|
|盘古后台系统|https://gitee.com/kuangyufei/pangu|盘古系统后台|
|fakeapk|https://gitee.com/kuangyufei/fakeapk|比 008更强大的手机信息修改器|
|盘古VPN系统|https://gitee.com/kuangyufei/pangu_vpn|vpn自动选择，切换工具|
|盘古管理系统|https://gitee.com/kuangyufei/pangu_manage|实时查看各广告平台刷量数据，包括留存比例，水军量，转化率等等|


```
require "./inter/TSLib"
json = require('./inter/json')  
common = require('./inter/common')
pg_net = require('./inter/pg_net')
xsd = require('./inter/xsd')
yichu = require('./inter/yichu')
juyou = require('./inter/juyou')

gTaskIP = "88.88.88.88";
gImei = "8888888888"; -- 初始IEMI
isRunRemain = 0; -- 是否是运行留存的lua
isRunShuiJun = 0; -- 是否跑水军
function startTask()
	local flag = 0;
	local stockPath = "/mnt/sdcard/TouchSprite/lua/json/json_remain_device_info.json"
	local platformPath = "/mnt/sdcard/TouchSprite/lua/json/json_platform_info.json"
	local newDevicePath = "/mnt/sdcard/TouchSprite/lua/json/json_new_device_info.json"
	local newDevicePathBack = "/mnt/sdcard/TouchSprite/lua/json/json_new_device_info_back.json"
	common.delAllLog();
	common.kyInitPortarit();
	local loopTime = 10;
	if(1==pg_net.netPhoneLogin())then
		log("runMyApp-- -1","debug");	
		common.kyToast("登录后台失败",3);
		lua_restart();
	end;
	if(1==pg_net.netGetBlackIpList())then
		log("runMyApp--0","debug");	
		common.kyToast("请求Ip黑名单网络异常",3);
		lua_restart();
	end;
```





