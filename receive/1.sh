#!/bin/sh
#基础变量
file_log=common_test.log
SN=`getprop ro.boot.serialno`
OS_VERSION=`getprop ro.build.version.incremental`
GLASS_SN=`getprop persist.rokid.glass.sn`



#进入系统主界面判断
function enter_launcher_test(){
process_name="com.rokid.launcher3"
activity_process=$(dumpsys activity activities  |grep TaskRecord |head -n 1 |awk -F '[ =]+' '{print $6}')
while [ "$activity_process"z != "$process_name"z ]
do
        _log "进入系统主界面失败"  1
        input keyevent 3
        sleep 1
        _log "进入系统主界面"
        activity_process=$(dumpsys activity activities  |grep TaskRecord |head -n 1 |awk -F '[ =]+' '{print $6}')
done
_log "进入系统主界面成功"
}

#系统launcher测试
function launcher_test(){
enter_launcher_test
#右移动坐标1值+150，左移动坐标3值-150
_log "移动到最左端图标"
input swipe 0 0 3000 0  
sleep 1
input swipe 150 0 0 0 
_log "向右移动一个图标" 
sleep 1
input swipe 750 0 0 0 
_log "向右移动5个图标，系统设置图标" 
sleep 1
}

#扫一扫
function scan_test(){
process_name="com.rokid.glass.scan2"
_log "进入扫一扫"
am start -n  $process_name/.ScanActivity
sleep 1 
activity_process=$(dumpsys activity activities  |grep TaskRecord |head -n 1 |awk -F '[ =]+' '{print $6}')
if [ "$activity_process"z != "$process_name"z ];then
        _log "进入扫一扫失败"  1
        return
fi
_log "返回主界面"
input keyevent 3
sleep 1
enter_launcher_test
}
                                                                                                           
#我的相机
function camera_test(){    
process_name="com.rokid.glass.camera"
_log "进入我的相机"                                                                                       
am start -n $process_name/.MainActivity                                                                       
sleep 1  
activity_process=$(dumpsys activity activities  |grep TaskRecord |head -n 1 |awk -F '[ =]+' '{print $6}')
if [ "$activity_process"z != "$process_name"z ];then
        _log "进入我的相机失败"  1
        dmesg -T  |grep -v "healthd: battery" |grep -v "battery l" > dmesg.log  && exit
        return
fi
_log "拍照1"                                                                                                              
input keyevent 23                                                                                                      
sleep 3
_log "拍照2"                                                                                                              
input keyevent 23                                                                                                      
sleep 1  
_log "返回主界面"                                                                                                             
input keyevent 4
_log "显示主界面"  
sleep 1  
enter_launcher_test                                                                                                 
} 


#我的相册
function gallery_test(){
process_name="com.rokid.glass.gallery"
_log "进入我的相册"
am start -n  $process_name/.MainActivity
sleep 1
activity_process=$(dumpsys activity activities  |grep TaskRecord |head -n 1 |awk -F '[ =]+' '{print $6}')
if [ "$activity_process"z != "$process_name"z ];then
        _log "进入我的相册失败"  1
        dmesg -T > dmesg.$1
        exit
fi
_log "打开第一个图像"
input keyevent 66 
sleep 1
_log "回到相册"
input keyevent 4 
sleep 1
_log "向右移动到第二张"
input keyevent 22
sleep 1
_log "打开第二张照片"
input keyevent 66 
sleep 1
_log "回到相册"
input keyevent 4 
sleep 1
_log "打开第一张图像"
input keyevent 66 
sleep 1
_log "回到相册"
input keyevent 4 
sleep 1
_log "回到主界面"
input keyevent 4 
enter_launcher_test
}                                                                                                                     
                                                                                                                       
#红外测温
function  ir_test(){  
process_name="com.rokid.glass.ir.thermometer"
pm list package ｜grep  $process_name ||  _log "未安装红外测温"  1 |return 
_log "进入红外测温应用"                                                                                        
am start -n $process_name/.MainActivity                                                               
sleep 2 
activity_process=$(dumpsys activity activities  |grep TaskRecord |head -n 1 |awk -F '[ =]+' '{print $6}')
if [ "$activity_process"z != "$process_name"z ];then
        _log "进入红外测温失败"  1
        return
fi   
_log "切换热成像模式"                                                                                                            
input keyevent 23                                                                                                      
sleep 1 
_log "切换灰度成像模式"                                                                                                            
input keyevent 23                                                                                                      
sleep 1 
_log "回到上一级"                                                                                                               
input keyevent 4 
_log "是否退出，选择退出"                                                                                                        
input keyevent 22  
_log "返回主界面"                                                                                                      
input keyevent 66  
_log "显示主界面"   
sleep 1       
enter_launcher_test                                                                                           
}                                                                                                                      
                                                                                                                       
#我的文件
function document_test(){ 
process_name="com.rokid.glass.document2"
_log "进入我的文件"                                                                                               
am start -n $process_name/.activity.MainActivity                                                           
sleep  1  
activity_process=$(dumpsys activity activities  |grep TaskRecord |head -n 1 |awk -F '[ =]+' '{print $6}')
if [ "$activity_process"z != "$process_name"z ];then
        _log "进入我的文件失败"  1
        return
fi 
_log "返回主界面"                                                                                                             
input keyevent 4 
_log "显示主界面"  
sleep 1     
enter_launcher_test                                                                                               
}     


