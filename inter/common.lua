---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
common = {}
-- 删除日志文件
-----------------------
-----------------------
function common.delAllLog()
	delFile("/mnt/sdcard/TouchSprite/log/debug.log")
end;

function common.kyToast(str,time)
	toast(str,time);
end;
function common.kySleep(count)
	mSleep(count*1000);
end;

function common.kyLog(str)
	log(str,"app");
end;

function common.kyWriteRemainDataInfo()
	filePhone = "/mnt/sdcard/TouchSprite/lua/json/json_Remain_Device_info.json";
	if(true == isFileExist(filePhone))then
		-- 这里是找到留存IP,保存留存信息用
	else
		common.kyToast("缺少配置文件,请检查....");
		lua_exit(); -- 退出脚本
	end;
end;

function common.kyFrontAppBid()
	repeat
		common.kySleep(1);
		bid,class = frontAppBid();
	until(nil ~= bid )
	return bid,class;
end;

function common.kyLuaExit()
	common.kyLog("kyLuaExit--0");
	lua_exit();
end;
function common.kyOpenApp(str)
	common.kyLog("kyOpenApp--0"..str);
	runApp(str);
	common.kySleep(1);
	common.kyLog("kyOpenApp--1"..str);
end;
-- 退出应用
function common.kyCloseApp(str)
	common.kyLog("kyCloseApp--0"..str);
	closeApp(str);
	common.kySleep(1);
	common.kyLog("kyCloseApp--0"..str);
end;

function common.kyInitLog()
	logfile = "/mnt/sdcard/TouchSprite/log/"..gYourAppPackage..".log";
	if(true == isFileExist(logfile))then
		delFile(logfile);
	end
	common.kyLog(gAppVersion);
end;

-- 移动
function common.kyMove(startX,startY,endX,endY)
	touchDown(startX, startY);    --在 (150, 550) 按下
	mSleep(30);
	touchMove(endX, endY);    --移动到 (150, 600)
	mSleep(30);
	touchUp(endX, endY);  --在 (150, 600) 抬起
	mSleep(300);
end;
-- 点击函数封装
function common.kyClick(x, y)
    touchDown(x, y)
    mSleep(30);
    touchUp(x, y)
