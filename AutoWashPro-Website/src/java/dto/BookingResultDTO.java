package dto;

public class BookingResultDTO {
    private boolean success;
    private String status;
    private String message;
    private int bookingId;
    private Integer queuePosition;

    public BookingResultDTO(boolean success, String status, String message, int bookingId, Integer queuePosition) {
        this.success = success;
        this.status = status;
        this.message = message;
        this.bookingId = bookingId;
        this.queuePosition = queuePosition;
    }

    public boolean isSuccess() {
        return success;
    }

    public String getStatus() {
        return status;
    }

    public String getMessage() {
        return message;
    }

    public int getBookingId() {
        return bookingId;
    }

    public Integer getQueuePosition() {
        return queuePosition;
    }
}
