---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
yichu = {}
----------------------------------------------------------------------------
-- 取消安装
local function AppProcessNotInstall()
	common.kyLog("AppProcessNotInstall--0")
	common.kyProcessException();	
	-- 下一步
	if(true == common.isNextStep()) then-- 检测是否为下一步安装
		common.kyLog("AppProcessNotInstall--1");
		common.kyProcessScreen(); -- 拉回竖屏
		repeat
			common.kyClick(170,1230); -- 点击取消
			common.kySleep(2);
		until(false == common.isNextStep())
	end;
	-- 安装
	if(true == common.isInstallStep()) then-- 检测是否为安装
		common.kyLog("AppProcessNotInstall--2");
		--common.kyProcessScreen(); -- 拉回竖屏
		repeat
			common.kyClick(170,1230); -- 点击取消
			common.kySleep(2);
		until(false == common.isInstallStep())
		-- 在这里保存
	end;
	-- 打开
	if(true == common.isOpenStep()) then
		common.kyLog("AppProcessNotInstall--3");
		--common.kyProcessScreen(); -- 拉回竖屏
		repeat
			common.kyProcessException();
			common.kyClick(170,1230); -- 点击完成
			common.kySleep(2);
		until(false == common.isOpenStep())
	end;
	common.kyProcessException();
	common.kyLog("AppProcessNotInstall--5");
end;

-- 正常处理安装
local function AppProcessInstall()
	common.kyLog("AppProcessInstall--0");
	common.kyProcessException();
	-- 下一步
	if(true == common.isNextStep()) then-- 检测是否为下一步安装
		--common.kyProcessScreen(); -- 拉回竖屏
		repeat
			common.kyLog("AppProcessInstall--2");
			-- 移动至安装
			for i=1,3 do --
				common.kyMove(400,1084,400,500);
			end;
			common.kySleep(1);
		until(false == common.isNextStep() or true == common.isInstallStep())
	end;
	-- 安装
	if(true == common.isInstallStep()) then-- 检测是否为安装
		repeat
			common.kyLog("AppProcessInstall--3");
			common.ipCheck();
			common.kyReportDeviceData(1); -- 在此处上报数据
			gDirtyAppCount = gDirtyAppCount + 1;
			common.kyClick(540, 1233); -- 点击安装
			common.kySleep(2);
		until(false == common.isInstallStep())
		-- 在这里保存
	end;
	-- 打开
	if(true == common.isOpenStep()) then
		repeat
			common.kyLog("AppProcessInstall--4");
			common.kyProcessException();
			common.kyClick(170,1230); 
			common.kySleep(2);
		until(false == common.isOpenStep())
	end;
	common.kyProcessException();
	common.kyLog("AppProcessInstall--6");
end;
----------------------------------------------------------------------------
----------------------------------------
-- 马甲处理赚钱应用
-- 0:出现了广告 1:没有出现广告
local function AppProcessMoneyByMajia()
	common.kyLog("AppProcessMoneyByMajia--0");
	common.kyProcessException();
	common.ipCheck(); -- 进行IP检查
	common.kyOpenApp(gYourAppPackage); -- 启动应用
	common.kyHint();
	local index = 0;
	common.kyToast("等待广告15秒...",60);
	local adState = false;
	local loopCount = 0;
	local openCount = 0;
	repeat
		common.kyLog("AppProcessMoneyByMajia--1");
		common.kySleep(5);
		if(true == common.isPopInterstitial()) then
			adState = true;
		else
			if(loopCount == 3)then
				openCount = openCount + 1;
				common.kyCloseAndOpenApp(); -- 重新打开
				loopCount = 0;
			end;
			if(openCount > 2)then
				common.kyToast("很遗憾，没等到广告，退出!",5);
				common.kyLog("AppProcessMoneyByMajia--no ad");
				common.kyCloseApp(gYourAppPackage);-- 关闭应用
				return 1; 
			end;
			loopCount = loopCount + 1;
		end;
		common.kyToast("广告等待中-"..openCount,5);
	until( true == adState)
	-------------------------------
	common.kySleep(2);
	common.kyToast("发现广告");
	common.kyReportDeviceData(0); -- 上报水军	
	math.randomseed(getRndNum()) -- 随机种子初始化真随机数
	local index = math.random(1,10)
	common.kyLog("AppProcessMoneyByMajia--2"..index);
	if(index % 3 == 0)then
		common.ipCheck(); -- 进行IP检查
		common.kyToast("点击广告");
		common.kyClick(330,895); -- 点击广告,就点一个。
		common.kySleep(2);
	else
		common.kyToast("马甲完成任务");
		common.kyLog("AppProcessMoneyByMajia--3");
		common.kyCloseApp(gYourAppPackage);-- 关闭应用
		return 0;
	end;
	common.kySleep(1);
	index = math.random(1,10)
	common.kyLog("AppProcessMoneyByMajia--4"..index);
	if(index > 3)then
		common.kyToast("马甲完成任务");
		common.kyLog("AppProcessMoneyByMajia--5");
		common.kyCloseApp(gYourAppPackage);-- 关闭应用
		return 0;
	else
		index = 40;
		repeat --只能死等
			common.kyLog("AppProcessMoneyByMajia--6");
			common.kyToast("广告下载中,请耐心等待..."..index,10);
			common.kySleep(3);
			index = index - 1;
			if(index == 20)then
				common.kyLog("AppProcessMoneyByMajia--7");
				common.kyToast("1分钟了,网速太慢，建议切换VPN",30);
			end;
			if(index == 0)then -- 等待三分钟退出
				common.kyToast("2分钟已到,任务未完成,退出！",30);
				common.kyLog("AppProcessMoneyByMajia--8");
				pg_net.netTaskFinished(0); --上报任务未完成
				common.kyLuaRestart();
			end;
		until( true == common.isGotoInstallPackage())
		common.kyLog("AppProcessMoneyByMajia--9");
		AppProcessNotInstall() -- 取消安装
	end;
	common.kyToast("马甲完成任务");
	common.kyLog("AppProcessMoneyByMajia--10");
	common.kyCloseApp(gYourAppPackage);-- 关闭应用
	return 0; --