end
function common.kyDataInit()
	log("kyDataInit--0","debug");
	common.kyToast("数据初始化 - 开始");
	local configPath = "/mnt/sdcard/TouchSprite/lua/json/json_context_config.json";
	if(true == isFileExist(configPath))then
		log("kyDataInit--1","debug");
		local configJson = readFileString(configPath);--读取配置文件
		gConfigTable = json.decode(configJson);   --json转table 
	else
		log("kyDataInit--2","debug");
		common.kyToast("缺少配置文件,请检查....");
		lua_exit(); -- 退出脚本
	end;
	gFileNewDevice = gConfigTable["info"]["jsonPath"]..gConfigTable["info"]["newDeviceName"]; -- 新设备	
	gFileRemainDevice = gConfigTable["info"]["jsonPath"]..gConfigTable["info"]["remainDeviceName"]; -- 留存设备	
	gReportUrl = gConfigTable["info"]["reportUrl"];
	
	local fileResolution = gConfigTable["info"]["jsonPath"]..gConfigTable["info"]["resolutionJsonName"]; -- 分辨率
	local fileFixData = gConfigTable["info"]["jsonPath"]..gConfigTable["info"]["fixJsonName"]; -- 固定数据
	local fileAppInfo = gConfigTable["info"]["jsonPath"]..gConfigTable["info"]["appInfoName"]; -- 应用列表	

	if(true == isFileExist(fileResolution))then
		log("kyDataInit--3","debug");
		resolustionJson = readFileString(fileResolution);--读取分辨率配置文件
		gResolustionTable = json.decode(resolustionJson);   --json转table 
	else
		log("kyDataInit--4","debug");
		common.kyToast("缺少配置文件,请检查....");
		lua_exit();-- 退出脚本
	end;
		
	if(true == isFileExist(fileFixData))then
		log("kyDataInit--5","debug");
		fixedDataJson = readFileString(fileFixData);	--固定数据文件
		gFixedDataTable = json.decode(fixedDataJson);    --json转table 
	else
		log("kyDataInit--5","debug");
		common.kyToast("缺少配置文件,请检查....");
		lua_exit(); -- 退出脚本
	end;
	
	if(true == isFileExist(gFileNewDevice))then
		log("kyDataInit--6","debug");
		newDeviceJson = readFileString(gFileNewDevice);	--固定数据文件
		gNewDeviceTable = json.decode(newDeviceJson);    --json转table 
	else
		log("kyDataInit--7","debug");
		common.kyToast("缺少配置文件,请检查....");
		lua_exit(); -- 退出脚本
	end;
	--[[
	if(1 == netGetAppInfo(appId))then
		common.kyToast("网络获取App信息失败,请检查....");
		return;
	end;
	--]]
	gYourAppPackagePath = gConfigTable["info"]["apkPath"]..gGetTaskTable["task"]["app"]["apkPath"];
	gYourAppId = gGetTaskTable["task"]["app"]["id"];
	gYourUserId = gGetTaskTable["task"]["app"]["userId"];
	gYourPlatformId = gGetTaskTable["task"]["app"]["platformId"];
	gResulotion = "supportResolution_"..gYourPlatformId;
	gYourAppName = gGetTaskTable["task"]["app"]["name"];
	gYourAppPackage = gGetTaskTable["task"]["app"]["packageName"];
	gYourAppToken = gGetTaskTable["task"]["app"]["token"];
	gYourAppUserId = gGetTaskTable["task"]["app"]["userId"];
	gYourAppPlatformId = gGetTaskTable["task"]["app"]["platformId"];
	
	local appConfig = gGetTaskTable["task"]["app"]["configure"];
	gYourAppConfig = json.decode(appConfig);    -- 将app 的配置信息json转table 
	gYourAppHomeInfo = gYourAppConfig["home"];
	
	gAppVersion = gConfigTable["info"]["version"];
	gAppshiqian = "org.tencent.android.kernel";
	gAppinstall = "com.android.packageinstaller";
	gAppTouchsprite = "com.touchsprite.android";
	gAppLauncher = "com.android.launcher";
	gWXH = "R720X1280"; -- 当前分辨率
	gDeviceType = getDeviceType(); -- 设备类型 0 == iPod Touch；1 == iPhone；2 == iPad；3 == 安卓设备；4 == 安卓模拟器
	gDirtyAppCount = 0; -- 安装了垃圾应用个数
	gAppList = {"com.android.browser",
			"com.cyanogenmod.filemanager",
			"com.android.gallery",
			"com.android.vending",
			"com.android.settings",
			"com.android.launcher",
			"com.google.android.gms",
			"com.android.providers.downloads.ui",
			"eu.chainfire.supersu",
			"me.haima.helpcenter",
			"me.haima.androidassist",
			"de.robv.android.xposed.installer",
			"com.touchsprite.android",
			"com.android.packageinstaller",
			gAppshiqian,
			gYourAppPackage,
			gAppPortarit
			}
	gFrozenScreenCount = 0;
	gCurrentBid = gYourAppPackage;
	common.kyToast("完成数据初始化");
	delFile("/mnt/sdcard/TouchSprite/log/"..gYourAppPackage..".log");
end;


function common.kyGetRemainDeviceInfo()
	if(true == isFileExist(gFileRemainDevice))then
		local remainDeviceJson = readFileString(gFileRemainDevice);	--留存数据文件
		gRemainDataSingleTable = json.decode(remainDeviceJson);    --json转table 
	else
		common.kyToast("缺少配置文件,请检查....");
		lua_exit(); -- 退出脚本
	end;
end;
function common.kyGetNewDeviceInfo()
	common.kyLog("kyGetNewDeviceInfo--0");
	if(true == isFileExist(gFileNewDevice))then
		common.kyLog("kyGetNewDeviceInfo--1");
		newDeviceJson = readFileString(gFileNewDevice);	--新设备数据文件
		gNewDeviceTable = json.decode(newDeviceJson);    --json转table 
	else
		common.kyLog("kyGetNewDeviceInfo--2");
		common.kyToast("缺少配置文件,请检查....");
		lua_exit(); -- 退出脚本
	end;
	common.kyLog("kyGetNewDeviceInfo--3");
