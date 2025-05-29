from django.shortcuts import render

from django.http import JsonResponse

def health(request):
    return JsonResponse({"status": "ok"})

def info(request):
    return JsonResponse({"app": "Django API", "version": "1.0.0"})

