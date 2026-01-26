from django.urls import path
from .views import WordListView

urlpatterns = [
    path("", WordListView.as_view(), name="wordlist-view"),
]