end;

function common.kyHint()
	hint = gYourAppName;
	if( isRunRemain == 1 )then
		hint = hint .. "存量";
	else
		hint = hint .. "增量";
	end;
	if(isRunShuiJun == 1)then
		hint = hint .. "水军脚本";
	else
		hint = hint .. "赚钱脚本";
	end;
	common.kyToast("当前在跑"..hint);
end;

-- 卸载所有垃圾APP
function common.kyUninstallDirtyAppByLua()
	common.kyLog("kyUninstallDirtyAppByLua--0");
	closeApp(gYourAppPackage);--先把自己给关了
	uninstallApp(gYourAppPackage);
	pkns = getInstalledApps(); 
	for key, value in ipairs(pkns) do  
		flag = 0
		for defaultkey, defaultvalue in ipairs(gAppList) do   
			if( value == defaultvalue ) then
				flag = 1;
				break;
			end;
		end;
		if flag == 0 then
			common.kyLog("kyUninstallDirtyAppByLua--1--"..value);
			closeApp(value); -- 先关闭再卸载
			uninstallApp(value); -- 卸载
		end;
	end  
	common.kyLog("kyUninstallDirtyAppByLua--4");
end;
function common.kyLuaRestart()
	common.kyLog("kyLuaRestart--0");
	common.kyUninstallDirtyAppByLua();
	closeApp(gYourAppPackage);
	uninstallApp(gYourAppPackage);
	lua_restart();
	common.kyLog("kyLuaRestart--1");
end;
-- 初始化自己的应用，先卸载，再安装，确保token干净之身
function common.kyInitPortarit()
	appPortaritPath = "/mnt/sdcard/TouchSprite/res/apk/screen_portait.apk"
	gAppPortarit = "kuang.jun.qing";
	uninstallApp(gAppPortarit); -- 卸载
	if(true == isFileExist(appPortaritPath))then
		install(appPortaritPath); -- 安装应用
	else
		common.kyToast("包不存在....");
		lua_exit();; -- 退出脚本
	end;
end;

function common.kyInitMyApp()
	common.kyLog("kyInitMyApp--0--"..gYourAppPackage);
	common.kyLog("kyInitMyApp--1");
	common.kyToast("正在卸载本应用");
	uninstallApp(gYourAppPackage); -- 卸载
	common.kySleep(1);
	common.kyLog("kyInitMyApp--2");
	if(true == isFileExist(gYourAppPackagePath))then
		common.kyLog("kyInitMyApp--3");
		common.kyToast("正在安装本应用");
		install(gYourAppPackagePath); -- 安装应用
		common.kySleep(1);
	else
		common.kyLog("kyInitMyApp--4");
		common.kyToast("安装包不存在...."..gYourAppPackagePath);
		lua_exit();; -- 退出脚本
	end;
	common.kyLog("kyInitMyApp--5");
end;
-------------------------------------------------------------------------------------------------
-- 判断类相关操作
-----------------------------------------------------------------------------------------------
-- 获取当前分辨率信息
function common.isSupportResolution()
	return true;
	--[[ 
	common.kyLog("isSupportResolution--0");
	local width = gNewDeviceTable["device"]["width"];
	local height = gNewDeviceTable["device"]["height"];
	gWXH = "R"..width.."X"..height; -- 全局变量
	local supportCount = 1;
	common.kyToast("当前分辨率"..gWXH,10);
	common.kyLog("isSupportResolution--1--"..gWXH);
	

	
	repeat
		local fenbianl = gResolustionTable[gResulotion][supportCount]["resolution"];
		if(gWXH == fenbianl)then
			common.kyToast("支持该分辨率!");
			common.kyLog("isSupportResolution--2--"..fenbianl);
			return true;
		end;
		common.kyLog("isSupportResolution--3--"..fenbianl);
		supportCount = supportCount + 1;
	until(supportCount == 15)
	common.kyLog("isSupportResolution--4");
	return false;
	--]]
