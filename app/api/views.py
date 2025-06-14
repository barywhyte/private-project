from django.shortcuts import render
from django.http import JsonResponse
import random


def health(request):
    if random.random() < 1:  # always return 500 for testing
        return JsonResponse({"error": "simulated failure"}, status=500)
    return JsonResponse({"status": "ok!"}, status=200)

def info(request):
    return JsonResponse({"app": "Django API", "version": "3.7.0"})
