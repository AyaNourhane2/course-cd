from rest_framework import serializers
from .models import Course, CourseSchedule

class CourseScheduleSerializer(serializers.ModelSerializer):
    class Meta:
        model = CourseSchedule
        fields = ['id', 'day', 'start_time', 'end_time', 'location']


class CourseSerializer(serializers.ModelSerializer):
    schedules = CourseScheduleSerializer(many=True, required=False)

    class Meta:
        model = Course
        fields = ['id', 'name', 'instructor', 'category', 'description', 'created_at', 'schedules']

    def create(self, validated_data):
        schedules_data = validated_data.pop('schedules', [])
        course = Course.objects.create(**validated_data)
        for s in schedules_data:
            CourseSchedule.objects.create(course=course, **s)
        return course

    def update(self, instance, validated_data):
        schedules_data = validated_data.pop('schedules', None)

        for attr, value in validated_data.items():
            setattr(instance, attr, value)
        instance.save()

        if schedules_data is not None:
            instance.schedules.all().delete()
            for s in schedules_data:
                CourseSchedule.objects.create(course=instance, **s)

        return instance
