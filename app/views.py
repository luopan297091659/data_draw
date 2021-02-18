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
    if request.method == "POST" and 'upload' in request.POST:
        # get file
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
        with open(os.path.join(path,file.name), mode='r', encoding = 'utf-8') as f:
            c = f.read()
        return HttpResponse(c)
    elif request.method == "POST" and 'draw' in request.POST:
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
        with open(os.path.join(path,file.name), mode='r', encoding = 'utf-8') as f:
            c = f.read()
        #return HttpResponse(c)
        a=Data()
        data=a.get_ping_data("app/1.txt")
        name=a.data_draw("ping", a=data)
        return HttpResponse(name, content_type='image/svg')

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