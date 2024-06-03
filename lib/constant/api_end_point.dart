const String mainUrl = 'https://reporting.unisonpharmaceuticals.com/beta/api/';
//const String mainUrl = 'http://192.168.50.66/unison/';
const String mainUrlReport = 'https://reporting.unisonpharmaceuticals.com/beta/';

const String WEBSITE_URL = "https://www.unisonpharmaceuticals.com/";

const int CLICK_THRESHOLD = 1000;

const String SAMPLE_REASON_ID = "4";
const String REFUSE_REASON_ID = "11";

const String baseUrl = '${mainUrl}services/';
const String baseUrlTours = '${mainUrl}tours/';
const String baseUrlProducts = '${mainUrl}products/';

const String TOURPLANMAIN_REPORT = "${mainUrlReport}reports/tour_plan.php?from_app=true&";
const String DCR_REPORT = "${mainUrlReport}reports/dcr.php?from_app=true&";
const String PLANNER_REPORT = "${mainUrlReport}reports/planner_report.php?from_app=true&";
const String GIFT_REPORT = "${mainUrlReport}reports/gift_report.php?from_app=true&";
const String NOT_SEEN_REPORT = "${mainUrlReport}reports/not_seen.php?from_app=true&";
const String TRAVELLING_REPORT = "${mainUrlReport}reports/travelling_report.php?from_app=true&";

/*UserType*/
const String MANAGER = "manager";
const String ADMIN = "admin";
const String MR = "mr";

const String DOCTOR = "doctors";
const String CHEMIST = "chemists";
const String STOCKIST = "stockists";

const String fromApp = "true";

// Login
const String sendOtpUrl = '${baseUrl}otp/send';
const String checkOtpUrl = '${baseUrl}otp/checkMobileOtp';
const String loginUrl = '${baseUrl}admin/sign_in';
const String appVersionUrl = '${baseUrl}get_app_version';
const String profileUrl = '${baseUrl}admin/profile';

const String getTourPlannerUrl = '${baseUrl}dailyCall/getTourPlanner';
const String removeTourPlanner = '${baseUrl}dailyCall/deleteTourPlanner';

const String areaFromDoctorUrl = '${baseUrl}area/areaFromDoctor';
const String doctorsListUrl = '${baseUrl}doctors/list';
const String availableStaffMemberUrl = '${baseUrl}staff/availableStaffMember';
const String listVariationsUrl = '${baseUrlProducts}listVariations';
const String listVariationsOnlySaleUrl = '${baseUrlProducts}listVariations_only_sale';

const String loadReportTypeUrl = '${baseUrl}loadReportType/list';
const String reasonListUrl = '${baseUrl}reason/list';
const String availablePartnersUrl = '${baseUrl}staff/availablePartners';
const String workWithOther = '${baseUrl}admin/workWith';

const String saveTourPlan = '${baseUrlTours}action/saveTourplan';
const String saveTourPlanExtra = '${baseUrlTours}action/saveTourplanExtra';
const String loadFormUrl = '${baseUrlTours}action/loadForm';
const String confirmTourPlan = '${baseUrlTours}action/confirmTourplan';
const String approveTourPlan = '${baseUrlTours}action/approveTourplan';

const String loadAreaTourPlantUrl = '${baseUrlTours}action/loadAreaTourPlan';

const String lastYearsListUrl = "${baseUrl}mr_reports/lastYearsList";
const String lastMonthListUrl = "${baseUrl}mr_reports/lastMonthList";

const String saveTourPlannerUrl = "${baseUrl}dailyCall/saveTourPlanner";
const String confirmTourPlannerUrl = "${baseUrl}dailyCall/confirmTourPlanner";
const String approveTourPlannerUrl = "${baseUrl}dailyCall/approveTourPlanner";

const String loadSpecialityFromAreaUrl = "${baseUrl}loadSpecialityFromArea/list";
const String loadDoctorFromSpecialityUrl = "${baseUrl}loadDocorFromSpeciality/list";

const String dayEndApi = "${baseUrl}staff/dayend";
const String saveDailyCallEntry = "${baseUrl}dailycall/multiple";

const String viewTodayEntryUrl = "${baseUrl}viewTodayEntry";

const String specialityUrl = "${baseUrl}speciality/list";
const String qualificationUrl = "${baseUrl}qualification/list";
const String getCityDistrictUrl = "${baseUrl}getCityDistrict";
const String mirrorEmployeesUrl = "${baseUrl}dailyCall/mirrorEmployees";

const String getLeavesUrl = "${baseUrl}leave/getLeaves";
const String applyLeaveUrl = "${baseUrl}admin/applyLeave";

const String appliedLeavesUrl = "${baseUrl}staff/appliedLeaves";
const String updateLeavesUrl = "${baseUrl}staff/updateLeaves";

const String giftScheduleListUrl = "${baseUrl}giftSchedule/getList";
const String checkGiftMonthUrl = "${baseUrl}giftPlanner/checkGiftMonth";
const String loadAreaOnSpecialityUrl = "${baseUrl}giftPlanner/loadAreaOnSpeciality";
const String getGiftPlanUrl = "${baseUrl}giftPlanner/getGiftPlan";

const String saveGiftPlanUrl = "${baseUrl}giftPlanner/saveGiftPlan";
const String confirmGiftPlanUrl = "${baseUrl}giftPlanner/confirmGiftPlanner";
const String approveGiftPlanUrl = "${baseUrl}giftPlanner/approveGiftPlanner";
const String deleteGiftPlanUrl = "${baseUrl}giftPlanner/deleteGiftPlanner";

const String notSeenGenerateReportUrl = "${baseUrl}notseen/generateReport";
const String confirmNotSeenEntryUrl = "${baseUrl}notseen/confirmNotSeenEntry";
const String saveNotSeenEntryUrl = "${baseUrl}notseen/saveNotSeenEntry";
const String approveNotSeenEntryUrl = "${baseUrl}notseen/approveNotSeenEntry";

const String getDoctorDetailUrl = "${baseUrl}profile";

const String secondaryEmployeesUrl = "${baseUrl}secondary/employees";
const String secondaryStockistUrl = "${baseUrl}secondary/stockist";
const String secondaryListUrl = "${baseUrl}secondary/list";
const String secondaryDataUpdateUrl = "${baseUrl}secondary/update";
const String filterListUrl = "${baseUrl}doctors/filters";

const String getDoctorsFromMrUrl = "${baseUrl}getDoctorsFromMr";
const String salesUpdateDetailUrl = "${baseUrl}sales_update/details";
const String salesUpdateUrl = "${baseUrl}sales_update/update";

const String dashboardDataUrl = "${baseUrl}dashboard/data";
const String dashboardListUrl = "${baseUrl}dashboard/list";

const String getTravellingAllowanceUrl = "${baseUrl}travellingAllowance/getTravellingAllowance";
const String saveTravellingAllowanceUrl = "${baseUrl}travellingAllowance/saveTravellingAllowance";
const String confirmTravellingAllowanceUrl = "${baseUrl}travellingAllowance/confirmTravellingAllowance";
const String approveTravellingAllowanceUrl = "${baseUrl}travellingAllowance/approveTravellingAllowance";

const String doctorVisitUrl = "${baseUrl}reports/doctor_visits";
const String callAverageUrl = "${baseUrl}reports/call_avarage";

const String checkToken = '${baseUrl}admin/check_token';
const String notificationList = '${baseUrl}notifications/list';

const String mrProfileUrl = "${baseUrl}";