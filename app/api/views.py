from django.shortcuts import render

from django.http import JsonResponse

def health(request):
    return JsonResponse({"status": "all good!"})

def info(request):
    return JsonResponse({"app": "Django API", "version": "1.5.0"})

