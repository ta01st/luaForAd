test = {}
 
-- 定义一个常量
test.constant = "这是一个常量"
 
-- 定义一个函数
function test.func2()
    toast("这是一个公有函数！\n")
end
 
local function func2()
    toast("这是一个私有函数！")
end
 
function test.func3()
    func2()
	test.func2()
end
 
return test