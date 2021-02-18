from django.http import HttpResponse
from django.http import HttpResponseRedirect
from django.shortcuts import render
#from .forms import UploadFileForm
 
def hello(request):
    return HttpResponse("Hello world ! ")