package dto;

import java.math.BigDecimal;

public class ServiceDTO {
    private int serviceId;
    private String serviceName;
    private BigDecimal price;
    private int duration;

    public ServiceDTO() {
    }

    public ServiceDTO(int serviceId, String serviceName, BigDecimal price, int duration) {
        this.serviceId = serviceId;
        this.serviceName = serviceName;
        this.price = price;
        this.duration = duration;
    }

    public int getServiceId() {
        return serviceId;
    }

    public void setServiceId(int serviceId) {
        this.serviceId = serviceId;
    }

    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }
}
