from django.shortcuts import render
from django.http import JsonResponse


def health(request):
    #return JsonResponse({'status': 'something went wrong'}, status=500)
    return JsonResponse({'status': 'all good!'}, status=200)

def info(request):
    return JsonResponse({"app": "Django API", "version": "5.2.0"})
