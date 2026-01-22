from rest_framework import serializers
from .models import Wordlist
from django.contrib.auth.models import User

class WordListSerializer(serializers.ModelSerializer):
    class Meta:
        model = Wordlist
        fields = ["id", "user", "wordlist", "added_on"]

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ["id", "username", "first_name", "last_name", "email", "password"]