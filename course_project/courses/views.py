from rest_framework import viewsets, filters
from django_filters.rest_framework import DjangoFilterBackend
from .models import Course
from .serializers import CourseSerializer

class CourseViewSet(viewsets.ModelViewSet):
    queryset = Course.objects.all().order_by('-created_at')
    serializer_class = CourseSerializer
    
    # تفعيل الفلترة والبحث والترتيب
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]

    # فلترة حسب الحقول
    filterset_fields = ['category', 'instructor']

    # البحث النصي
    search_fields = ['name', 'instructor', 'category', 'description']

    # الترتيب
    ordering_fields = ['created_at', 'name']
    ordering = ['-created_at']
