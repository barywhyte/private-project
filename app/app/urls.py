from django.contrib import admin
from django.urls import path
from api import views
from django.urls import include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('health', views.health),
    path('info', views.info),
    path('', include('django_prometheus.urls')),  # ← this adds /metrics
]
