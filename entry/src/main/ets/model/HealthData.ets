export interface BpReading {
  systolic: number;
  diastolic: number;
  timestamp: string;
}

export interface Medication {
  name: string;
  dosage: string;
  scheduleTime: string;
}

export interface EmergencyContact {
  name: string;
  relation: string;
  phoneNumber: string;
}

export function getMockBloodPressureReadings(): BpReading[] {
  return [
    { systolic: 118, diastolic: 76, timestamp: '07-14 08:02' },
    { systolic: 122, diastolic: 79, timestamp: '07-13 08:05' },
    { systolic: 130, diastolic: 84, timestamp: '07-12 21:40' },
    { systolic: 121, diastolic: 78, timestamp: '07-12 08:00' },
    { systolic: 125, diastolic: 81, timestamp: '07-11 08:03' }
  ];
}

export function getMockMedications(): Medication[] {
  return [
    { name: 'Lisinopril', dosage: '10mg', scheduleTime: '08:00' },
    { name: 'Metformin', dosage: '500mg', scheduleTime: '13:00' },
    { name: 'Atorvastatin', dosage: '20mg', scheduleTime: '21:00' }
  ];
}

export function getMockEmergencyContacts(): EmergencyContact[] {
  return [
    { name: 'Ayşe Yılmaz', relation: 'Spouse', phoneNumber: '+90 532 000 0001' },
    { name: 'Dr. Mehmet Kaya', relation: 'Physician', phoneNumber: '+90 532 000 0002' },
    { name: 'Emre Yılmaz', relation: 'Son', phoneNumber: '+90 532 000 0003' }
  ];
}