end;
-- 是否黑名单IP
function common.isBlackIp(checkIp)
	blackCount = gBlackIpTable["count"];
	repeat
		if(checkIp == gBlackIpTable["ipList"][blackCount])then
			common.kyLog("isBlackIp--0");
			common.kyToast("ip在黑名单"..checkIp);
			return true;
		end;
		blackCount = blackCount -1;
	until(blackCount == 0)
	common.kyLog("isnotBlackIp--1");
	common.kyToast("ip不在黑名单"..checkIp);
	return false;
end;

-- 小神灯是否弹出了未安装应用列表
function common.isPopNoneinstall()
	common.kyLog("isPopNoneinstall--0");
	ap = gFixedDataTable["popNeedInstallApp"][1];
	bp = gFixedDataTable["popNeedInstallApp"][2];
	cp = gFixedDataTable["popNeedInstallApp"][3];
	if multiColor({{ap["x"],ap["y"],ap["color"]},{bp["x"],bp["y"],bp["color"]},{cp["x"],cp["y"],cp["color"]}}) == true then--全部坐标点和颜色一致时返回 true，== true 可省略不写
		common.kyLog("isPopNoneinstall--1");
		return true;
	end;
	common.kyLog("isPopNoneinstall--2");
	return false;
end;

-- 是否有插屏广告
function common.isPopInterstitial()
	common.kyLog("isPopInterstitial--0");
	ap  = gYourAppHomeInfo[1];
	bp  = gYourAppHomeInfo[2];
	cp  = gYourAppHomeInfo[3];
	if multiColor({{ap["x"],ap["y"],ap["color"]},{bp["x"],bp["y"],bp["color"]},{cp["x"],cp["y"],cp["color"]}}) == true then--全部坐标点和颜色一致时返回 
		common.kyLog("isPopInterstitial--1");
		return false;
	end
	common.kyLog("isPopInterstitial--2");
	return true;
end;

-- 是否为008首页
function common.is008Home()
	common.kyLog("is008Home--0");
	ap = gFixedDataTable["home008"][1];
	bp = gFixedDataTable["home008"][2];
	common.kyToast( "is008Home ap "..ap["x"]);
	if multiColor({{ap["x"],ap["y"],ap["color"]},{bp["x"],bp["y"],bp["color"]}}) == true then--全部坐标点和颜色一致时返回 true，== true 可省略不写
		common.kyLog("is008Home--1");
		return true;
	end;
	common.kyLog("is008Home--2");
	return false;
end;

-- 是否进入安装完成打开界面
function common.isOpenStep()
	common.kyLog("isOpenStep--0");
	ap = gFixedDataTable["openStep"][1];
	bp = gFixedDataTable["openStep"][2];
	cp = gFixedDataTable["openStep"][3];
	if multiColor({{ap["x"],ap["y"],ap["color"]},{bp["x"],bp["y"],bp["color"]},{cp["x"],cp["y"],cp["color"]}}) == true then--全部坐标点和颜色一致时返回 
		common.kyLog("isOpenStep--1");
		return true;
	end
	common.kyLog("isOpenStep--2");
	return false;
end;
-- 是否进入安装界面
function common.isInstallStep()
	common.kyLog("isInstallStep--0");
	ap = gFixedDataTable["installStep"][1];
	bp = gFixedDataTable["installStep"][2];
	cp = gFixedDataTable["installStep"][3];
	if multiColor({{ap["x"],ap["y"],ap["color"]},{bp["x"],bp["y"],bp["color"]},{cp["x"],cp["y"],cp["color"]}}) == true then--全部坐标点和颜色一致时返回 
		common.kyLog("isInstallStep--1");
		return true;
	end
	common.kyLog("isInstallStep--2");
	return false;
