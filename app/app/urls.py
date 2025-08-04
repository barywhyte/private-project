from django.contrib import admin
from django.urls import path
from api.views import home, health, info, about_me, post_details, create_post
from django.urls import include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('health', health),
    path('info', info),
    path('', home, name='home'),  # This will serve the index.html at the root URL
    path('about/', about_me),
    path('', include('django_prometheus.urls')),  # ← this adds /metrics
    path('post/', post_details),
    path('new_post/', create_post),
    path('post/<int:id>/', post_details),
]
