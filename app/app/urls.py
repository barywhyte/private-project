from django.contrib import admin
from django.urls import path
from api.views import home, health, info, post, contact
from django.urls import include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('health', health),
    path('info', info),
    path('', home),  # This will serve the index.html at the root URL
    path('contact/', contact),
    path('', include('django_prometheus.urls')),  # ← this adds /metrics
    path('post/', post),
    path('post/<int:id>/', post),
]
