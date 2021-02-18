from django.db import models

# Create your models here.
class User(models.Model):
    username = models.CharField(max_length = 64)
    headImg = models.FileField(upload_to= './upload/')
    #所以是用upload_to来指定文件存放的前缀路径

    def __str__(self):
        return self.username

class mypicture(models.Model):
    user = models.CharField(max_length=64)
    photo = models.ImageField(upload_to='photos', default='user1.jpg')