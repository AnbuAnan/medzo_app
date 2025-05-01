enum ApiKeyEnum {
//Base Url
baseUrl('http://13.201.223.171:8090/api'),

//Common response values
  //Tokens 
  accesstoken('access_token'),
  refreshtoken('refresh_token'),

  //Message
  message('message'),
  error('error'),
  status('status'),
  statusMessage('statusMessage'),
  appointmenCreated('APPOINTMENT_CREATED'),
  precheckCompleted('PRE-CHECK_COMPLETED'),

  //start & end Date
  startDate('startDate'),
  endDate('endDate'),
  date('date'),
  month('month'),
  year('year'),

  //start & end Time
  startTime('startTime'),
  endTime('endTime'),

  //Bool Values
  trueLowerCase('true'),
  trueUpperCase('TRUE'),
  

  //Files
  profilePicUrlText('profile-pic-url'),
  profile('profile'),
  profilePic('profilePic'),
  license('license'),
  prescription('prescription'),
  report('report'),

    //Files related Apis endpoints param
    presignedUrl('presigned-url'),
    bucketName('bucketName'),
    medzobucket('medzobucket'),
    keyValue('key'),
    medzoFolder('medzoFolder'),
    expirationMinutes('expirationMinutes'),
    expirationMinutesValue('5'),
    isUpload('isUpload'),

  //Apt Types
  exsitingUpperCase('EXISTING'),
  exsitingLowerCase('existing'),


  //Doctor
  doctorId('doctorId'),
  firstName('firstName'),
  lastName('lastName'),
  phone('phone'),
  email('email'),
  speciality('speciality'),

    //Doctor related Apis endpoint
    getDoctorDetails('getDoctorDetails'),
    updateDoctor('updateDoctor'),

  //Assistant 
  name('name'),
  mobileNumber('mobileNumber'),//
  designation('designation'),//
  password('password'),
  loginId('loginId'),
  userId('userId'),
  assistantId('assistantId'),

    //Assistant related Apis endpoints
    getUserDetailsList('getUserDetailsList'),
    getUserDetails('getUserDetails'),
    validateUserDetails('validateUserDetails'),
    createUser('createUser'),
    updateUser('updateUser'),
    deleteUser('deleteUser'),


  //Patients
  patientId('patientId'),
  patientName('patientName'),

    //Patient Related Apis endpoints
    outDatedPatient('outDatedPatient'),
    getPatientProfile('getPatientProfile'),
    getPatientDetail('getPatientDetail'),
    getPatientDetails('getPatientDetails'),
    createPatientDetails('createPatientDetails'),
    updatePatientDetails('updatePatientDetails'),
    createPatientHistory('createPatientHistory'),
    updatePatientHistory('updatePatientHistory'),
    validatePatientDetail('validatePatientDetail'),
    aadhaarNumberParamValue('aadhaarNumber'),
    mobileNumberParamValue('mobileNumber'),

    
    

  //Register Form
  patientType('patientType'),
  aadhaarNo('aadhaarNo'),
  dob('dob'),
  age('age'),
  gender('gender'),
  referredBy('referredBy'),

  //Past Histroy Form
  appointmentType('appointmentType'),
  comment('comment'),
  otherSubstance('otherSubstance'),
  othersSubstanceUseContainText('Others substance use'),
  nicotineUse('nicotineUse'),
  nicotineUseContainsText('Nicotine use'),
  alcoholUse('alcoholUse'),
  alcoholUseContainsText('Alcohol use'),
  comorbidity('comorbidity'),
  chiefComplaint('chiefComplaint'),
  pastHistoryComment('pastHistoryComment'),
  pastHistory('pastHistory'),
  pastHistoryId('pastHistoryId'),
  patientHistoryId('patientHistoryId'),
  diabetesMellitus('diabetesMellitus'),
  hypertension('hypertension'),
  bronchialAsthma('bronchialAsthma'),
  seizureDisorder('seizureDisorder'),
  coronaryArteryDisease('coronaryArteryDisease'),
  cerebrovascularDisease('cerebrovascularDisease'),
  tuberculosis('tuberculosis'),
  headInjury('headInjury'),
  anySurgery('anySurgery'),






  //Slots
  slotId('slotId'),
  isBooked('isBooked'),

    //Slot related api endpoints
    createAppointmentSlot('createAppointmentSlot'),
    deleteSlot('deleteSlot'),
    getAppointmentSlot('getAppointmentSlot'),



  //Appointment
  appointmentId('appointmentId'),
  appointmentTimeId('appointmentTimeId'),
  appointmentTimeDetailsList('appointmentTimeDetailsList'),
  consultationStatus('consultationStatus'),
  patientStatus('patientStatus'),

    //Appointments related Apis endpoints
    getAppointmentSlotDayWise('getAppointmentSlotDayWise'),
    getAppointmentList("getAppointmentList"),
    getAppointment('getAppointment'),
    createAppointment('createAppointment'),
    deleteAppointment('deleteAppointment'),



  //Precheck 
  preCheckId('preCheckId'),
  height('height'),
  weight('weight'),
  bloodPressure('bloodPressure'),
  pulseRate('pulseRate'),
  bodyTemperature('bodyTemperature'),
  oxygenSaturation('oxygenSaturation'),

    //Crate and update
    createPreCheckDetails('createPreCheckDetails'),
    updatePreCheckDetails('updatePreCheckDetails'),
    getPreCheckDetails('getPreCheckDetails'),



  //Consultation
  consultationId('consultationId'),
  diagnoses('diagnoses'),
  labInvestigation('labInvestigation'),
  audioComplaint('audioComplaint'),
  reminder('reminder'),
  followUpDate('followUpDate'),
  
    //Consulatation related Apis endpoints
     getConsultationDetailsList('getConsultationDetailsList'),
     getConsultation('getConsultation'),
     createConsultation('createConsultation'),
     updateConsultation('updateConsultation'),
     reviewDetails('reviewDetails'),


  //Followup 
    followUpId("followUpId"),
    localDate('localDate'),

      //Followup related Apis endpoints
      getFollowUpDetails('getFollowUpDetails'),
      findBtwDates("findBetweenDates"),
      createFollowUp("createFollowUp"),
      updateFollowUp('updateFollowUp'),
      deleteFollowUp('deleteFollowUp'),



//Get Support Details
  getSupportDetails("getSupportDetails"),
    //response
    supportEmail("supportEmail"),
    supportPhoneNumber("supportPhoneNumber"),

//Phone number verification
phoneNumber('phoneNumber'),
validateOtp('validateOtp'),
otpNumber('otpNumber'),

  fies("");

  final String key;
  const ApiKeyEnum(this.key);
}
