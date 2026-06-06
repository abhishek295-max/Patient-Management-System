package org.example.model;

public class DashboardData {
    private final int patientCount;
    private final int contactCount;
    private final int urgentContactCount;
    private final String latestPatientName;
    private final String latestPatientDetail;
    private final String latestContactName;
    private final String latestContactDetail;
    private final String latestContactPriority;
    private final String errorMessage;

    public DashboardData(int patientCount, int contactCount, int urgentContactCount,
                         String latestPatientName, String latestPatientDetail,
                         String latestContactName, String latestContactDetail,
                         String latestContactPriority, String errorMessage) {
        this.patientCount = patientCount;
        this.contactCount = contactCount;
        this.urgentContactCount = urgentContactCount;
        this.latestPatientName = latestPatientName;
        this.latestPatientDetail = latestPatientDetail;
        this.latestContactName = latestContactName;
        this.latestContactDetail = latestContactDetail;
        this.latestContactPriority = latestContactPriority;
        this.errorMessage = errorMessage;
    }

    public int getPatientCount() { return patientCount; }
    public int getContactCount() { return contactCount; }
    public int getUrgentContactCount() { return urgentContactCount; }
    public String getLatestPatientName() { return latestPatientName; }
    public String getLatestPatientDetail() { return latestPatientDetail; }
    public String getLatestContactName() { return latestContactName; }
    public String getLatestContactDetail() { return latestContactDetail; }
    public String getLatestContactPriority() { return latestContactPriority; }
    public String getErrorMessage() { return errorMessage; }
}
