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
    serializer_class = WordListSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        return Wordlist.objects.filter(user=self.request.user)

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)


@method_decorator(csrf_exempt, name='dispatch')
class CreateUserView(generics.CreateAPIView):
    serializer_class = UserSerializer
    permission_classes = [permissions.AllowAny]

