from django.http import HttpResponse
from rest_framework import generics
from rest_framework import permissions
from .models import Wordlist
from django.contrib.auth import get_user_model
from .serializers import WordListSerializer, UserSerializer
from django.views.decorators.csrf import csrf_exempt
from django.utils.decorators import method_decorator

User = get_user_model()

class WordListView(generics.ListCreateAPIView):
    queryset = Wordlist.objects.all()
    serializer_class = WordListSerializer
    permission_classes = [permissions.IsAuthenticated]

@method_decorator(csrf_exempt, name='dispatch')
class CreateUserView(generics.ListCreateAPIView):
    queryset = User.objects.all()
    serializer_class = UserSerializer