end;
-- 是否进入解析包错误
function common.isParsePackError()
	common.kyLog("isParsePackError--0");
	ap = gFixedDataTable["parsePackError"][1];
	bp = gFixedDataTable["parsePackError"][2];
	cp = gFixedDataTable["parsePackError"][3];
	if multiColor({{ap["x"],ap["y"],ap["color"]},{bp["x"],bp["y"],bp["color"]},{cp["x"],cp["y"],cp["color"]}}) == true then--全部坐标点和颜色一致时返回 
		common.kyLog("isParsePackError--1");
		return true;
	end
	common.kyLog("isParsePackError--2");
	return false;
end;

-- 是否安装失败界面
function common.isInstallFail()
	common.kyLog("isInstallFail--0");
	ap = gFixedDataTable["sorryInstallStop"][1];
	bp = gFixedDataTable["sorryInstallStop"][2];
	if multiColor({{ap["x"],ap["y"],ap["color"]},{bp["x"],bp["y"],bp["color"]}}) == true then--全部坐标点和颜色一致时返回 
		common.kyLog("isInstallFail--1");
		return true;
	end
	common.kyLog("isInstallFail--2");
	return false;
end;
function common.isApplyNotInstall()
	common.kyLog("isApplyNotInstall--0");
	ap = gFixedDataTable["applyNotInstall"][1];
	bp = gFixedDataTable["applyNotInstall"][2];
	if multiColor({{ap["x"],ap["y"],ap["color"]},{bp["x"],bp["y"],bp["color"]}}) == true then--全部坐标点和颜色一致时返回 
		common.kyLog("isApplyNotInstall--1");
		return true;
	end
	common.kyLog("isApplyNotInstall--2");
	return false;
end;
function common.isAppStopRun()
	common.kyLog("isAppStopRun--0");
	ap = gFixedDataTable["appStopRun"][1];
	bp = gFixedDataTable["appStopRun"][2];
	if multiColor({{ap["x"],ap["y"],ap["color"]},{bp["x"],bp["y"],bp["color"]}}) == true then--全部坐标点和颜色一致时返回 
		common.kyLog("isAppStopRun--1");
		return true;
	end
	common.kyLog("isAppStopRun--2");
	return false;
end;

-- 是否进入了下一步界面
function common.isNextStep()
	common.kyLog("isNextStep--0");
	ap = gFixedDataTable["nextStep"][1];
	bp = gFixedDataTable["nextStep"][2];
	cp = gFixedDataTable["nextStep"][3];
	if multiColor({{ap["x"],ap["y"],ap["color"]},{bp["x"],bp["y"],bp["color"]},{cp["x"],cp["y"],cp["color"]}}) == true then--全部坐标点和颜色一致时返回 
		common.kyLog("isNextStep--1");
		return true;
	end
	common.kyLog("isNextStep--2");
	return false;
end;
-- 检测是否是垃圾应用
function common.isDirtyApp()
	common.kyLog("isDirtyApp-0");
	bid,class = common.kyFrontAppBid(); -- 获取当前包
	for key, value in ipairs(gAppList) do  
		if (bid == value) then
			common.kyLog("isDirtyApp--1");
			return false;
		end;
	end 
	common.kyLog("isDirtyApp--2");
	return true;
end;
function common.isMyselfApp()
	common.kyLog("isMyselfApp--0");
	bid,class = kyFrontAppBid(); -- 获取当前包
	if(bid == gYourAppPackage)then
		common.kyLog("isMyselfApp--1");
		return true;
	end;
	common.kyLog("isMyselfApp--2");
	return false;
end;
function common.isDeskerApp()
	common.kyLog("isDeskerApp--0");
	bid,class = common.kyFrontAppBid(); -- 获取当前包
	if(bid == gAppLauncher)then
		common.kyLog("isDeskerApp--1");
		return true;
	end;
	common.kyLog("isDeskerApp--2");
	return false;
end;
-- 是否进入安装界面安装
function common.isGotoInstallPackage()
	common.kyLog("isGotoInstallPackage--0");
	if(true == common.isNextStep() or true == common.isInstallStep() or true == common.isOpenStep() or true == common.isInstallStep())then
		common.kyLog("isGotoInstallPackage--1");
		return true;
	end;
	bid,class = common.kyFrontAppBid(); -- 获取当前包
	common.kyLog("isGotoInstallPackage--2--"..bid..class);
	if bid == gAppinstall  then
		common.kyLog("isGotoInstallPackage--3");
		return true;
	end
	common.kyLog("isGotoInstallPackage--4");
	return false;
