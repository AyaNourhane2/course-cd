from django.db import models

class Course(models.Model):
    name = models.CharField(max_length=200)
    instructor = models.CharField(max_length=150)
    category = models.CharField(max_length=100, blank=True, null=True)
    description = models.TextField(blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.name} - {self.instructor}"


class CourseSchedule(models.Model):
    WEEK_DAYS = [
        ('MON', 'Monday'),
        ('TUE', 'Tuesday'),
        ('WED', 'Wednesday'),
        ('THU', 'Thursday'),
        ('FRI', 'Friday'),
        ('SAT', 'Saturday'),
        ('SUN', 'Sunday'),
    ]

    course = models.ForeignKey(Course, related_name='schedules', on_delete=models.CASCADE)
    day = models.CharField(max_length=3, choices=WEEK_DAYS)
    start_time = models.TimeField()
    end_time = models.TimeField()
    location = models.CharField(max_length=200, blank=True, null=True)

    class Meta:
        ordering = ['day', 'start_time']

    def __str__(self):
        return f"{self.course.name} - {self.day} {self.start_time}-{self.end_time}"
