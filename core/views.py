from django.shortcuts import render, get_object_or_404, redirect
from django.contrib import messages
from django.views.generic import ListView, CreateView, UpdateView, DeleteView
from django.urls import reverse_lazy
from .models import Patient, Doctor, Appointment, Treatment, Bill
from .forms import PatientForm, DoctorForm, AppointmentForm, TreatmentForm, BillForm


def dashboard(request):
    context = {
        'total_patients': Patient.objects.count(),
        'total_doctors': Doctor.objects.count(),
        'total_appointments': Appointment.objects.count(),
        'total_treatments': Treatment.objects.count(),
        'total_bills': Bill.objects.count(),
        'unpaid_bills': Bill.objects.filter(paid=False).count(),
        'recent_appointments': Appointment.objects.select_related('patient', 'doctor').order_by('-date')[:5],
        'recent_patients': Patient.objects.order_by('-date_registered')[:5],
    }
    return render(request, 'dashboard.html', context)


# Patient Views
class PatientListView(ListView):
    model = Patient
    template_name = 'patients/list.html'
    context_object_name = 'patients'
    paginate_by = 10


class PatientCreateView(CreateView):
    model = Patient
    form_class = PatientForm
    template_name = 'patients/form.html'
    success_url = reverse_lazy('patient-list')

    def form_valid(self, form):
        messages.success(self.request, 'Patient registered successfully.')
        return super().form_valid(form)

    def get_context_data(self, **kwargs):
        ctx = super().get_context_data(**kwargs)
        ctx['title'] = 'Add Patient'
        return ctx


class PatientUpdateView(UpdateView):
    model = Patient
    form_class = PatientForm
    template_name = 'patients/form.html'
    success_url = reverse_lazy('patient-list')

    def form_valid(self, form):
        messages.success(self.request, 'Patient updated successfully.')
        return super().form_valid(form)

    def get_context_data(self, **kwargs):
        ctx = super().get_context_data(**kwargs)
        ctx['title'] = 'Edit Patient'
        return ctx


class PatientDeleteView(DeleteView):
    model = Patient
    template_name = 'patients/confirm_delete.html'
    success_url = reverse_lazy('patient-list')

    def form_valid(self, form):
        messages.success(self.request, 'Patient deleted successfully.')
        return super().form_valid(form)


# Doctor Views
class DoctorListView(ListView):
    model = Doctor
    template_name = 'doctors/list.html'
    context_object_name = 'doctors'
    paginate_by = 10


class DoctorCreateView(CreateView):
    model = Doctor
    form_class = DoctorForm
    template_name = 'doctors/form.html'
    success_url = reverse_lazy('doctor-list')

    def form_valid(self, form):
        messages.success(self.request, 'Doctor added successfully.')
        return super().form_valid(form)

    def get_context_data(self, **kwargs):
        ctx = super().get_context_data(**kwargs)
        ctx['title'] = 'Add Doctor'
        return ctx


class DoctorUpdateView(UpdateView):
    model = Doctor
    form_class = DoctorForm
    template_name = 'doctors/form.html'
    success_url = reverse_lazy('doctor-list')

    def form_valid(self, form):
        messages.success(self.request, 'Doctor updated successfully.')
        return super().form_valid(form)

    def get_context_data(self, **kwargs):
        ctx = super().get_context_data(**kwargs)
        ctx['title'] = 'Edit Doctor'
        return ctx


class DoctorDeleteView(DeleteView):
    model = Doctor
    template_name = 'doctors/confirm_delete.html'
    success_url = reverse_lazy('doctor-list')

    def form_valid(self, form):
        messages.success(self.request, 'Doctor deleted successfully.')
        return super().form_valid(form)


# Appointment Views
class AppointmentListView(ListView):
    model = Appointment
    template_name = 'appointments/list.html'
    context_object_name = 'appointments'
    paginate_by = 10

    def get_queryset(self):
        return Appointment.objects.select_related('patient', 'doctor').order_by('-date')


