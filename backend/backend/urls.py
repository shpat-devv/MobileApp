from django.urls import path, include
from wordlists.views import *
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView

urlpatterns = [
    path("wordlist/", WordListView.as_view(), name="wordlist-view"),
    path("wordlist/delete/<int:id>/", WordListDeleteView.as_view(), name="wordlist-delete"),
    path('api/user/register/', CreateUserView.as_view(), name='register'),
    path('api/token/', TokenObtainPairView.as_view(), name='get_token'),
    path('api/token/refresh/', TokenRefreshView.as_view(), name='refresh'),
    path('api-auth/', include('rest_framework.urls')),
]
