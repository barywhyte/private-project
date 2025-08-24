from django.shortcuts import render, redirect, get_object_or_404
from django.http import JsonResponse
from django.http import HttpResponse
from .forms import PostForm
from .models import Api
import json
from pathlib import Path
#from django.contrib import messages


def health(request):
    return JsonResponse({'status': 'all good!'}, status=200)

def info(request):
    return JsonResponse({"app": "Django API", "version": "7.1.0"})

def home(request):
    posts = Api.objects.all().order_by('-id')  # newest first
    return render(request, 'index.html', {'title': 'ST Blog - Home', 'posts': posts})

def about_me(request):
    message = {
        "me": "This is a little about me and my background. I am a Senior Infra and MLOPS Engineer. I am reachable on ",
        "mobile": 2348064686716,
        "email": "seunsamore@gmail.com",
        "my_list" : ["Python", "Django", "Machine Learning", "DevOps", "Cloud Computing", "Development", 10]
        }
    return render(request, 'about.html', message)

def create_post(request):
    this_form = PostForm
    if request.method == 'POST':
        this_form = PostForm(request.POST)
        if this_form.is_valid():
            this_form.save()
            return render(request, 'success.html')

    else:
        this_form = PostForm()
    return render(request, 'create_post.html', {'form':this_form})

def post_details(request, id):

    post = get_object_or_404(Api, id=id)
    return render(request, 'post_details.html', {'post': post})

def list_all_posts(request):
    posts = Api.objects.all()
    return render(request, 'list_posts.html', {'posts': posts})

def delete_post(request, id):
    post = get_object_or_404(Api, id=id)
    if request.method == 'POST':
        post.delete()
        return redirect('home')
    return render(request, 'delete_post.html', {'post': post})

def update_post(request, id):
    post = get_object_or_404(Api, id=id)
    if request.method == 'POST':
        form = PostForm(request.POST, instance=post)
        if form.is_valid():
            form.save()
            return redirect('post_details', id=post.id)
    else:
        form = PostForm(instance=post)

    return render(request, 'update_post.html', {'form': form, 'post': post})


def portfolio(request):
    profile_path = Path(__file__).resolve().parent.parent / "api" / "data" / "profile.json"
    with open(profile_path, "r") as f:
        profile_data = json.load(f)
    return render(request, "portfolio.html", profile_data)


