from .settings import *
import os

import os

DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.postgresql",
        "NAME": os.getenv("postgres-db"),
        "USER": os.getenv("postgres-user"),
        "PASSWORD": os.getenv("postgres-password"),
        "HOST": os.getenv("POSTGRES_HOST", "db-postgresql.db.svc.cluster.local"),
        "PORT": os.getenv("POSTGRES_PORT", "5432"),
    }
}