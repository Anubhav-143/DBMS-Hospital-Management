from django.db import models
from django.utils import timezone


class Patient(models.Model):
    GENDER_CHOICES = [
        ('M', 'Male'),
        ('F', 'Female'),
        ('O', 'Other'),
    ]
    BLOOD_GROUP_CHOICES = [
        ('A+', 'A+'), ('A-', 'A-'),
        ('B+', 'B+'), ('B-', 'B-'),
        ('AB+', 'AB+'), ('AB-', 'AB-'),
        ('O+', 'O+'), ('O-', 'O-'),
    ]

    name = models.CharField(max_length=200)
    age = models.PositiveIntegerField()
    gender = models.CharField(max_length=1, choices=GENDER_CHOICES)
    blood_group = models.CharField(max_length=3, choices=BLOOD_GROUP_CHOICES)
    phone = models.CharField(max_length=20)
    email = models.EmailField(blank=True, null=True)
    address = models.TextField(blank=True)
    date_registered = models.DateField(default=timezone.now)

    class Meta:
        ordering = ['-date_registered']

    def __str__(self):
        return self.name


class Doctor(models.Model):
    name = models.CharField(max_length=200)
    specialization = models.CharField(max_length=200)
    phone = models.CharField(max_length=20)
    email = models.EmailField(blank=True, null=True)
    available_days = models.CharField(max_length=200, help_text='e.g. Mon, Wed, Fri')
    available_time = models.CharField(max_length=100, help_text='e.g. 9:00 AM - 5:00 PM')

    class Meta:
        ordering = ['name']

    def __str__(self):
        return f"Dr. {self.name} ({self.specialization})"


class Appointment(models.Model):
    STATUS_CHOICES = [
        ('Scheduled', 'Scheduled'),
        ('Completed', 'Completed'),
        ('Cancelled', 'Cancelled'),
    ]

    patient = models.ForeignKey(Patient, on_delete=models.CASCADE, related_name='appointments')
    doctor = models.ForeignKey(Doctor, on_delete=models.CASCADE, related_name='appointments')
    date = models.DateField()
    time = models.TimeField()
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='Scheduled')
    notes = models.TextField(blank=True)

    class Meta:
        ordering = ['-date', '-time']

    def __str__(self):
        return f"{self.patient.name} with {self.doctor.name} on {self.date}"


class Treatment(models.Model):
    appointment = models.OneToOneField(Appointment, on_delete=models.CASCADE, related_name='treatment')
    diagnosis = models.CharField(max_length=500)
    prescription = models.TextField()
    notes = models.TextField(blank=True)
    treatment_date = models.DateField(default=timezone.now)

    class Meta:
        ordering = ['-treatment_date']

    def __str__(self):
        return f"Treatment for {self.appointment.patient.name} on {self.treatment_date}"


class Bill(models.Model):
    PAYMENT_METHOD_CHOICES = [
        ('Cash', 'Cash'),
        ('Card', 'Card'),
        ('Insurance', 'Insurance'),
        ('Online', 'Online'),
    ]

    patient = models.ForeignKey(Patient, on_delete=models.CASCADE, related_name='bills')
    appointment = models.ForeignKey(Appointment, on_delete=models.CASCADE, related_name='bills')
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    paid = models.BooleanField(default=False)
    date_issued = models.DateField(default=timezone.now)
    payment_method = models.CharField(max_length=20, choices=PAYMENT_METHOD_CHOICES, blank=True)

    class Meta:
        ordering = ['-date_issued']

    def __str__(self):
        status = "Paid" if self.paid else "Unpaid"
        return f"Bill #{self.id} - {self.patient.name} - ${self.amount} ({status})"
