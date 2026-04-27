from django import forms
from .models import Patient, Doctor, Appointment, Treatment, Bill


class PatientForm(forms.ModelForm):
    class Meta:
        model = Patient
        fields = ['name', 'age', 'gender', 'blood_group', 'phone', 'email', 'address', 'date_registered']
        widgets = {
            'date_registered': forms.DateInput(attrs={'type': 'date'}),
            'address': forms.Textarea(attrs={'rows': 3}),
        }


class DoctorForm(forms.ModelForm):
    class Meta:
        model = Doctor
        fields = ['name', 'specialization', 'phone', 'email', 'available_days', 'available_time']


class AppointmentForm(forms.ModelForm):
    class Meta:
        model = Appointment
        fields = ['patient', 'doctor', 'date', 'time', 'status', 'notes']
        widgets = {
            'date': forms.DateInput(attrs={'type': 'date'}),
            'time': forms.TimeInput(attrs={'type': 'time'}),
            'notes': forms.Textarea(attrs={'rows': 3}),
        }


class TreatmentForm(forms.ModelForm):
    class Meta:
        model = Treatment
        fields = ['appointment', 'diagnosis', 'prescription', 'notes', 'treatment_date']
        widgets = {
            'treatment_date': forms.DateInput(attrs={'type': 'date'}),
            'prescription': forms.Textarea(attrs={'rows': 4}),
            'notes': forms.Textarea(attrs={'rows': 3}),
        }


class BillForm(forms.ModelForm):
    class Meta:
        model = Bill
        fields = ['patient', 'appointment', 'amount', 'paid', 'date_issued', 'payment_method']
        widgets = {
            'date_issued': forms.DateInput(attrs={'type': 'date'}),
        }
