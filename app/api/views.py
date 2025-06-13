from django.shortcuts import render

from django.http import JsonResponse

def health(request):
    # Simulate failure
    return JsonResponse({"status": "temporarily not ready"}, status=500)

    #return JsonResponse({"status": "ok!"})

def info(request):
    return JsonResponse({"app": "Django API", "version": "3.2.0"})

