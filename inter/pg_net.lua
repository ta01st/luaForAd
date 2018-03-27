------------------------------------------------------------------------------
--  
-------------------------------------------------------------------------------
pg_net = {}
function pg_net.netPhoneLogin()
	local deviceIdPath = "/mnt/sdcard/TouchSprite/lua/json/device_id.json"
	local deviceLoginUrl = "http://pangu.u-app.cn/mobile/deviceLogin.pangu"
	if(true == isFileExist(deviceIdPath))then
		local jsonStr = readFileString(deviceIdPath);--读取分辨率配置文件
		gDeviceTable = json.decode(jsonStr);   --json转table 
		toast("更换设备ID",5);
	else
		toast("缺少配置文件,请检查....",5);
		lua_exit();-- 退出脚本
	end;
	local deviceReq = {}
	deviceReq["deviceId"] = gDeviceTable["deviceId"];
	local postJson = json.encode(deviceReq); -- 转json
	local jsonStr = httpPost(deviceLoginUrl,postJson);
	if(false == jsonStr)then
		log("netPhoneLogin--1","debug");
		return 1;
	else
		log("netPhoneLogin--2","debug");
		writeFileString(deviceIdPath,jsonStr);
		gDeviceTable = json.decode(jsonStr);    --json转table 
	end;
	log("netPhoneLogin--3","debug");
	return 0;
end;
function pg_net.netGetAppInfo(appId)
	local getAppInfoUrl = "http://pangu.u-app.cn/mobile/getAppInfo.pangu"
	local getAppInfoReq = {}
	log("netGetAppInfo--0","debug");		
	getAppInfoReq["appId"] = appId;
	local postJson = json.encode(getAppInfoReq); -- 转json
	local jsonStr = httpPost(getAppInfoUrl,postJson);
	if(false == jsonStr)then
		log("netGetAppInfo--false","debug");
		return 1;
	else
		getAppInfoTable = json.decode(jsonStr);    --json转table 
		log("netGetAppInfo--2","debug");
	end;
	log("netGetAppInfo--3","debug");
	return 0;
end;
function pg_net.netGetOneTask()
	local getTaskUrl = "http://pangu.u-app.cn/mobile/getTask.pangu"
	local getTaskReq = {}
	log("netGetOneTask--0"..gDeviceTable["deviceToken"],"debug");
	getTaskReq["deviceId"] = gDeviceTable["deviceToken"];
	getTaskReq["accessToken"] = gDeviceTable["deviceToken"];
	toast("deviceId:"..getTaskReq["deviceId"]);
	local postJson = json.encode(getTaskReq); -- 转json
	local jsonStr = httpPost(getTaskUrl,postJson);
	if(false == jsonStr)then
		log("netGetOneTask--false","debug");
		return 1;
	else
		log(jsonStr,"debug");
		log("netGetOneTask--2","debug");
		gGetTaskTable = json.decode(jsonStr);    --json转table 
	end;
	return 0;
end;
function pg_net.netTaskFinished(isFinished)
	local taskFinishUrl = "http://pangu.u-app.cn/mobile/taskFinish.pangu"
	local taskFinishReq = {}
	log("netTaskFinished--0","debug");
	taskFinishReq["isFinished"] = isFinished;
	taskFinishReq["vpnToken"] = gGetTaskTable["task"]["vpnToken"];
	taskFinishReq["taskId"] = gGetTaskTable["task"]["taskId"];
	local postJson = json.encode(taskFinishReq); -- 转json
	local jsonStr = httpPost(taskFinishUrl,postJson);
	if(false == jsonStr)then
		log("netTaskFinished--false","debug");
		return 1;
	end;
	return 0; 
end;
-- 验证留存IP
function pg_net.netCheckRemainIp(localIp,remainIp)
	return true;
end;
function pg_net.netGetBlackIpList()
	local postUrl = "http://pangu.u-app.cn/mobile/getBlackIpList.pangu"
	local getBlackIpListReq = {}
	getBlackIpListReq["platformId"] = 1;
	local postJson = json.encode(getBlackIpListReq); -- 转json
	local jsonStr = httpPost(postUrl,postJson);
	if(false == jsonStr)then
		toast("获取黑名单IP失败",5);
		log("netGetBlackIpList--false","debug");
		return 1;
	else
		toast("IP黑名单:"..jsonStr,5);
		gBlackIpTable = json.decode(jsonStr);    --json转table 
	end;
	log("netGetBlackIpList--1","debug");
	return 0;
end;
function pg_net.netIpcheck()		
	local getUrl = "http://pangu.u-app.cn/pc/remoteIp.pangu"
	local jsonStr = httpGet(getUrl);
	local remoteIpTable = {}
	log("netIpcheck--0","debug");
	if(false == jsonStr)then
		return nil;
	else
		remoteIpTable = json.decode(jsonStr);    --json转table 
		log("netIpcheck--1"..remoteIpTable["data"],"debug");
		return remoteIpTable["data"];
	end;
end;
return pg_net;