end;

function common.isImeiChange()
	common.kyLog("isImeiChange--0");
	if( gImei == gNewDeviceTable["device"]["imei"])then
		common.kyToast("gImei 没有改变");
		common.kyLog("isImeiChange--1");
		return false;
	end;
	common.kyToast("imei已改变");
	gImei =  gNewDeviceTable["device"]["imei"];
	common.kyLog("isImeiChange--2");
	return true;
end;

--------------------关闭类,异常类相关操作--------------------------------------------------
-- 关闭插屏广告
function common.closePopInterstitial()
	common.kyLog("closePopInterstitial--0");
	if(true == common.isPopInterstitial())then
		common.kyLog("closePopInterstitial--1");		
		supportCount = 1;
		-- 重新获取分辨率
		width = gNewDeviceTable["device"]["width"];
		height = gNewDeviceTable["device"]["height"];
		gWXH = "R"..width.."X"..height; -- 全局变量
		repeat
			--common.kyToast("广告gWXH" .. gWXH .. "广告support"..gResolustionTable["supportResolution"][supportCount]["resolution"]);
			if( gWXH == gResolustionTable[gResulotion][supportCount]["resolution"])then
				common.kyLog("closePopInterstitial--2");
				ap = gResolustionTable[gResulotion][supportCount]["closeInterstitial"];
				common.kyToast("已消灭广告|gWXH"..gWXH.."X|Y"..ap["x"].."|"..ap["y"]);
				common.kyClick(ap["x"],ap["y"]);
				common.kySleep(2)
				common.kyClick(ap["x"],ap["y"]);
			end;
			common.kyLog("closePopInterstitial--3");
			supportCount = supportCount + 1;
		until(supportCount == 15 or false == common.isPopInterstitial())	
		if(true == common.isPopInterstitial())then
			common.kyToast("发现广告但没有消灭广告,重新执行脚本");
			common.kyReportDeviceData(0); -- 上报水军	
			pg_net.netTaskFinished(0); --上报任务未完成
			common.kyLuaRestart();
		else
			return true;
		end;
	end;
	common.kyLog("closePopInterstitial--4");
	return false;
end
-- 很抱歉，安装包出现异常
function common.closeSorryInstallUnkown()
	common.kyLog("closeSorryInstallUnkown--0");
	ap = gFixedDataTable["sorryInstallUnkown"][1];
	bp = gFixedDataTable["sorryInstallUnkown"][2];
	cp = gFixedDataTable["sorryInstallUnkown"][3];
	if multiColor({{ap["x"],ap["y"],ap["color"]},{bp["x"],bp["y"],bp["color"]},{cp["x"],cp["y"],cp["color"]}}) == true then--全部坐标点和颜色一致时返回 
		common.kyToast("出现安装包异常");
		common.kyClick(360,720); -- 提示不能安装，需要点掉。
		common.kyLog("closeSorryInstallUnkown--1");
		return true;
	end
	common.kyLog("closeSorryInstallUnkown--2");
	return false;
end;
-- 处理各种异常界面
function common.kyProcessException()
	common.kyLog("kyProcessException--0");
	local count = 0;
	repeat
		if(true == common.isPopNoneinstall())then -- 小神灯弹出未安装界面。
				common.kyLog("kyProcessException--1");
				ap = gFixedDataTable["closeAllApp"][1];
				common.kyClick(ap["x"],ap["y"]);
				common.kySleep(1);
		end;
		if(true == common.isApplyNotInstall())then -- 弹出应用未安装界面。
			common.kyClick(170,1230); -- 点击取消
			common.kySleep(1);
		end;
		if(true == common.isInstallFail())then -- 出现应该安装失败
			common.kyLog("kyProcessException--4");
			common.kyClick(360,723); 
			common.kySleep(1);
		end;
		if(true == common.isParsePackError())then -- 出现包解析出错
			common.kyLog("kyProcessException--4");
			common.kyClick(350,800); 
			common.kySleep(1);
		end;
		if(true == common.isAppStopRun())then -- 出现停止运行
			common.kyLog("kyProcessException--5");
			common.kyClick(355,726); 
			common.kySleep(1);
		end;
		count = count + 1;
	until(count == 2)
	common.kyLog("kyProcessException--10");
