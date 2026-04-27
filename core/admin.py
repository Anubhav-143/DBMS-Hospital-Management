from django.contrib import admin
from .models import Patient, Doctor, Appointment, Treatment, Bill


@admin.register(Patient)
class PatientAdmin(admin.ModelAdmin):
    list_display = ['name', 'age', 'gender', 'blood_group', 'phone', 'email', 'date_registered']
    search_fields = ['name', 'email', 'phone']
    list_filter = ['gender', 'blood_group']


@admin.register(Doctor)
class DoctorAdmin(admin.ModelAdmin):
    list_display = ['name', 'specialization', 'phone', 'email', 'available_days']
    search_fields = ['name', 'specialization', 'email']
    list_filter = ['specialization']


@admin.register(Appointment)
class AppointmentAdmin(admin.ModelAdmin):
    list_display = ['patient', 'doctor', 'date', 'time', 'status']
    list_filter = ['status', 'date']
    search_fields = ['patient__name', 'doctor__name']


@admin.register(Treatment)
class TreatmentAdmin(admin.ModelAdmin):
    list_display = ['appointment', 'diagnosis', 'treatment_date']
    search_fields = ['diagnosis', 'appointment__patient__name']


@admin.register(Bill)
class BillAdmin(admin.ModelAdmin):
    list_display = ['patient', 'appointment', 'amount', 'paid', 'date_issued', 'payment_method']
    list_filter = ['paid', 'payment_method']
    search_fields = ['patient__name']