class AppointmentCreateView(CreateView):
    model = Appointment
    form_class = AppointmentForm
    template_name = 'appointments/form.html'
    success_url = reverse_lazy('appointment-list')

    def form_valid(self, form):
        messages.success(self.request, 'Appointment scheduled successfully.')
        return super().form_valid(form)

    def get_context_data(self, **kwargs):
        ctx = super().get_context_data(**kwargs)
        ctx['title'] = 'Schedule Appointment'
        return ctx


class AppointmentUpdateView(UpdateView):
    model = Appointment
    form_class = AppointmentForm
    template_name = 'appointments/form.html'
    success_url = reverse_lazy('appointment-list')

    def form_valid(self, form):
        messages.success(self.request, 'Appointment updated successfully.')
        return super().form_valid(form)

    def get_context_data(self, **kwargs):
        ctx = super().get_context_data(**kwargs)
        ctx['title'] = 'Edit Appointment'
        return ctx


class AppointmentDeleteView(DeleteView):
    model = Appointment
    template_name = 'appointments/confirm_delete.html'
    success_url = reverse_lazy('appointment-list')

    def form_valid(self, form):
        messages.success(self.request, 'Appointment deleted successfully.')
        return super().form_valid(form)


# Treatment Views
class TreatmentListView(ListView):
    model = Treatment
    template_name = 'treatments/list.html'
    context_object_name = 'treatments'
    paginate_by = 10

    def get_queryset(self):
        return Treatment.objects.select_related('appointment__patient', 'appointment__doctor')


class TreatmentCreateView(CreateView):
    model = Treatment
    form_class = TreatmentForm
    template_name = 'treatments/form.html'
    success_url = reverse_lazy('treatment-list')

    def form_valid(self, form):
        messages.success(self.request, 'Treatment recorded successfully.')
        return super().form_valid(form)

    def get_context_data(self, **kwargs):
        ctx = super().get_context_data(**kwargs)
        ctx['title'] = 'Add Treatment'
        return ctx


class TreatmentUpdateView(UpdateView):
    model = Treatment
    form_class = TreatmentForm
    template_name = 'treatments/form.html'
    success_url = reverse_lazy('treatment-list')

    def form_valid(self, form):
        messages.success(self.request, 'Treatment updated successfully.')
        return super().form_valid(form)

    def get_context_data(self, **kwargs):
        ctx = super().get_context_data(**kwargs)
        ctx['title'] = 'Edit Treatment'
        return ctx


# Bill Views
class BillListView(ListView):
    model = Bill
    template_name = 'bills/list.html'
    context_object_name = 'bills'
    paginate_by = 10

    def get_queryset(self):
        return Bill.objects.select_related('patient', 'appointment')


class BillCreateView(CreateView):
    model = Bill
    form_class = BillForm
    template_name = 'bills/form.html'
    success_url = reverse_lazy('bill-list')

    def form_valid(self, form):
        messages.success(self.request, 'Bill created successfully.')
        return super().form_valid(form)

    def get_context_data(self, **kwargs):
        ctx = super().get_context_data(**kwargs)
        ctx['title'] = 'Create Bill'
        return ctx


class BillUpdateView(UpdateView):
    model = Bill
    form_class = BillForm
    template_name = 'bills/form.html'
    success_url = reverse_lazy('bill-list')

    def form_valid(self, form):
        messages.success(self.request, 'Bill updated successfully.')
        return super().form_valid(form)

    def get_context_data(self, **kwargs):
        ctx = super().get_context_data(**kwargs)
        ctx['title'] = 'Edit Bill'
        return ctx


def mark_bill_paid(request, pk):
    bill = get_object_or_404(Bill, pk=pk)
    if request.method == 'POST':
        bill.paid = True
        if not bill.payment_method:
            bill.payment_method = request.POST.get('payment_method', 'Cash')
        bill.save()
        messages.success(request, f'Bill #{bill.id} marked as paid.')
        return redirect('bill-list')
    return render(request, 'bills/mark_paid.html', {'bill': bill})
