from django.db import models

# Create your models here.
class Api(models.Model):
    title = models.CharField(max_length=100)
    contents = models.TextField(max_length=500)
    price = models.DecimalField(max_digits=10, decimal_places=2, default=0.00)
    #date_created = models.DateTimeField(auto_now_add=True)
    #date_updated = models.DateTimeField(default='2025-01-01')
    author = models.CharField(max_length=50, default='Anonymous')
    description = models.TextField(blank=True, null=True)
    featured = models.BooleanField(default=False)