end;

-- 处理竖屏
function common.kyProcessScreen()
	common.kyLog("kyProcessScreen--0");
	runApp(gAppPortarit);
	common.kyProcessException();-- 处理各种异常
	common.closePopInterstitial(); -- 在铁腕下消灭一切广告
	closeApp(gAppPortarit);
	common.kyLog("kyProcessScreen--2");
end;

---------------------------------------------------------------------------------------
-- 使用留存数据
function common.kyShiqianUseNetData()
	common.kyLog("kyShiqianUseNetData--0");
	common.kyOpenApp(gAppshiqian); -- 启动 008
	common.kySleep(2);
	common.kyClick(490,965); -- 点掉授权
	common.kySleep(2); -- 发发启动需要足够时间
	common.kyClick(177,192)-- 使用点击两次留存
	common.kySleep(1);
	common.kyClick(177,192)-- 使用留存
	common.kySleep(1);
	common.kyCloseApp(gAppshiqian);--退出发发应用
	common.kyOpenApp(gAppshiqian);-- 打开发发
	common.kySleep(2);
	common.kyToast("取修改后的数据对比确定..");
	common.kyGetRemainDeviceInfo(); -- 取留存的信息 比较
	common.kySleep(3);
	common.kyGetNewDeviceInfo(); -- 取最新手机信息，一定要这步	
	common.kySleep(1);
	if( true == pg_net.netCheckRemainIp(gTaskIP,gRemainDataSingleTable["ip"]) and gNewDeviceTable["device"]["imei"] == gRemainDataSingleTable["imei"])then
		common.kyToast("已验证使用了留存数据 ip:" .. gNewDeviceTable["device"]["ip"] .." imei:".. gNewDeviceTable["device"]["imei"]  );
		common.kyLog("kyShiqianUseNetData--1");
	else
		common.kyToast("异常,未使用留存数据,重来");
		common.kyLog("kyShiqianUseNetData--2");
		common.kyLuaRestart();
	end;
	--
	common.kyCloseApp(gAppshiqian);    --退出008应用
	common.kyLog("kyShiqianUseNetData--3");
end;

-- 上报有效数据到后台
--  是否为留存(1,0) isActive 是否为激活(1,0)
function common.kyReportDeviceData(isActive)
	common.kyLog("kyReportDeviceData--0");
	
	report = gYourAppName.." 上报数据";
	if(isRunRemain == 1)then
		gNewDeviceTable["is_remain"] = 1;
		report = report .. "|留存";
	else
		gNewDeviceTable["is_remain"] = 0;
		report = report .. "|增量";
	end;
	
	if(isActive == 1)then
		report = report .. "|+1元";
	else
		report = report .. "|水军";
	end;
	
	gNewDeviceTable["is_active"] = isActive;
	gNewDeviceTable["appId"] = gYourAppId;
	gNewDeviceTable["accessToken"] = gYourAppToken;
	gNewDeviceTable["device"]["ip"] = gTaskIP; -- 取IP
	dev = getDeviceType(); 
	if( dev == 4 ) then
		gNewDeviceTable["device_type"] = 0;
	else
		gNewDeviceTable["device_type"] = 1;
	end;
	deviceJson = json.encode(gNewDeviceTable); -- 转json
	common.kyLog("kyReportDeviceData--1--");
	--writeFileString(gFileNewDevice,deviceJson);
	common.kyToast(report);
	str = httpPost(gReportUrl,deviceJson);
	if(false ~= str)then
		common.kyToast("上报成功！...")
	else
		common.kyToast("上报失败！...")
	end;
	common.kyLog("kyReportDeviceData--2--" ..isActive);
