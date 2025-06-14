from django.shortcuts import render
from django.http import JsonResponse

def is_app_healthy():
    return False # Simulate a health check function; replace with actual logic

def health(request):
    if is_app_healthy():
        return JsonResponse({"status": "ok!"}, status=200)
    else:
        return JsonResponse({"status": "temporarily not ready"}, status=500)

def info(request):
    return JsonResponse({"app": "Django API", "version": "3.4.0"})
