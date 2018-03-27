------------------------------------------------------------------------------
-- turing 2017/1/19 create 
-------------------------------------------------------------------------------
--net = {}
require "TSLib"
json = require('json')  

host = "http://127.0.0.1:8080/pc/";
phoneJson = "";
local function initPhoneInfo()
	local filePhone = "/mnt/sdcard/TouchSprite/lua/json/json_new_device_info.json";
	if(true == isFileExist(filePhone))then
		phoneJson = readFileString(filePhone);	--固定数据文件
		phoneTable = json.decode(phoneJson);    --json转table 
		
		phoneTable["appId"] = 1;
		
		phoneJson = json.encode(phoneTable);
		toast(phoneJson);
		writeFileString(filePhone,phoneJson);
	else
		toast("缺少配置文件,请检查....");
		lua_exit(); -- 退出脚本
	end;
end;
local function remainInfo()
	local filePhone = "/mnt/sdcard/TouchSprite/lua/json/remain/2017-01-21_1_org.kyf.xsd.wzq.json";
	local filePhone1 = "/mnt/sdcard/TouchSprite/lua/json/json_remain_device_info.json";
	if(true == isFileExist(filePhone))then
		phoneJson = readFileString(filePhone);	--固定数据文件phoneTable
		phoneTable = json.decode(phoneJson);    --json转table 
		temIp = "204:108:252:218"; --204:108:252:218
		imei = "iuirwejoipofjqp"; -- y7102M07QAkwI51u
		
	for key, value in ipairs(phoneTable["deviceList"]) do  
		if (gIp == value["ip"]) then
			remainJson = json.encode(value);
			toast("恭喜你,发现一个留存IP,已保存信息");
			isRemainIP = true;
			writeFileString(gFileRemainDevice,remainJson);
		end;
	end  
		toast("木有发现");
		value = phoneTable["deviceList"][20];
		remainJson = json.encode(value);
		toast(remainJson);
		writeFileString(filePhone1,remainJson);
		--[[
		for key, value in ipairs(phoneTable[1]) do  
			--if temIp == value["ip"] then
				remainJson = json.encode(value);
				toast(remainJson);
				writeFileString(filePhone1,remainJson);
				break;
			--end;
		end; 
		--]]
	else
		toast("缺少配置文件,请检查....");
		lua_exit(); -- 退出脚本
	end;
end;
local function report()
	local filePhone = "/mnt/sdcard/TouchSprite/lua/json/json_new_device_info.json";
	log("report -- 0","jsonReq");
	if(true == isFileExist(filePhone))then
		phoneJson = readFileString(filePhone);	--固定数据文件
		phoneTable = json.decode(phoneJson);    --json转table 
		
		log("report -- 0","jsonReq");
		phoneTable["appId"] = 1;
		
		log("report -- 1","jsonReq");
		phoneJson = json.encode(phoneTable);
		
		log("report -- 2","jsonReq");
		host = "http://pangu.u-app.cn/mobile/report.pangu";
		
		--url = host .. "?report="..phoneJson;
		log(host,"jsonReq");
		
		log("report -- 3","jsonReq");
		toast(host);
		log("report -- 4","jsonReq");
		--str = httpGet(url);
		str = httpPost(host,phoneJson);
		if(str ~= nil)then
			log("report -- 999","jsonReq");
			toast(str);
		end
		
		log("report -- 5","jsonReq");
		--toast(phoneJson);
		--writeFileString(filePhone,phoneJson);
	else
		toast("缺少配置文件,请检查....");
		lua_exit(); -- 退出脚本
	end;
end;
function getAppInfo()
	report();
	--req = {userId="",Token=""};
	--jsonReq = json.encode(req);      --tableתjson  
	--log(jsonReq,"net");
	--url = host .. "getAppList.pangu";
	--str = httpGet("http://www.baidu.com");
	--str = httpPost(url,phoneJson);
	
	--str = httpGet("http://127.0.0.1:8080/pc/index.pangu");
	--str = httpGet("http://api.ip138.com/query/?datatype=jsonp&token=38c2ffed72e199a01ce60f3231c79ebc");
	--toast(str);
	--str=httpPost(url,phoneJson);
	--dialog(str);
end;
getAppInfo();