#应用管理
function appstore_test(){
process_name="com.rokid.glass.appstore"
_log "进入应用管理"
am start -n  $process_name/.ui.MainActivity 
sleep 1
activity_process=$(dumpsys activity activities  |grep TaskRecord |head -n 1 |awk -F '[ =]+' '{print $6}')
if [ "$activity_process"z != "$process_name"z ];then
        _log "进入应用管理失败"  1
        return
fi 
_log "进入应用下载"
input keyevent 66
sleep 1
_log "回到应用管理主界面"
input keyevent 4
sleep 1
_log "向右移动到应用更新"
input keyevent 20
sleep 1
#_log "进入应用更新"
#input keyevent 66
#sleep 1
#_log "回到应用管理主界面"
#input keyevent 4
#sleep 1
_log "向右移动到应用卸载"
input keyevent 20
input keyevent 20
sleep 1
_log "进入应用卸载"
input keyevent 66
sleep 1
_log "回到应用管理主界面"
input keyevent 4
sleep 1
_log "返回主界面"                                                                                                             
input keyevent 4
_log "显示主界面"  
sleep 1  
enter_launcher_test
}        


#系统设置
function  setting_test(){
_log "进入系统设置"
process_name="com.rokid.glass.settings"
am start -n $process_name/.activities.main.SettingHomeActivity
sleep 1
activity_process=$(dumpsys activity activities  |grep TaskRecord |head -n 1 |awk -F '[ =]+' '{print $6}')
if [ "$activity_process"z != "$process_name"z ];then
        _log "进入系统设置失败"  1
        return
fi 
_log "进入控制中心"
input keyevent 20
input keyevent 66
sleep 1
_log "进入音量设置"
input keyevent 20
input keyevent 66
sleep 1
_log "回到系统设置主界面"
input keyevent 4
input keyevent 4
_log "系统管理"
input keyevent 20
sleep 1
_log "关于本机"
input keyevent 66
sleep 2
_log "返回主界面"
input keyevent 4
input keyevent 4
sleep 1
enter_launcher_test
}
                                                                                                        
                                                                                                                       
#工业套件
#作业指导书
function  manual_test(){
_log "进入作业指导书"
process_name="com.rokid.rokid_apg_manual"
am start -n $process_name/com.rokid.glass.manual.activity.MainActivity
sleep 1
activity_process=$(dumpsys activity activities  |grep TaskRecord |head -n 1 |awk -F '[ =]+' '{print $6}')
if [ "$activity_process"z != "$process_name"z ];then
        _log "进入作业指导书失败"  1
        return
fi 
_log "图片发大/播放视频"
input keyevent  23
sleep 1
_log "返回上一级"
input keyevent  4
sleep 1
_log "下一步"
input keyevent 20
sleep 1
_log "图片发大/播放视频"
input keyevent  23
sleep 1
_log "返回上一级"
input keyevent  4
sleep 1
_log "下一步"
input keyevent 20
sleep 1
_log "图片发大/播放视频"
input keyevent  23
sleep 1
_log "返回上一级"
input keyevent  4
sleep 1
_log "下一步"
input keyevent 20
sleep 1
_log "下一步"
input keyevent 20
sleep 1
_log "返回主界面"
input keyevent 4
sleep 1
sleep 1
enter_launcher_test
}

#智能测温
function ir.thermometer_test(){
_log "进入智能测温"
process_name="com.rokid.glass.ir.thermometer.object"
am start -n $process_name/com.rokid.glass.ir.thermometer.MainActivity
sleep 1
activity_process=$(dumpsys activity activities  |grep TaskRecord |head -n 1 |awk -F '[ =]+' '{print $6}')
if [ "$activity_process"z != "$process_name"z ];then
        _log "进入智能测温失败"  1
        return
fi 
_log "切换灰度成像模式"
input keyevent  23
sleep 1
_log "拍照并保存"
input keyevent 4 --longpress 4
sleep 3
_log "切换热成像模式" 
input keyevent  23
sleep 1
_log "拍照并保存"
input keyevent 4 --longpress 4
sleep 3
_log "切换灰度成像模式"
input keyevent  23
sleep 1
_log "拍照并保存"
input keyevent 4 --longpress 4
sleep 3
_log "切换热成像模式" 
input keyevent  23
sleep 1
_log "拍照并保存"
input keyevent 4 --longpress 4
sleep 3
enter_launcher_test  
}


#基础参数
SN=`getprop ro.boot.serialno`
OS_VERSION=`getprop ro.build.version.incremental`
GLASS_SN=`getprop persist.rokid.glass.sn`

#设备相关信息
ss=`seq -s 1 20 | sed 's/[0-9]/*/g'`
echo "$ss\n" >> $file_log
echo "Dock sn : $SN \nGlass sn : $GLASS_SN\nOS version : $OS_VERSION"  >> $file_log 
for i in `seq 1 $1`
do  
    sleep 1
    #开始测试
    echo "\n$ss\nBegin test, count is $count"  >> $file_log                                                                                                              
    scan_test             
    camera_test  $count
    gallery_test
    #ir_test
    document_test
    #appstore_test
    setting_test  
done
