from django.shortcuts import render
from django.http import JsonResponse
from django.http import HttpResponse

posts = [
    {
    "id" : 0,
    "title" : "Let\'s explore python",
    "contents": "This is beginner course to Django Python Framework"
    },
   {
    "id" : 1,
    "title" : "The big bang",
    "contents": "Introduction to big bang theory"
    },

    {
    "id" : 2,
    "title" : "The Ultimate Guide to Java",
    "contents": "This teaches you everything you need to know about Java programming language"
    }
]





def health(request):
    #return JsonResponse({'status': 'something went wrong'}, status=500)
    return JsonResponse({'status': 'all good!'}, status=200)

def info(request):
    return JsonResponse({"app": "Django API", "version": "5.3.0"})

def home(request):
    return render(request, 'index.html', {'title': 'This Site Is Under Maintenance. Please Check Back Later. Thank you!'})

def post(request, id=None):
    if id is None:
        links = "".join(
            f"<p><a href='/post/{p['id']}' style='color:white'>{p['title']}</a></p>"
            for p in posts
        )
        return render(request, 'index.html', {'content': links})

    for p in posts:
        if p['id'] == id:
            return render(request, 'index.html', {'title': p['title'], 'content': p['contents']})

    return HttpResponse("Post not found", status=404)