end;
-- 处理赚钱应用
-- 0:点击了广告 1:没有点到广告
local function AppProcessMoney()
	common.kyLog("AppProcessMoney--0");
	common.ipCheck(); -- 进行IP检查
	common.kyOpenApp(gYourAppPackage); -- 启动应用
	common.kyHint();
	local index = 0;
	common.kyToast("等待广告15秒...",3);
	local adState = false;
	local loopCount = 0;
	local openCount = 0;
	repeat
		common.kyLog("AppProcessMoney--1");
		common.kySleep(5);
		if(true == common.isPopInterstitial()) then
			adState = true;
		else
			if(loopCount == 3)then
				openCount = openCount + 1;
				common.kyCloseAndOpenApp(); -- 重新打开
				loopCount = 0;
			end;
			if(openCount > 2)then
				common.kyToast("很遗憾，没等到广告，退出!",5);
				common.kyLog("AppProcessMoney--no ad");
				common.kyCloseApp(gYourAppPackage);-- 关闭应用
				return 1; 
			end;
			loopCount = loopCount + 1;
		end;
		common.kyToast("广告等待中-"..openCount,5);
	until( true == adState)
	-------------------------------
	if(adState == true)then
		common.ipCheck(); -- 进行IP检查
	end;
	common.kyToast("点击广告");
	common.kyClick(330,895); -- 点击广告,就点一个。
	common.kySleep(2);
	--------------------------------
	common.kyLog("AppProcessMoney--2");
	local index = 40;
	repeat --只能死等
		common.kyLog("AppProcessMoney--4");
		common.kyToast("广告下载中,请耐心等待..."..index,10);
		common.kySleep(3);
		index = index - 1;
		if(index == 20)then
			common.kyLog("AppProcessMoney--5");
			common.kyToast("1分钟了,网速太慢，建议切换VPN",30);
		end;
		if(index == 0)then -- 等待三分钟退出
			common.kyToast("2分钟已到,任务未完成,退出！",30);
			common.kyReportDeviceData(0); -- 上报水军	
			pg_net.netTaskFinished(0); --上报任务未完成
			common.kyLuaRestart();
			common.kyLog("AppProcessMoney--6");
		end;
	until( true == common.isGotoInstallPackage())
	common.kyLog("AppProcessMoney--7");
	return 0;
end;

-- 马甲入口函数
local function AppRunMajia()
	common.kyDataInit();
	common.kyInitLog();
	common.kyLog("AppRunMajia--0");
	common.kyProcessException();-- 处理各种异常
	common.initMobile();
	local flag = 1;
	--[[
	repeat -- 循环消灭之前的安装
		AppProcessNotInstall()
	until(true ~= common.isGotoInstallPackage())
	--]]
	flag = AppProcessMoneyByMajia();
	common.exitMobile();
	common.kyLog("AppRunMajia--5");
	return flag;
end;

-- 赚钱入口函数
-- 0: 任务完成 1: 任务未完成
local function AppRunActive()
	common.kyDataInit();
	common.kyInitLog();
	common.kyLog("AppRunActive--0");
	common.kyProcessException();-- 处理各种异常
	common.initMobile();
	local flag = 0;
	repeat
		common.kyToast("正式执行任务");
		if( true == common.isGotoInstallPackage()) then
			common.kyLog("AppRunActive--2");
			repeat -- 循环安装
				common.kyLog("AppRunActive--3");
				common.kySleep(1);
				AppProcessInstall();
				common.kySleep(1);
				common.kyProcessException();
				common.kyCloseDirtyApp();
			until(gDirtyAppCount > 0 or true ~= common.isGotoInstallPackage())
			common.kyLog("AppRunActive--4");	
		else
			common.kyLog("AppRunActive--6");
			flag = AppProcessMoney();
		end;
		common.kyLog("AppRunActive--7");
		common.kyProcessException();
	until(gDirtyAppCount > 0 or flag == 1) -- 没有等到广告也退出
	common.exitMobile();
	common.kyLog("AppRunActive--13");
	if(gDirtyAppCount > 0)then
		return 0;
	else
		return 1;
	end;
end;

function yichu.runMyApp(isShuijun)
	local flag = 0;
	if(isShuijun == 0)then
		flag = AppRunActive();
	else
		flag = AppRunMajia();
	end;
	return flag;
end;
return yichu;
