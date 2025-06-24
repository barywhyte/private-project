from django.contrib import admin
from django.urls import path
from api import views
from django.urls import include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('health', views.health),
    path('info', views.info),
    path('', views.home),  # This will serve the index.html at the root URL
    path('', include('django_prometheus.urls')),  # ← this adds /metrics
    path('post/', views.post),
    path('post/<int:id>/', views.post),
]
