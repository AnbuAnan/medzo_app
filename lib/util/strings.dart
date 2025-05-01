class Strings {
  Strings._();

  //AppRoute
  static const String appRoutePhNoVerify = 'phNoVerify';
  static const String appRouteOtpVerify = 'otpVerify';
  static const String appRoutePatientProfileView = 'patientProfileview';

  //Phone call and Email extention
  static String callScheme = 'tel';
  static String emailScheme = 'mailto';
  static String querySubject = 'subject';
  static String queryBody = 'body';

  //Symbols
  static String forwardSlashSymbol = '/';
  static String percentangeSymbol = '%';
  static String questionMarkSymbol = '?';
  static String dotSymbol = '.';
  static String equalSymbol = '=';
  static String andSymbol = '&';
  static String colonSymbol = ':';
  static String ninetyOneNo = '91';
  static String zeroOneNo = '01';

  //Time Period and Error
  static String amTimeLabel = 'AM';
  static String pmTimeLabel = 'PM';
  static String timeLabel = 'time';
  static String periodLabel = 'period';
  static String doubleZeroLabel = '00';
  static String singleZeroLabel = '0';
  static String timeErrthrow = 'Hour must be between 0 and 23';

  //Files Types and Extentions
  static List<String> allowedExtensionsPdf = ['pdf'];
  static String allowedExtensionsPdfText = 'pdf';
  static List<String> allowedExtensionsImg = ['png', 'jpg', 'jpeg'];
  static String kbFileSize = ' KB';
  static String mbFileSize = ' MB';
  static String doctorProfileFileName = 'DoctorProfile';
  static String assistantProfileFileName = 'AssistantProfile';
  static String licenseFileName = 'License';
  static String profileFileName = 'Profile';

  //common
  static String assetsNaviagtionText = 'assets/';
  static String pgNo3 = '3';
  static String searchText = 'Search';
  static String activeText = 'active';
  static String inActiveText = 'inactive';
  static const String successLowerCaseText = 'success';
  static String successUpperCaseText = 'SUCCESS';
  static String whoopsLowerCaseText = 'whoops';
  static String completedUpperCaseText = 'COMPLETED';
  static const String warningLowerCaseText = 'warning';
  static const String errorLowerCaseText = 'error';
  static const String infoLowerCaseText = 'info';
  static String deleteSuccessfullyText = 'Delete successfully';
  static String sText = 's';
  static String nilText = 'Nil';
  static String existingTextforApiCheck = 'EXISTING';
  static String newTextforApiCheck = 'NEW';
  static String noText = 'No';
  static String yesText = 'Yes';
  static String trySearchText = 'Try Search';
  static String unknownTxt = 'Unknown';
  static String barrierLabel = 'Barrier';
  static String falseLowerCaseTxt = 'false';
  static String unknownErrorTxt = 'Unknown error occured. Please try again';
  static String networkErrorTxt =
      'Please check your network connection and try again.';
  static String reqTooLongErrorTxt =
      'The request took too long to process. Try again later.';
  static String someThingWentWrongErrorTxt =
      'Oops! Something went wrong. Attempting to reconnect...';
  static String encounteredErrorTxt =
      'We encountered an issue. Refresh and try again.';
  static String retryErrorTxt = 'Oops! Something went wrong. Retrying...';
  static String retryBtnText = 'Retry';
  static String errorTextUpperCase = 'ERROR';
  static String hypenText = '-';
  static String underscoreText = '_';
  static String fileUploadText = 'Uploaded file';
  static String optnltxt = '(optional)';
  static String mandatorySymbol = ' *';
  static String undefiendText = 'Undefined';
  static String rescheduleBtnText = 'Re-Schedule';
  static const String rescheduleBtnPopupMenuValue = 'Re-Schedule';
  static String okayBtnText = 'Okay';
  static String cancelBtnText = 'Cancel';
  static const String copyText = 'Copy';
  static String confirmBtnText = 'Confirm';
  static String confirmingBtnText = 'Confirming...';
  static String processingmBtnText = 'Processing';
  static String deleteBtnText = 'Delete';
  static String removeText = 'remove';
  static const String deleteBtnPopupMenuValue = 'Delete';
  static String deleteingBtnText = 'Deleting...';
  static String regBtnText = 'Register';
  static String regingBtnText = 'Registering';
  static String submitBtnText = 'Submit';
  static String submitingBtnText = 'Submiting...';
  static String saveBtnText = 'save';
  static String savingBtnText = 'saving';
  static String noSearchFound = 'No search found';
  static String noResultFound = 'No results found';
  static String nodataFound = 'No data found';
  static String hasText = 'Has';
  static String hasntText = 'Hasn\'t';
  static String pasteBtnText = 'Paste Here';
  static String searchBarHintText = 'Search your Patient\'s...';
  static String updateBtnText = 'Update';
  static String updatingBtnText = 'Updating';
  static String bookingBtnText = 'Booking';
  static String bookAptBtnText = 'Book Appointment';
  static String caseIDLabelText = 'Case ID : ';
  static String emptySpace = '';
  static String loadingLabel = 'Loading...';
  static String someThingWentWrong = 'Something went wrong';
  static String fileSizeErrMsg = 'The file must be less than 10MB.';
  static String failedToDownload = 'Failed to download file';
  static String failedToUpload = 'Upload failed with status: ';
  static String uploadFileBtnText = 'Upload file';
  static String dateFormatYMD = 'yyyy-MM-dd';
  static String mondayText = 'Monday';
  static String tuesdayText = 'Tuesday';
  static String wednesdayText = 'Wednesday';
  static String thursdayText = 'Thursday';
  static String fridayText = 'Friday';
  static String saturdayText = 'Saturday';
  static String sundayText = 'Sunday';
  static List<String> weekshortNameList = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
  static List<String> monthFullNameList = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  static List<String> monthShortNameList = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  static List<String> genderList = ['Male', 'Female', 'Others'];

  //ApiServies
  static const String noInterntError = 'No internet connection ';
  static const String serverError = 'server is unreachable.';
  static const String requestTimeoutError = 'Request timed out';
  static const String unexpectedError = 'An unexpected error occurred.';
  static const String clientError = 'Server lost connection.';

  //SplashScreen
  static String splashAppName = 'Medzo';
  static String splashDescription = 'we make it easy, ';
  static String splashDescription2 = 'for you!';
  static String splashBottomLine = 'A product from';

  //OnBoarding screen
  static String onboardingHeadLine1 = 'Manage Appointments';
  static String onboardingDescription1 =
      'Elevate your practice with our easy-to-use scheduling solution.';
  static String onboardingHeadLine2 = 'Easy Workflow';
  static String onboardingDescription2 =
      'Organize, access, and manage effortlessly with our application.';
  static String onboardingHeadLine3 = 'Business Assist';
  static String onboardingDescription3 =
      'An app that empowers doctor\'s assistants to navigate their tasks effortlessly.';

  //OnBoarding screen Buttons
  static String letsStartBtnText = 'Let\'s Start';
  static String nextBtnText = 'Next';
  static String skipBtnText = 'Skip';

  //Verify screen
  static String verifyHeadline = 'Let\'s Start';
  static String verifyDescription =
      'Please enter the Subscribed Doctor phone number to manage patient details';
  static String loginBtnText = 'Login';
  static String loggingBtnText = 'Logging';
  static String verifyOrText = 'or';
  static String assistantLoginBtnText = 'I\'m a Doctor\'s Assistant';

  //Verify screen Input field
  static String enterPhoneNumberLabel = 'Enter Phone Number';
  static String enterPhoneNumberFieldPlaceholder = 'Eg: +91 98765 43210';
  static String enterPhoneNumberFieldEmptyErrorMsg =
      'Please enter a valid mobile number';
  static String enterPhoneNumberFieldInvalidErrorMsg = 'Invalid phone number';
  static String verifyNotaMember = 'You are not a member of Medzo';

  //Verify screen Terms and condtions
  static String termsAndConditionDisclamier1 = 'I agree';
  static String termsAndConditionDisclamier2 =
      ' with the terms of service and privacy policy';
  static String termsAndConditionValidatorMsg =
      '    Please agree to the terms and conditions.';
  static String termsAndConditionTitle = 'Terms and Conditions';
  static String termsAndConditionContent =
      'Welcome to [Your Company Name]! these terms and conditions outline the rules and regulations for the use of our website, located at [website URL].By accessing this website, we assume you accept these terms and conditions in full. Do not continue to use [Your Company Name]\'s website if you do not accept all of the terms and conditions stated on this page.The following terminology applies to these Terms and Conditions, Privacy Statement and Disclaimer Notice and any or all Agreements: \'Client\', \'You\' and \'Your\' refers to you, the person accessing this website and accepting the Company’s terms and conditions. \'The Company\', \'Ourselves\', \'We\', \'Our\' nand \'Us\', refers to [Your Company Name]. \'Party\', Welcome to [Your Company Name]! these terms and conditions outline the rules and regulations for the use of our website, located at [website URL].By accessing this website, we assume you accept these terms and conditions in full. Do not continue to use [Your Company Name]\'s website if you do not accept all of the terms and conditions stated on this page.The following terminology applies to these Terms and Conditions, Privacy Statement and Disclaimer Notice and any or all Agreements: \'Client\', \'You\' and \'Your\' refers to you, the person accessing this website and accepting the Company’s terms and conditions. \'The Company\', \'Ourselves\', \'We\', \'Our\' nand \'Us\', refers to [Your Company Name]. \'Party\', ';

  //Trial card
  static String trailHedline = 'Have trial now';
  static String trailDescription = 'Please click here for the demo version. ';
  static String trailBtnText = 'Start now';
  static String trailnameText = 'name';
  static String trailGuestText = 'Guest';

  //Subscribe card
  static String subscribeHedline = 'Subscribe';
  static String subscribeDescription =
      'To subscribe Medzo, kindly contact our support team.';
  static String subscribeBtnText = 'Contact now';

  //Subscribe card popup
  static String subscribePopupHeadline = 'Need Help? Contact Medzo';
  static String subscribePopupSupportPhText = 'Customer Support';
  static String subscribePopupSupportCountryCode = '+91';
  static String subscribePopupSupportMailText = 'Email';
  static String subscribePopupSupportMailSubject =
      'Regarding for subscribe Medzo';
  static String subscribePopupSupportMailContent = 'Hello Medzo Team,';
  static String subscribePopupCancelbtnText = 'Cancel';
  static String subscribePopupCopiedText = 'Copied to clipboard';
  static String subscribePopupCopiedErrorText = 'Failed to copy to clipboard';
  static String subscribePopupMakeCallErrorText = 'Couldn\'t make a call';
  static String subscribePopupSendMailErrorText = 'Couldn\'t open email app';

  //verify Phone Number Loading Popup Message
  static String verifyingHeadline = 'Verifying your number';
  static String verifyingDescription =
      'Your number is being checked in our database';
  static String verifyingLoading = 'Loading...';

  //verify Phone Number Success Popup Message
  static String verifyPhNoSuccessPopupHeadline = 'Welcome Back!';
  static String verifyPhNoSuccessPopupDescription =
      'A one-time password (OTP) has been sent to your registered mobile number.';

  //verify Phone Number Failed Popup Message
  static String verifyPhNoFailedPopupHeadline =
      'Oops! We Couldn’t Find Your Account';
  static String verifyPhNoFailedPopupDescription =
      'For membership inquiries, please contact our support team.';

  //assistant login
  static String assistantLoginAppBarText = 'Add Assistants';
  static String assistantLoginHeadline = 'Let\'s start';
  static String assistantLoginDescription =
      'Please enter your assigned phone number to manage patient details.';
  static String assistantLoginUserNameLabelText = 'Phone Number';
  static String assistantLoginUserNamePlaceholder = '+91 98765 43210';
  static String assistantLoginUserNameErrorText =
      'Please enter valid phone number';
  static String assistantLoginPasswordLabelText = 'Password';
  static String assistantLoginPasswordPlaceholder = 'Password';
  static String assistantLoginPasswordErrortext = 'Please enter valid password';
  static String assistantLoginTextButtonText = 'Get from Admin';
  static String assistantInvalidCredentialErrorMsg =
      'Phone number does not exist for membership';

  //OTP screen
  static String otpHeadline = 'Secure Your Login';
  static String otpDescription =
      'Enter the one-time password (OTP) sent to your mobile number';
  static String otpLabel = 'Enter OTP';
  static String otpTimerLabel = 'Code expires in';

  static String otpVerifyBtn = 'Verify Now';
  static String otpVerifyingBtn = 'Verifying';
  static String otpNotReceived = 'Didn\'t receive the code? ';
  static String otpTimerHour = ' 00 : ';
  static String otpTimerMinute = '0';

  static String otpResendBtn = 'Resend now';
  static String otpErrorMsg =
      'The OTP you entered is incorrect. Please try again.';

  //Identity Screen
  static String identityHeadline = 'Verify Your Identity';
  static String identityDescription =
      'To ensure a seamless experience, please complete your KYC verification.';
  static String identityLicenseHeadline = 'License Verification';
  static String identityLicenseHDescription =
      'Upload your medical license for approval.';
  static String identityLicenseErrorMsg = 'Please upload your license';
  static String identityProfileHeadline = 'Profile Picture';
  static String identityProfileHDescription =
      'Upload a clear image for your profile.';
  static String identityProfileErrorMsg = 'Please upload your profile';
  static String identityStartBtnText = 'Start';
  static String identityStartingBtnText = 'Starting';
  static String identitySkipBtnText = 'Skip now';

  //Welcome Screen
  static String welcomeHeadline = 'Welcome Back!';
  static String welcomeDescription =
      'Your access is now restored. Let\'s get started!';

  //Side Drawer Screen
  static String viewProfileBtnText = 'View Profile';
  static String sideDrawerAssistantLabel = 'Assistants';
  static String sideDrawerFollowupLabel = 'Follow-ups';
  static String sideDrawerLoginLabel = 'Login';
  static String sideDrawerLogoutLabel = 'Logout';

  //Tab Screen
  static String homeAppBarTitle = 'Appointments';
  static String analyticsAppBarTitle = 'Analytics';
  static String consultsAppBarTitle = 'All Patients';
  static String messagesAppBarTitle = 'Messages';
  static String homeBtmNavText = 'Home';
  static String analyticsBtmNavText = 'Analytics';
  static String consultsBtmNavText = 'Consults';
  static String messageBtmNavText = 'Message';

  //Home Screen - Initial
  static String homeHeadline = 'Get Started!';
  static String homeTodayText = 'Today';
  static String homeHeadlineOnNoApt = 'No Appointment\'s';
  static String homeDescription = 'Start with your priorities first.';
  static String homeDescriptionOnNoApt = 'No appointment found on this date';
  static String homeAptLabel = 'Appointment ';
  static String homeSLabel = 's ';
  static String homeNewLabel = 'New ';
  static String homeExisitingLabel = 'Existing ';

  static String homeBottomSheetHeadline = 'No Scheduling done';
  static String homeBottomSheetDescription =
      'Let’s assign your Appointment\n Schedules now';
  static String homeBottomSheetSetNowText = 'Set Now';
  static String homeBottomSheetSetLaterText = 'Set Later';

  //My Schedule Screen
  static String myScheduleAppBarTitle = 'Time Selection';
  static String myScheduleDescription =
      'Pick your preferred time slot and stay ahead of your appointments.';
  static String myScheduleSetNowBtnText = 'Set now';
  static const String deleteItemText = 'Delete item';
  static String undoText = 'Undo';
  static String copyAllText = 'Copy all';
  static String copyiedText = 'Copied';
  static String deleteAllText = 'Delete all';
  static String addTimeSlotText = 'Add time slot';
  static String noDataText = 'No Data';
  static String noScheduleMsg = 'No schedule found on this month';

  //My Schedule View Model Text
  static String falseText = 'False';
  static String addText = 'add';
  static String addTimeSlotEndTime = 'End time';

  //My Schedule bottom sheet
  static String addTimeSlotTitle = 'Add time slot for';
  static String addTimeSlotStartTime = 'Start time';
  static String addTimeSlotCancelBtn = 'Cancel';
  static String addTimeSlotSubmitBtn = 'Submit';
  static String addTimeSlotEmptyErrMsg =
      'Please select both start and end times.';
  static String addTimeSlotTimeMismatchErrMsg =
      'End time must be after start time.';
  static String addTimeSlotPastTimeErrMsg = 'Past time slots are not allowed.';
  static String addTimeSlotAlredyBookedMsg =
      'This time slot is already booked.';
  static String addTimeSlotOverlapMsg =
      'Time slot overlaps with another booking.';

  //Schedule List Screen
  static String scheduleListAppBarTitle = 'Schedule List';
  static String scheduleListBookAptText = 'Book Appointment';
  static const String scheduleListBookAptPopupMenuValue = 'Book Appointment';
  static String scheduleListFollowupsText = 'Follow-ups';
  static const String scheduleListFollowupsPopupMenuValue = 'Follow-ups';
  static String scheduleListScheduleText = 'Schedule';
  static const String scheduleListSchedulePopupMenuValue = 'Schedule';
  static String scheduleListRescheduleText = 'Re-Schedule';
  static String scheduleListReschedulePopupMenuValue = 'Re-Schedule';
  static String scheduleListFollowupsTitle = 'Follow-ups';
  static String scheduleListOutdtedTitle = 'Outdated Patient';
  static String scheduleListOutdtedTextForMenu = 'outDated';
  static String scheduleListAppointmentText = 'Appointment';
  static String scheduleListAppointmentTextForMenu = 'appointment';
  static String noScheduleText = 'No Schedules';
  static String slotStatus = 'Status : Available';
  static String notAvailableText = 'Not available';
  static String booknowText = 'Booknow';
  static String deletepopupHeadline = 'Sure you want to delete this?';
  static String deletepopupDescription =
      'Are you sure you want to delete this?';

  //Appointmet screen
  static String newFormAppBarText = 'New Registration';
  static String existingFormAppBarText = 'Add Appointments';
  static String appointmentFormTypeText = 'Appointment Type';
  static String appointmentFormTypeNew = 'New';
  static String appointmentFormTypeExisting = 'Existing';
  static String appointmentFormTitleFollowup = 'Schedule Follow-up';
  static String appointmentFormTitleReSchedule = 'Re-Schedule';

  //Registration Screen
  static String registerFormPatientIDLabel = 'Patient ID';
  static String registerFormAadharLabel = 'Patient Aadhar Number';
  static String registerFormAadharPlaceHolder = 'Enter Aadhar Number';
  static String registerFormNameLabel = 'Patient Name';
  static String registerFormNamePlaceHolder = 'Enter Name';
  static String registerFormMobileNumberLabel = 'Mobile Number';
  static String registerFormMobileNumberPlaceHolder = '+91 98765 43210';
  static String registerFormDobLabel = 'Date of Birth (DOB)';
  static String registerFormDobPlaceHolder = 'YYYY/MM/DD';
  static String registerFormDobErrMsg = 'Please enter DOB';
  static String registerFormAgeLabel = 'Age';
  static String registerFormAgePlaceHolder = 'Your age';
  static String registerFormGenderLabel = 'Gender';
  static String registerFormGenderPlaceHolder = 'Select Gender';
  static String registerFormReferrenceLabel = 'Referred by';
  static String registerFormReferrencePlaceHolder = ' Enter Doctor’s Name';
  static String registerFormGenderErrMsg = 'Please select gender';
  static String registerFormPhoneNoLenthErrMsg =
      'Phone number must be 10 digits';
  static String registerFormPhoneIsrequiredErrMsg = 'Phone number is required';
  static String registerFormNamelenthErrMsg =
      'Patient name must be more then 3 Characters';
  static String registerFormNameNotAllowErrMsg =
      'Name should not contain numbers';
  static String registerFormIsRequired = ' is required';
  static String registerFormAlredyRegBtnText = 'Already registered?';

  //Edit RegisterForm
  static String editRegisterFormAppBarText = 'Edit Registration';
  static String editRegisterFormPatientIDLabel = 'Patient ID';
  static String editRegisterFormAadharLabel = 'Patient Aadhar Number';
  static String editRegisterFormAadharPlaceHolder = 'Enter Aadhar Number';
  static String editRegisterFormNameLabel = 'Patient Name';
  static String editRegisterFormNamePlaceHolder = 'Enter Name';
  static String editRegisterFormMobileNumberLabel = 'Mobile Number';
  static String editRegisterFormMobileNumberPlaceHolder = '+91 98765 43210';
  static String editRegisterFormDobLabel = 'Date of Birth (DOB)';
  static String editRegisterFormDobPlaceHolder = 'YYYY/MM/DD';
  static String editRegisterFormAgeLabel = 'Age';
  static String editRegisterFormAgePlaceHolder = 'Your age';
  static String editRegisterFormGenderLabel = 'Gender';
  static String editRegisterFormGenderPlaceHolder = 'Select Gender';
  static String editRegisterFormReferrenceLabel = 'Referred by';
  static String editRegisterFormReferrencePlaceHolder = ' Enter Doctor’s Name';
  static String editRegisterFormGenderErrMsg = 'Please select gender';
  static String editRegisterFormDobErrMsg = 'Please enter DOB';
  static String editRegisterFormPhoneNoLenthErrMsg =
      'Phone number must be 10 digits';
  static String editRegisterFormPhoneIsrequiredErrMsg =
      'Phone number is required';
  static String editRegisterFormNamelenthErrMsg =
      'Patient name must be more then 3 Characters';
  static String editRegisterFormNameIsRewuiredErrMsg =
      'Patient name can\'t be empty';
  static String editRegisterFormNameNotAllowErrMsg =
      'Name should not contain numbers';
  static String editRegisterFormIsRequired = ' is required';

  //Already Resgistered User
  static String registeredFormTitle = 'Registered User';
  static String registeredFormHeadline = 'Find My ID';
  static String registeredFormDescription =
      'If you already registered please enter your Mobile number and Adharcard number to proceed further';
  static String registeredFormMobileNoLabel = 'Mobile number';
  static String registeredFormMobileNoHint = '+91 98******01';
  static String registeredFormMobileNoErrMsg1 = 'Please enter phone number';
  static String registeredFormMobileNoErrMsg2 = 'Invalid phone number';
  static String registeredFormAadharNoLabel = 'Patient Aadhar number';
  static String registeredFormAadharNoHint = 'Enter aadhar number';
  static String registeredFormAadharNoErrMsg1 = 'Please enter aadhar number';
  static String registeredFormAadharNoErrMsg2 = 'Enter valid aadhar number';
  static String findmeBtnText = 'Find me';
  static String findingBtnText = 'Finding';
  static String notValidPtientErrMSg = 'You\'re not a registered user';

  //New Appointment Screen
  static String newAptAppBarText = 'New Appointments';
  static String newAptPatientIDLabel = 'Patient ID';
  static String newAptChiefComplaintLabel = 'Chief Complaint';
  static String newAptChiefComplaintPlaceHolder = 'Enter here';
  static String newAptTimeLabel = 'Time';
  static String newAptDateLabel = 'Date';
  static String newAptPastHistoryLabel = 'Past history';
  static String newAptPastHistoryPlaceHolder = 'Others enter here';
  static String newAptPersonalHistoryLabel = 'Personal history(Optional)';
  static String newAptPersonalHistoryRadioBtnLabel =
      'Presence of co-morbidity in family';
  static String newAptPersonalHistoryPlaceHolder = 'Enter here';
  static String newAptAppointmentTypeLabel = 'Appointment type';
  static String newAptAppointmentTypePlaceHolder = 'Select any type';
  static String newAptReportLabel = 'Report Upload';
  static String newAptScanFileLabel = 'Scan file';
  static String newAptYesLabel = 'Yes';
  static String newAptYesOptionValue = 'yes';
  static String newAptNoLabel = 'No';
  static String newAptNoOptionValue = 'no';
  static String newAptTextAreaHint = 'Enter additional notes';
  static String newAptPastHistoryErrMsg = '    please select any options';
  static List<String> pastHistoryDiceaseList = [
    'Nil',
    'Diabetes mellitus',
    'Hypertension',
    'Bronchial asthma',
    'Seizure disorder',
    'Coronary artery disease',
    'Cerebrovascular disease',
    'Tuberculosis',
    'Head injury',
    'Any Surgery',
  ];
  static List<String> personalHistoryDiceaseList = [
    'Alcohol use',
    'Nicotine use',
    'Others substance use',
  ];
  static List<String> newAptAppointmentTypeOptions = [
    'Lab test',
    'Follow-up',
    'Routine check',
  ];
  static Map<String, String> pastHistoryMappingForPost = {
    'Nil': 'nil',
    'Diabetes mellitus': 'diabetesMellitus',
    'Hypertension': 'hypertension',
    'Bronchial asthma': 'bronchialAsthma',
    'Seizure disorder': 'seizureDisorder',
    'Coronary artery disease': 'coronaryArteryDisease',
    'Cerebrovascular disease': 'cerebrovascularDisease',
    'Tuberculosis': 'tuberculosis',
    'Head injury': 'headInjury',
    'Any Surgery': 'anySurgery',
  };
  static Map<String, String> pastHistoryMappingForGet = {
    'nil': 'Nil',
    'diabetesMellitus': 'Diabetes mellitus',
    'hypertension': 'Hypertension',
    'bronchialAsthma': 'Bronchial asthma',
    'seizureDisorder': 'Seizure disorder',
    'coronaryArteryDisease': 'Coronary artery disease',
    'cerebrovascularDisease': 'Cerebrovascular disease',
    'tuberculosis': 'Tuberculosis',
    'headInjury': 'Head injury',
    'anySurgery': 'Any Surgery',
  };

  //Edit new Appointment Screen
  static String editNewAptAppBarText = 'Edit New Appointments';
  static String editNewAptPatientIDLabel = 'Patient ID';
  static String editNewAptPastHistoryLabel = 'Past history';
  static String editNewAptPastHistoryPlaceHolder = 'Others enter here';
  static String editNewAptPersonalHistoryLabel = 'Personal history(Optional)';
  static String editNewAptPersonalHistoryRadioBtnLabel =
      'Presence of co-morbidity in family';
  static String editNewAptYesLabel = 'Yes';
  static String editNewAptNoLabel = 'No';
  static String editNewAptTextAreaHint = 'Enter additional notes';
  static String editNewAptPastHistoryErrMsg = '    please select any options';
  static List<String> editPastHistoryDiceaseList = [
    'Nil',
    'Diabetes mellitus',
    'Hypertension',
    'Bronchial asthma',
    'Seizure disorder',
    'Coronary artery disease',
    'Cerebrovascular disease',
    'Tuberculosis',
    'Head injury',
    'Any Surgery',
  ];
  static List<String> editPersonalHistoryDiceaseList = [
    'Alcohol use',
    'Nicotine use',
    'Others substance use',
  ];

  //New Appointment Screen View model
  static String newAptNilText = 'Nil';
  static String newAptCcEmptyerrMsg = 'Please type chief complaint';
  static String newAptCcLenthErrMsg = 'Please type valid complaint';
  static String newAptAptTypeErrMsg = 'Please select an appointment type';

  //Existing Appointment Screen
  static String extAptPatientIDLabel = 'Patients or Case ID';
  static String extAptPatientIDPlaceHolder = 'Select Patient ID';
  static String extAptPatientIDSearchFieldPlaceHolder =
      'Search Patient Name or ID';
  static String extAptPatientIDSearchFieldErrMsg1 =
      'Please select a value from the suggestion list.';
  static String extAptPatientIDSearchFieldErrMsg2 =
      'Please select a value from the suggestion list.';
  static String extAptDateLabel = 'Date';
  static String extAptDateHint = 'Select date';
  static String extAptDateErrText = 'Please select date';
  static String extAptTimeLabel = 'Time';
  static String extAptTimeErrText = 'please select time';
  static String extAptSelectTimeSlothint = 'Select Time slot';
  static String extAptNoTimeSlothint = 'No slots available';
  static String extAptChiefComplaintLabel = 'Chief Complaint';
  static String extAptChiefComplaintErrMsg1 = 'Please type chief complaint';
  static String extAptChiefComplaintErrMsg2 = 'Please type valid complaint';
  static String extAptChiefComplaintPlaceHolder = 'Enter here';
  static String extAptAppointmentTypeLabel = 'Appointment type';
  static String extAptAppointmentTypeErrMsg =
      'Please select an appointment type';
  static String extAptAppointmentTypePlaceHolder = 'Select any type';
  static List<String> extAptAppointmentTypeOptions = [
    'Lab test',
    'Follow-up',
    'Routine check',
  ];
  static String addAptReportLabel = 'Report Upload(optional)';
  static String addAptScanFileLabel = 'Scan file';

  //Consultation form
  static String cnsltFormCreateTitle = 'Consultation form';
  static String cnsltFormEditTitle = 'Edit Consultation form';
  static String cnsltFormDianosesLabel = 'Diagnoses';
  static String cnsltFormDianosesmandatoryErrMsg =
      'Please fill the mandatory field';
  static String cnsltFormDianosesLenErrMsg = 'Please type valid message';
  static String cnsltFormDianosesPlaceHolder = 'Type here';
  static String cnsltFormInvestigationLabel = 'Lab investigation';
  static String cnsltFormInvestigationPlaceHolder = 'Type here';
  static String cnsltFormComplaintLabel = 'Complaint';
  static String cnsltFormComplaintPlaceHolder = 'Type here';
  static String cnsltFormReportLabel = 'Report';
  static String cnsltFormPrescriptionLabel = 'Prescription';
  static String cnsltFormScanFileBtnText = 'Scan file';
  static String cnsltFormReminderLabel = 'Reminder';
  static String cnsltFormFollowUpDateTimeLabel = 'Follow up Date & Time';
  static String cnsltFormDateLabel = 'Date';
  static String cnsltFormSetupBtnText = 'Setup here';
  static String cnsltFormSaveBtnText = 'Save';

  //Patient Pre-check form
  static String patientPrecheckformTitle = 'Patient Pre-Check';
  static String patientPrecheckformEditTitle = 'Edit Patient Pre-Check';
  static String patientPrecheckformTHeightLable = 'Height';
  static String patientPrecheckformTHeightScale = '(cm)';
  static String patientPrecheckformTHeightHint = 'Enter Height CM';
  static String patientPrecheckformTWeightLable = 'Weight';
  static String patientPrecheckformTWeightScale = '(kg)';
  static String patientPrecheckformTWeightHint = 'Enter Weight Kg';
  static String patientPrecheckformTBpLable = 'Blood Pressure';
  static String patientPrecheckformTBpInputFormat = r'^\d{0,3}/?\d{0,3}$';
  static String patientPrecheckformTBpScale = '(BP)';
  static String patientPrecheckformTBpHint =
      'Enter Blood Pressure BP (e.g., 120/80)';
  static String patientPrecheckformTBpmLable = 'Plus Rate';
  static String patientPrecheckformTBpmScale = '(BPM)';
  static String patientPrecheckformTBpmHint = 'Enter Plus Rate BPM';
  static String patientPrecheckformTBtLable = 'Body Temperature';
  static String patientPrecheckformTBtScale = '(F/c)';
  static String patientPrecheckformTBtHint = 'Enter Body Temperature F/c';
  static String patientPrecheckformTOxygenLable = 'Oxygen Saturation';
  static String patientPrecheckformTOxygenScale = '(SpO2)';
  static String patientPrecheckformTOxygenHint =
      'Enter Oxygen Satuartion SpO2 (%)';
  static String patientPrecheckformErrMsg =
      'Please enter at least one value before submitting!';

  //precheck popup
  static String precheckPopupCc = 'Chief Complaint';
  static String precheckPopupTitle = 'Patient Pre-Check';
  static String precheckPopupConsltBtnText = 'Consultaion';

  //Patient Profile
  static String patientProfileTitle = 'Patient profile';
  static String patientProfilePersonalInfoHeadline = 'Personal Information';
  static String patientProfileSex = 'Sex';
  static String patientProfileEditBtnText = 'Edit Profile';
  static const String patientProfileEditpopupMenuValue = 'Edit Profile';
  static String patientProfileMobile = 'Mobile';
  static String patientProfileBasicDetailsHeadline = 'Basic Detials';
  static String patientProfileChiefComplaint = 'Chief Complaint';
  static String patientProfilePastHistory = 'Past History';
  static String patientProfilePersonalHistory = 'Personal History';
  static String patientProfileCardCause = 'Cause';
  static String patientProfileCardAppoinmentType = 'Appoinment Type';
  static String patientProfileCardCompletedtxt = 'Completed';
  static String patientProfileCardPendingtxt = 'Pending';
  static String patientProfileCardpendingtxtforResponseMatch = 'PENDING';

  //Consult Screen
  static String setScheduleBtnText = 'Set schedules';
  static String addAptBtnText = 'Add appointments';
  static String todayText = 'Today';
  static String filtersText = 'Filters';
  static const String last3MonText = 'Last 3 months';
  static const String last6MonText = 'Last 6 months';
  static const String thisYearText = 'This year';
  static String dateRangeText = 'Date Range';
  static String emptyText = 'Empty';
  static String noConsultText = 'No consult\'s found on this date';

  //Review Details
  static String reviewDetailsTitle = 'Review Details';
  static String reviewDetailsPopupMenutitle = 'Edit Details';
  static const String reviewDetailsPopupMenuValue = 'Edit Details';
  static String reviewDetailsCaseId = 'Case Id : ';
  static String reviewDetailsCause = 'Cause : ';
  static String reviewDetailsAppoinmentType = 'Appointment Type';
  static String reviewDetailsDiagnoses = 'Diagnoses ';
  static String reviewDetailsLabInvestigation = 'Lab Investigation';
  static String reviewDetailsComplaint = 'Complaint';
  static String reviewDetailsReports = 'Reports';
  static String reviewDetailsPrescription = 'Prescription';
  static String reviewDetailsTryagainText = 'Try again';
  static String reviewDetailsNoReport = 'No Reports';
  static String reviewDetailsNoPrescription = 'No Prescription';
  static String reviewDetailsDownloadFailedText =
      'Download failed, please try again';

  //Follow up screen
  static String followUpsTitle = 'Follow-ups';
  static String followUpsDeletePopupTitle = 'Sure you want to delete?';
  static String followUpsDeletePopupDescription =
      'Are you sure you want to delete this Follow-up?';
  static String followUpsDeleteSucMsg = 'Follow-up deleted successfully.';
  static String noFollowUpsMsg = 'No follow-ups here.';

  //User Profile
  static String userProfileTitle = 'User Profile';
  static String userProfileNameLabel = 'User Name';
  static String userProfileMobileLabel = 'Mobile Number';
  static String userProfileEmailLabel = 'Email ID';
  static String userProfileEmailCondtion = '@gmail.com';
  static String userProfileEmailHintText = 'Enter E-Mail ID';
  static String userProfileEmailErrMsg1 = 'Enter E-Mail ID';
  static String userProfileEmailErrMsgforIsRequired = 'Email is required';
  static String userProfileEmailErrMsg2 =
      'Email must be in the format of @gmail.com';
  static String userProfileDetilaUpdatedMsg = 'Details Updated Successfully';
  static String userProfileKycTitle = 'KYC verification';
  static String userProfileKycHeadLine = 'KYC Documents';
  static String userProfileKycDescription =
      'You have not yet uploaded your KYC Documents';
  static String userProfileKycUploadText = 'uploded';
  static String userProfileKycUploaingText = 'uplodeding..';
  static String userProfileKycUploadFailedText = 'Upload failed';
  static String userProfileKycDownloadFailedText =
      'Dowload failed, please try again';
  static String userProfileKycUploadThisText = 'Upload This';
  static String userProfilePleaseTryAgainText = 'Please try again';
  static String userProfileTryAgainText = 'Try again';
  static String userProfileClickToViewText = 'Click to View';
  static String userProfileClickToUploadText = 'Click to Upload';
  static String userProfileUnknownSizeText = 'Unknown size';
  static String userProfileFileUploadedText = 'File Uploaded';
  static String userProfileMaxFileSizeErrText =
      'File size exceeds 10 MB. Please upload a smaller file.';
  static String userProfileKycUploadFieldLicenseTitle =
      'Medical Registry license';
  static String userProfileKycUploadFieldProfileTitle = 'Profile Image';

  //Edit User Profile
  static String edituserProfileBottomSheetTitle = 'Profile picture';
  static String edituserProfileBottomSheetCameraLabel = 'Camera';
  static String edituserProfileBottomSheetGalleryLabel = 'Gallery';

  // AssistantList creation
  static String assistantProfileTitle = 'Assistant\'s Profile';
  static String assistantProfileCreateBtnTitle = 'Click to add assistant\'s';
  static String assistantProfileNameLabel = 'Assistant Name             : ';
  static String assistantProfileMobileLabel = 'Assistant Mobile            : ';
  static String assistantProfileDesginationLabel = 'Assistant Designation : ';
  static String assistantProfilePasswordLabel = 'Assistant Password      : ';
  static String assistantProfileKey = 'assistant';

  //Assistant user profile screen
  static String assistantUserProfileAppBarTitle = 'User Profile';
  static String assistantUserProfileNameLabel = 'Name';
  static String assistantUserProfileMobileLabel = 'Mobile';
  static String assistantUserProfileDesginationLabel = 'Designation';
  static String assistantUserProfilePasswordLabel = 'Password';
  static String assistantUserProfilePasswordSymbol = '*';

  // user profile picture Edit screen
  static String userProfileAppBarTitle = 'Crop Your\'s Image';

  // Assistant Form
  static String assistantFormCreateTitle = 'Create Assistant Profile';
  static String assistantFormEditTitle = 'Edit Assistant Profile';
  static String assistantFormNameLabel = 'Assistant Name ';
  static String assistantFormNameFieldValue = 'Assistant Name';
  static String assistantFormNameHind = 'Enter Name';
  static String assistantFormNameErrorMsg =
      'Assitant name must be more then 3 Characters';
  static String assistantFormMobileLabel = 'Mobile Number ';
  static String assistantFormMobileFieldValue = 'Mobile Number';
  static String assistantFormMobileHint = 'Enter Phone Number';
  static String assistantFormMobileErrorMsg1 = 'Mobile number is required';
  static String assistantFormMobileErrorMsg2 =
      'Mobile number must be 10 digits';
  static String assistantFormDesiginationLabel = 'Designation ';
  static String assistantFormDesiginationFieldValue = 'Designation';
  static String assistantFormDesiginationHint = 'Enter Your Desgination';
  static String assistantFormDesiginationErrorMsg =
      'please enter your desgination';
  static String assistantFormEmailLabel = 'Email ID';
  static String assistantFormEmailFieldValue = 'Email';
  static String assistantFormEmailHint = 'Enter Yout Email';
  static String assistantFormEmailCondition =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static String assistantFormEmailErrorMsg =
      'Please enter a valid email address';
  static String assistantFormEnterPWLabel = 'Enter Password ';
  static String assistantFormEnterPWFieldValue = 'Password';
  static String assistantFormEnterPWHint = 'Enter Your Password';
  static String assistantFormEnterPWErrorMsg1 = 'Password is required.';
  static String assistantFormEnterPWErrorMsg2 =
      'Its must be contains at least 8 characters long.';
  static String assistantFormEnterPWErrorMsg3 =
      'Its must be contains at least one lowercase letter.';
  static String assistantFormEnterPWErrorMsg4 =
      'Its must be contains at least one uppercase letter.';
  static String assistantFormEnterPWErrorMsg5 =
      'Its must be contains at least one special character (!, @, #, &, ~).';
  static String assistantFormEnterPWErrorMsg6 =
      'Its must be contains at least one number.';
  static String assistantFormPwRulesOne =
      'Its must be at least 8 characters long';
  static String assistantFormPwRulesTwo =
      'Its contain at least one lowercase letter';
  static String assistantFormPwRulesThree =
      'Its contain at least one uppercase letter';
  static String assistantFormPwRulesFour =
      'Its contain at least one special character';
  static String assistantFormPwRulesFive =
      'Its must contain at least one Numeric';
  static String assistantFormPwLcCondition = r'(?=.*[a-z])';
  static String assistantFormPwUcCondition = r'(?=.*[A-Z])';
  static String assistantFormPwSpecialCondition = r'(?=.*[!@#\$&~])';
  static String assistantFormPwNumericCondtion = r'(?=.*\d)';
  static String assistantFormReEnterPWLabel = 'Re-Enter Password ';
  static String assistantFormReEnterPWFieldValue = 'Re-Enter Password ';
  static String assistantFormReEnterPWHint = 'Re-Enter Your Password';
  static String assistantFormReEnterPwErrorMsg1 =
      'Please re-enter your password';
  static String assistantFormReEnterPwErrorMsg2 = 'Passwords Dosen\'t match';
  static String assistantFormIsRequired = 'is required';
  static String assistantFormSaveBtn = 'Save';
  static String assistantFormcreateBtn = 'Create';

  //Assisstant Delete popup
  static String astDltPuHeadline = 'Sure you want to delete this Assistant?';
  static String astDltPuDescription =
      'Are you sure you want to delete this Assistant?';
  static String astDltPuMsg = 'Assistant was not deleted!';

  //USer Profile UploadField values
  static String ufcompletedText = 'completed';
  static String ufidleText = 'idle';
  static String ufdowloadFailedText = 'dowloadFailed';
  static String uffailedText = 'failed';
  static String ufFailedToUploadFileText = 'Failed to uploadload file';
  static String ufUploadingText = 'uploading';

  //Appointment cart
  static String aptCardCaseId = 'Case ID: ';
  static String aptCardViewRptText = 'View Report';
  static String aptCradPrecheckText = 'Pre-Check';
  static String aptCradAptNewTypeText = 'NEW';

  //Consult Cart
  static String consultCardFollowupText = 'Follow up';
  static String consultCardViewRptText = 'View Report';
  static String consultCardSittingText = 'Sittting: 1/ND';

  //Custom Date picker
  static String customDpApplyText = 'Apply';
  static String customDpHypenText = '   -   ';
  static String customDpEndDateText = 'End Date';
  static String customDpStartDateText = 'Start Date';
  static String customDpStartNotSelectedText = 'Not selected';

  //FollowUp Bottom Sheet
  static String followUpPopupHeadLine = 'Sure you want to setup?';
  static String followUpPopupDescription = 'Followup for Patients in advance';
  static String followUpPopupDontShowText = 'Don\'t show this again';
  static String followUpPopupOverlayMsg = 'Follow-up assigned to Case ID: ';
  static String noFollowUpText = 'No follow-ups here';
  static String followUpText = 'Follow-up';
}
