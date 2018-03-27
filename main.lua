
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

	repeat
		-- 1.取任务
		log("runMyApp--1","debug");		
		if(0 == pg_net.netGetOneTask() )then
			loopTime = gGetTaskTable["loopTime"];
			if(gGetTaskTable["isHaveTask"] == 1)then -- 有任务
				common.kyToast("获得一个任务,将执行");
				log("runMyApp--2","debug");
				gTaskIP = gGetTaskTable["taskIp"];
				--
				-- 2.执行任务
				--操作类型  0:增量赚钱 1:增量水军 2:存量赚钱 3:存量水军
				if(gGetTaskTable["task"]["operType"] == 0 or gGetTaskTable["task"]["operType"] == 1 )then
					isRunRemain = 0; -- 是否存量
				else
					isRunRemain = 1;
				end;
				-- file 先文件拷贝下
				if(true == isFileExist(newDevicePath) and true == isFileExist(newDevicePathBack) )then
					local backContent = readFileString(newDevicePathBack) 
					writeFileString(newDevicePath,backContent);
				else
					common.kyToast("拷贝文件失败,请检查,退出!");
					return;
				end;
				-- 保存增量或存量信息 
				if(true == isFileExist(stockPath))then
					local deviceJson = json.encode(gGetTaskTable["task"]["changeDeviceInfo"]); -- 转json
					writeFileString(stockPath,deviceJson);
				end;
				-- 保存平台信息
				if(true == isFileExist(platformPath))then
					local platformJson = json.encode(gGetTaskTable["task"]["app"]); -- 
					log("runMyApp-"..platformJson,"debug");
					writeFileString(platformPath,platformJson);
				end;
				log("runMyApp--3","debug");
				if(gGetTaskTable["task"]["operType"] == 0 or gGetTaskTable["task"]["operType"] == 2 )then
					isRunShuiJun = 0; -- 是否水军
				else
					isRunShuiJun = 1;
				end;
				
				log("runMyApp--4|","debug");
				if(gGetTaskTable["task"]["app"]["platformId"] == 1)then
					flag = xsd.runMyApp(isRunShuiJun);
				elseif(gGetTaskTable["task"]["app"]["platformId"] == 2)then
					flag = yichu.runMyApp(isRunShuiJun);
				elseif(gGetTaskTable["task"]["app"]["platformId"] == 3)then
					flag = juyou.runMyApp(isRunShuiJun);
				else 
				
				end;
				
				-- 完成任务
				if(flag == 0 )then
					pg_net.netTaskFinished(1);-- 任务是否完成  1:完成 0:没有完成
					common.kyToast("完成任务,将获取下一个任务")
				else
					pg_net.netTaskFinished(0);
					common.kyToast("任务没有完成,应该是广告没有弹出，将获取下一个任务")
				end;
				log("runMyApp--5"..flag,"debug");
			else -- 没有任务
				common.kyToast("没有任务或已执行过任务");
				log("runMyApp--6","debug");
			end;
		end;
		common.kyToast("等待任务中...|loopTime:"..loopTime);
		common.kySleep(loopTime);
	until(1==0)
end;
function main()
	startTask();
end;
main()