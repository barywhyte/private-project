from .settings import *

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': 'local-db',
        'USER': 'seun',
        'PASSWORD': 'samtos2009',
        'HOST': 'localhost',
        'PORT': '5432',
     }
}

# Static files
STATIC_URL = '/static/'
STATIC_ROOT = BASE_DIR / 'staticfiles'

# WhiteNoise Middleware
MIDDLEWARE.insert(1, 'whitenoise.middleware.WhiteNoiseMiddleware')

# Enable GZip and caching
STATICFILES_STORAGE = 'whitenoise.storage.CompressedManifestStaticFilesStorage'

#DATABASES = {
#    "default": {
#        "ENGINE": "django.db.backends.sqlite3",
#        "NAME": BASE_DIR / "../db.sqlite3",  # adjust if the file lives elsewhere
#    }
#}
DEBUG = True

ALLOWED_HOSTS = ['127.0.0.1', 'localhost']

