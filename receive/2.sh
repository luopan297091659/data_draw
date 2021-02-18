#!/bin/sh
#基础变量
SN=`getprop ro.boot.serialno`
OS_VERSION=`getprop ro.build.version.incremental`
GLASS_SN=`getprop persist.rokid.glass.sn`



#进入系统主界面判断
function enter_launcher_test(){
process_name="com.rokid.launcher3"
activity_process=$(dumpsys activity activities  |grep TaskRecord |head -n 1 |awk -F '[ =]+' '{print $6}')
while [ "$activity_process"z != "$process_name"z ]
do
	echo "Error:front activity process is $activity_process, but the test process name is $process_name"
        input keyevent 3
        sleep 1
        activity_process=$(dumpsys activity activities  |grep TaskRecord |head -n 1 |awk -F '[ =]+' '{print $6}')
done
}

#系统launcher测试
function launcher_test(){
enter_launcher_test
#右移动坐标1值+150，左移动坐标3值-150
input swipe 0 0 3000 0  
sleep 1
input swipe 150 0 0 0 
sleep 1
input swipe 750 0 0 0 
sleep 1
}

#扫一扫
function scan_test(){
process_name="com.rokid.glass.scan2"
am start -n  $process_name/.ScanActivity
sleep 1 
activity_process=$(dumpsys activity activities  |grep TaskRecord |head -n 1 |awk -F '[ =]+' '{print $6}')
if [ "$activity_process"z != "$process_name"z ];then
        return
fi
input keyevent 3
sleep 1
enter_launcher_test
}
                                                                                                           
#我的相机
function camera_test(){    
process_name="com.rokid.glass.camera"
am start -n $process_name/.MainActivity                                                                       
sleep 1  
activity_process=$(dumpsys activity activities  |grep TaskRecord |head -n 1 |awk -F '[ =]+' '{print $6}')
if [ "$activity_process"z != "$process_name"z ];then
        dmesg -T  |grep -v "healthd: battery" |grep -v "battery l" > dmesg.log  && exit
        return
fi
input keyevent 23                                                                                                      
sleep 3
input keyevent 23                                                                                                      
sleep 1  
input keyevent 4
sleep 1  
enter_launcher_test                                                                                                 
} 


#我的相册
function gallery_test(){
process_name="com.rokid.glass.gallery"
am start -n  $process_name/.MainActivity
sleep 1
activity_process=$(dumpsys activity activities  |grep TaskRecord |head -n 1 |awk -F '[ =]+' '{print $6}')
if [ "$activity_process"z != "$process_name"z ];then
        dmesg -T > dmesg.$1
        exit
fi
input keyevent 66 
sleep 1
input keyevent 4 
sleep 1
input keyevent 22
sleep 1
input keyevent 66 
sleep 1
input keyevent 4 
sleep 1
input keyevent 66 
sleep 1
input keyevent 4 
sleep 1
input keyevent 4 
enter_launcher_test
}                                                                                                                     
                                                                                                                       
#红外测温
function  ir_test(){  
process_name="com.rokid.glass.ir.thermometer"
am start -n $process_name/.MainActivity                                                               
sleep 2 
activity_process=$(dumpsys activity activities  |grep TaskRecord |head -n 1 |awk -F '[ =]+' '{print $6}')
if [ "$activity_process"z != "$process_name"z ];then
        return
fi   
input keyevent 23                                                                                                      
sleep 1 
input keyevent 23                                                                                                      
sleep 1 
input keyevent 4 
input keyevent 22  
input keyevent 66  
sleep 1       
enter_launcher_test                                                                                           
}                                                                                                                      
                                                                                                                       
#我的文件
function document_test(){ 
process_name="com.rokid.glass.document2"
am start -n $process_name/.activity.MainActivity                                                           
sleep  1  
activity_process=$(dumpsys activity activities  |grep TaskRecord |head -n 1 |awk -F '[ =]+' '{print $6}')
if [ "$activity_process"z != "$process_name"z ];then
        return
fi 
input keyevent 4 
sleep 1     
enter_launcher_test                                                                                               
}     


