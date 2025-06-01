from django.shortcuts import render

from django.http import JsonResponse

def health(request):
    return JsonResponse({"status": "okay"})

def info(request):
    return JsonResponse({"app": "Django API", "version": "1.4.0"})