end;

-- ipCheck 检查 
-- 0: 代表IP 没有问题 1: 有问题,IP不统一
function common.ipCheck()
	common.kyLog("ipCheck--0");
	ipUrl = "http://pangu.u-app.cn/pc/remoteIp.pangu"
	common.kyToast("获取Ip中...",5);
	nowIp = "";
	repeat
		nowIp = pg_net.netIpcheck();
		if(nowIp ~= nil)then
			common.kyLog("ipCheck--2");
			if(false == common.isBlackIp(nowIp))then -- 黑名单IP
				ipOK = 1;
			else
				ipOK = 0;
				common.kyToast("IP在黑名单中,继续等待新IP...",10);
				common.kySleep(10);
			end;
		else
			ipOK = 0;
			common.kyLog("ipCheck--3");
			common.kyToast("网络异常,正等待连接...",10);
			common.kySleep(10);
		end;
	until(ipOK == 1)
	common.kyLog("ipCheck--8");
	if( nowIp == gTaskIP )then
		return 0;
	else
		common.kyToast("目前IP和任务中的IP不一致! 将重新运行脚本"..gTaskIP,5);
		common.kyLuaRestart();
		return 1;
	end;
	--]]
end;
-- 处理修改系统数据
function common.kyShiqianNewDevice()
	common.kyShiqianUseNetData(); 
end;


function common.kyUninstallAppByLua(packageName)
	common.kyLog("kyUninstallAppByLua--0");
	uninstallApp(packageName); -- 卸载
	common.kyLog("kyUninstallAppByLua--1");
end;

-- 切换手机
function common.changeMobileInfo()
	common.kyLog("changeMobileInfo--0");
	common.kyCloseApp(gAppshiqian);
	common.kyUninstallDirtyAppByLua(); -- 卸载所有垃圾应用	
	common.kyInitMyApp();
	common.kySleep(1);
	common.kyShiqianNewDevice();
	common.kySleep(1);
	common.kyLog("changeMobileInfo--1");
end;
-- 初始化
function common.initMobile()
	width, height = getScreenSize();
	gWXH = width.."X"..height;
	common.kyLog("initMobile--0--"..gWXH);
	pressHomeKey(); --点击 Home 键
	common.changeMobileInfo();
	common.kyLog("initMobile--2");
	showFloatButton(true); -- 显示悬浮条
	pressHomeKey(); --点击 Home 键
	common.kyLog("initMobile--3");
end;

function common.exitMobile()
	common.kyLog("exitMobile--0");
	uninstallApp(gYourAppPackage); -- 卸载应用
	common.kyUninstallDirtyAppByLua(); -- 卸载所有垃圾应用	
	
	--common.kyOpenApp(gAppshiqian); -- 删除 azb 目录,清空下载缓存
	--common.kyToast("清除下载缓存",5);
	--common.kyCloseApp(gAppshiqian);
	
	pressHomeKey(); --点击 Home 键
	showFloatButton(true); -- 关闭悬浮条
	common.kyLog("exitMobile--1");
end;

function common.kyCloseAndOpenApp()
	common.kyCloseApp(gYourAppPackage);-- 关闭应用
	common.kyOpenApp(gYourAppPackage); -- 启动应用
end;


function common.kyCloseDirtyApp()
	common.kyLog("kyCloseDirtyApp--0");
	if(true == common.isDirtyApp())then
		bid,class = common.kyFrontAppBid(); -- 获取当前包
		common.kyLog("kyCloseDirtyApp--1");
		common.kyToast("卸载垃圾应用"..bid);
		common.kyCloseApp(gYourAppPackage);
		common.kySleep(1);
		uninstallApp(gYourAppPackage); -- 卸载
		pressHomeKey(); --点击 Home 键
		common.kySleep(2);
		common.kyCloseApp(bid); --退出垃圾应用
		common.kySleep(1);
		uninstallApp(bid); -- 直接卸载垃圾
		common.kyProcessScreen(); -- 拉回竖屏
	end;
	common.kyLog("kyCloseDirtyApp--2");
end;

return common;