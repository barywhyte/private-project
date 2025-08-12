from django.contrib import admin
from django.urls import path
from api.views import (
            home, health, info, portfolio,
            about_me, post_details, create_post,
            delete_post,list_all_posts,update_post
)
from django.urls import include

urlpatterns = [
    path('admin/', admin.site.urls, name='admin'),
    path('health', health, name='health'),
    path('info', info, name='info'),
    path('', home, name='home'),  # This will serve the index.html at the root URL
    path('about/', about_me, name='about_me'),
    path('', include('django_prometheus.urls')),  # ← this adds /metrics
    path('new_post/', create_post, name='create_post'),
    path('post/<int:id>/', post_details, name='post_details'),
    path('post/<int:id>/delete', delete_post, name='delete_post'),
    path('all_posts/', list_all_posts, name='list_all_posts'),
    path('post/<int:id>/edit/', update_post, name='update_post'),
    path('portfolio/', portfolio, name='portfolio'),

]
