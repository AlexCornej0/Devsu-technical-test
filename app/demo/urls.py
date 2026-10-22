from django.contrib import admin
from django.urls import include, path

from . import health

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/', include('api.urls')),
    path('health/live', health.live, name='health-live'),
    path('health/ready', health.ready, name='health-ready'),
]
