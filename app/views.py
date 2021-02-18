from django.shortcuts import render,render_to_response,HttpResponse, redirect
from django import forms #重点要导入,使用 Django 的 表单 
from django.http import HttpResponse
from django.contrib.auth.models import User
import os
from app.Data import Data
from app import models

# Create your views here.
class UserForm(forms.Form):
    username = forms.CharField()
    headImg = forms.FileField()

#函数register里面的形参request是必须要填的
#render()和render_to_response()均是django中用来显示模板页面的
#
def register(request):
    if request.method == "POST":
        uf = UserForm(request.POST,request.FILES) #还没有查到是什么意思
        #判断是否为有效的
        if uf.is_valid():
            #获取表单元素
            username = uf.cleaned_data['username']
            headImg = uf.cleaned_data['headImg']
            # 写入数据库
            user = User()
            user.username = username
            user.headImg = headImg
            user.save()
            return HttpResponse('upload ok!')
    else:
        uf = UserForm()
    return render_to_response('register.html',{'uf':uf})
    

def showUploadPage(request):
    return render_to_response("upload.html")

def upload(request):
    if request.method == "POST" and 'draw' in request.POST:
        # 上传文件
        file = request.FILES.get("myfile",None) # Get Upload
        if not file:
            return HttpResponse("no files for upload!")
        # make save path: uploaded file is saved in testdj/receive
        path = "receive"
        if not os.path.exists(path):
            os.makedirs(path)
        # save file: write in by chucks
        destination=open(os.path.join(path,file.name),'wb')
        for chunk in file.chunks():
            destination.write(chunk)
        destination.close()
        #作图
        a=Data()
        print(file.name)
        data=a.get_file_data("receive/"+file.name)
        name=a.data_draw(**data)
        #return HttpResponse(name, content_type='image/svg')
        return render_to_response('upload.html', {'newimage': name})       
    elif request.method == "POST" and 'photos' in request.POST:
        path="static"  # insert the path to your directory   
        s_list = os.listdir(path)   
        img_list = [element for element in s_list if ".svg" in element]
        print(img_list)
        return render_to_response('upload.html', {'images': img_list}) 

def showimg(request):
    imgs = models.mypicture.objects.all() # 查询导数据库所有图片
    # 创建一个字典来存储这些图片信息
    content = {
        'imgs': imgs
    }
    # 打印一下这些图片信息
    for i in imgs:
        # 输出一下信息内容
        print(i.photo)
    # 最后返回一下我们的展示网页，动态图片数据展示放进去
    return render(request, 'bbb.html', content)


def gallery(request):
    path="static"  # insert the path to your directory   
    img_list =os.listdir(path)   
    return render_to_response('upload.html', {'images': img_list})