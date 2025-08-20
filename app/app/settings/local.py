from .settings import *

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': 'local-db',
        'USER': 'seun',
        'PASSWORD': 'SAMtos2009#',
        'HOST': 'localhost',
        'PORT': '5432',
     }
}
#DATABASES = {
#    "default": {
#        "ENGINE": "django.db.backends.sqlite3",
#        "NAME": BASE_DIR / "../db.sqlite3",  # adjust if the file lives elsewhere
#    }
#}
DEBUG = True

ALLOWED_HOSTS = ['127.0.0.1', 'localhost']