#应用管理
function appstore_test(){
process_name="com.rokid.glass.appstore"
am start -n  $process_name/.ui.MainActivity 
sleep 1
activity_process=$(dumpsys activity activities  |grep TaskRecord |head -n 1 |awk -F '[ =]+' '{print $6}')
if [ "$activity_process"z != "$process_name"z ];then
        return
fi 
input keyevent 66
sleep 1
input keyevent 4
sleep 1
input keyevent 20
sleep 1
#input keyevent 66
#sleep 1
#input keyevent 4
#sleep 1
input keyevent 20
input keyevent 20
sleep 1
input keyevent 66
sleep 1
input keyevent 4
sleep 1
input keyevent 4
sleep 1  
enter_launcher_test
}        


#系统设置
function  setting_test(){
process_name="com.rokid.glass.settings"
am start -n $process_name/.activities.main.SettingHomeActivity
sleep 1
activity_process=$(dumpsys activity activities  |grep TaskRecord |head -n 1 |awk -F '[ =]+' '{print $6}')
if [ "$activity_process"z != "$process_name"z ];then
        return
fi 
input keyevent 20
input keyevent 66
sleep 1
input keyevent 20
input keyevent 66
sleep 1
input keyevent 4
input keyevent 4
input keyevent 20
sleep 1
input keyevent 66
sleep 2
input keyevent 4
input keyevent 4
sleep 1
enter_launcher_test
}
                                                                                                        
                                                                                                                       
#工业套件
#作业指导书
function  manual_test(){
process_name="com.rokid.rokid_apg_manual"
am start -n $process_name/com.rokid.glass.manual.activity.MainActivity
sleep 1
activity_process=$(dumpsys activity activities  |grep TaskRecord |head -n 1 |awk -F '[ =]+' '{print $6}')
if [ "$activity_process"z != "$process_name"z ];then
        return
fi 
input keyevent  23
sleep 1
input keyevent  4
sleep 1
input keyevent 20
sleep 1
input keyevent  23
sleep 1
input keyevent  4
sleep 1
input keyevent 20
sleep 1
input keyevent  23
sleep 1
input keyevent  4
sleep 1
input keyevent 20
sleep 1
input keyevent 20
sleep 1
input keyevent 4
sleep 1
sleep 1
enter_launcher_test
}

#智能测温
function ir.thermometer_test(){
process_name="com.rokid.glass.ir.thermometer.object"
am start -n $process_name/com.rokid.glass.ir.thermometer.MainActivity
sleep 1
activity_process=$(dumpsys activity activities  |grep TaskRecord |head -n 1 |awk -F '[ =]+' '{print $6}')
if [ "$activity_process"z != "$process_name"z ];then
        return
fi 
input keyevent  23
sleep 1
input keyevent 4 --longpress 4
sleep 3
input keyevent  23
sleep 1
input keyevent 4 --longpress 4
sleep 3
input keyevent  23
sleep 1
input keyevent 4 --longpress 4
sleep 3
input keyevent  23
sleep 1
input keyevent 4 --longpress 4
sleep 3
enter_launcher_test  
}


#基础参数
SN=`getprop ro.boot.serialno`
OS_VERSION=`getprop ro.build.version.incremental`
GLASS_SN=`getprop persist.rokid.glass.sn`

#设备相关信息
echo "Dock sn : $SN \nGlass sn : $GLASS_SN\nOS version : $OS_VERSION"

count=1
for i in `seq 1 50`
do  
    sleep 1
    #开始测试
    echo "\n$ss\nBegin test, count is $count"
    scan_test             
    camera_test  $count
    gallery_test
    #ir_test
    document_test
    #appstore_test
    setting_test
    let count=count+1  
done
