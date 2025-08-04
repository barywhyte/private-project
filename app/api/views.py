from django.shortcuts import render, redirect
from django.http import JsonResponse
from django.http import HttpResponse
from .forms import PostForm, RawForm
from .models import Api
#from django.contrib import messages


def health(request):
    #return JsonResponse({'status': 'something went wrong'}, status=500)
    return JsonResponse({'status': 'all good!'}, status=200)

def info(request):
    return JsonResponse({"app": "Django API", "version": "5.5.0"})

def home(request):

    return render(request, 'index.html', {'title': 'This API Is Under Maintenance. Please Check Back Later.'})

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

    try:
        obj = Api.objects.get(id=id)
        post_content = {
            "title": obj.title,
            "content": obj.contents,
            "price": obj.price,
            "author": obj.author,
            "description": obj.description,
            "featured": obj.featured
        }
        return render(request, 'index.html', post_content)
    except Api.DoesNotExist:
        return HttpResponse("Post not found", status=404)




