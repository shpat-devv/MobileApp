from django.db import models
from django.contrib.auth.models import User

# Create your models here.
class Wordlist(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name="wordlist")
    wordlist = models.CharField(max_length=30)
    added_on = models.DateField(auto_now=True)

    def __str__(self):
        return self.wordlist

