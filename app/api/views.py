from django.shortcuts import render

from django.http import JsonResponse

def health(request):
    # Simulate failure
    return JsonResponse({"status": "not good at all!"}, status=503)
    #return JsonResponse({"status": "ok!"})

def info(request):
    return JsonResponse({"app": "Django API", "version": "2.7.0"})

