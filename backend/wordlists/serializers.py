from rest_framework import serializers
from .models import Wordlist
from django.contrib.auth.models import User
from django.contrib.auth.hashers import make_password

class WordListSerializer(serializers.ModelSerializer):
    class Meta:
        model = Wordlist
        fields = ["id", "user", "wordlist", "added_on"]

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ["id", "username", "first_name", "last_name", "email", "password"]
        extra_kwargs = {
            "password": {"write_only": True}
        }

    def create(self, validated_data):
        return User.objects.create_user(
            username=validated_data["username"],
            first_name=validated_data.get("first_name", ""),
            last_name=validated_data.get("last_name", ""),
            email=validated_data["email"],
            password=validated_data["password"],
        )