import 'package:flutter/material.dart';

class Specialty {
  final String name;
  final IconData icon;
  final int doctorsCount;
  final String category; // 'primary', 'surgical', 'pediatric', 'other'
  final bool isLive;
  final Color? color;

  const Specialty({
    required this.name,
    required this.icon,
    required this.doctorsCount,
    required this.category,
    this.isLive = true,
    this.color,
  });
}

class DoctorReview {
  final String reviewerName;
  final String reviewerInitials;
  final String timeAgo;
  final double rating;
  final String comment;

  const DoctorReview({
    required this.reviewerName,
    required this.reviewerInitials,
    required this.timeAgo,
    required this.rating,
    required this.comment,
  });
}

class DoctorTimelineItem {
  final String title;
  final String institution;
  final String period;
  final bool isCurrent;

  const DoctorTimelineItem({
    required this.title,
    required this.institution,
    required this.period,
    this.isCurrent = false,
  });
}

class Doctor {
  final String id;
  final String name;
  final String specialty;
  final String hospital;
  final double rating;
  final int reviewsCount;
  final int experienceYears;
  final double distanceKm;
  final int consultationFee;
  final String avatarUrl;
  final bool isVerified;
  final bool availableToday;
  final bool isVideoVisitAvailable;
  bool isBookmarked;

  // Detailed profile fields
  final String credentials;
  final String patientCount;
  final String bio;
  final String languages;
  final List<String> services;
  final List<DoctorTimelineItem> timeline;
  final String clinicAddress;
  final String clinicDistance;
  final String clinicPhone;
  final List<DoctorReview> reviews;

  Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.hospital,
    required this.rating,
    required this.reviewsCount,
    required this.experienceYears,
    required this.distanceKm,
    required this.consultationFee,
    required this.avatarUrl,
    this.isVerified = true,
    this.availableToday = true,
    this.isVideoVisitAvailable = true,
    this.isBookmarked = false,
    this.credentials = 'MD, FACC · Senior Cardiologist',
    this.patientCount = '1,200+',
    this.bio =
        'Dr. Sarah Johnson is a board-certified specialist with over 12 years of specialized clinical experience in patient care, preventive disease management, and specialized imaging. Dedicated to evidence-based, compassionate care.',
    this.languages = 'English (Fluent), Spanish, Hindi',
    this.services = const [
      'Echocardiogram (ECG/EKG)',
      'Heart Stress Testing',
      'Hypertension Care',
      'Coronary Angiogram',
      'Preventive Cardiology',
      'Holter Monitoring',
    ],
    this.timeline = const [
      DoctorTimelineItem(
        title: 'Senior Specialist',
        institution: 'St. Jude Heart Institute',
        period: '2018 – Present',
        isCurrent: true,
      ),
      DoctorTimelineItem(
        title: 'Associate Specialist',
        institution: 'Metro Health Center',
        period: '2015 – 2018',
      ),
      DoctorTimelineItem(
        title: 'Fellowship (FACC)',
        institution: 'American College of Cardiology',
        period: '2015',
      ),
      DoctorTimelineItem(
        title: 'Residency in Internal Medicine',
        institution: 'Mayo Clinic College of Medicine',
        period: '2015',
      ),
      DoctorTimelineItem(
        title: 'MD in Cardiovascular Medicine',
        institution: 'Johns Hopkins University School of Medicine',
        period: '2012',
      ),
    ],
    this.clinicAddress =
        '450 Medical Boulevard, Suite 302, Downtown Medical District',
    this.clinicDistance = '1.2 km away · 8 min drive',
    this.clinicPhone = '+1 (555) 234-8900',
    this.reviews = const [
      DoctorReview(
        reviewerName: 'Emily R.',
        reviewerInitials: 'ER',
        timeAgo: '2 days ago',
        rating: 5.0,
        comment:
            'Dr. Sarah Johnson was incredibly thorough and patient during my cardiovascular checkup. She answered every question with kindness and expertise. Highly recommend!',
      ),
      DoctorReview(
        reviewerName: 'David K.',
        reviewerInitials: 'DK',
        timeAgo: '1 week ago',
        rating: 5.0,
        comment:
            'Very professional clinic and punctual consultation. The diagnosis was crystal clear.',
      ),
    ],
  });

  String get imageUrl => avatarUrl;
}
