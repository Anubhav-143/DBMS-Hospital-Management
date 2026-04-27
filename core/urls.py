from django.urls import path
from . import views

urlpatterns = [
    path('', views.dashboard, name='dashboard'),

    # Patients
    path('patients/', views.PatientListView.as_view(), name='patient-list'),
    path('patients/add/', views.PatientCreateView.as_view(), name='patient-add'),
    path('patients/<int:pk>/edit/', views.PatientUpdateView.as_view(), name='patient-edit'),
    path('patients/<int:pk>/delete/', views.PatientDeleteView.as_view(), name='patient-delete'),

    # Doctors
    path('doctors/', views.DoctorListView.as_view(), name='doctor-list'),
    path('doctors/add/', views.DoctorCreateView.as_view(), name='doctor-add'),
    path('doctors/<int:pk>/edit/', views.DoctorUpdateView.as_view(), name='doctor-edit'),
    path('doctors/<int:pk>/delete/', views.DoctorDeleteView.as_view(), name='doctor-delete'),

    # Appointments
    path('appointments/', views.AppointmentListView.as_view(), name='appointment-list'),
    path('appointments/add/', views.AppointmentCreateView.as_view(), name='appointment-add'),
    path('appointments/<int:pk>/edit/', views.AppointmentUpdateView.as_view(), name='appointment-edit'),
    path('appointments/<int:pk>/delete/', views.AppointmentDeleteView.as_view(), name='appointment-delete'),

    # Treatments
    path('treatments/', views.TreatmentListView.as_view(), name='treatment-list'),
    path('treatments/add/', views.TreatmentCreateView.as_view(), name='treatment-add'),
    path('treatments/<int:pk>/edit/', views.TreatmentUpdateView.as_view(), name='treatment-edit'),

    # Bills
    path('bills/', views.BillListView.as_view(), name='bill-list'),
    path('bills/add/', views.BillCreateView.as_view(), name='bill-add'),
    path('bills/<int:pk>/edit/', views.BillUpdateView.as_view(), name='bill-edit'),
    path('bills/<int:pk>/pay/', views.mark_bill_paid, name='bill-pay'),
]
