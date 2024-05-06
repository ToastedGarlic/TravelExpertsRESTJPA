package model;

import jakarta.persistence.*;
import jakarta.validation.constraints.Size;

@Entity
@Table(name = "agents")
public class Agent {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "AgentId", nullable = false)
    private Integer agentId;

    @Size(max = 20)
    @Column(name = "AgtFirstName", nullable = true, length = 20)
    private String agtFirstName;

    @Size(max = 5)
    @Column(name = "AgtMiddleInitial", nullable = true, length = 5)
    private String agtMiddleInitial;

    @Size(max = 20)
    @Column(name = "AgtLastName", nullable = true, length = 20)
    private String agtLastName;

    @Size(max = 20)
    @Column(name = "AgtBusPhone", nullable = true, length = 20)
    private String agtBusPhone;

    @Size(max = 50)
    @Column(name = "AgtEmail", nullable = true, length = 50)
    private String agtEmail;

    @Size(max = 20)
    @Column(name = "AgtPosition", nullable = true, length = 20)
    private String agtPosition;

    @Column(name = "AgencyId", nullable = true)
    private Integer agencyId;

    // Getters and Setters
    public Integer getAgentId() {
        return agentId;
    }

    public void setAgentId(Integer agentId) {
        this.agentId = agentId;
    }

    public String getAgtFirstName() {
        return agtFirstName;
    }

    public void setAgtFirstName(String agtFirstName) {
        this.agtFirstName = agtFirstName;
    }

    public String getAgtMiddleInitial() {
        return agtMiddleInitial;
    }

    public void setAgtMiddleInitial(String agtMiddleInitial) {
        this.agtMiddleInitial = agtMiddleInitial;
    }

    public String getAgtLastName() {
        return agtLastName;
    }

    public void setAgtLastName(String agtLastName) {
        this.agtLastName = agtLastName;
    }

    public String getAgtBusPhone() {
        return agtBusPhone;
    }

    public void setAgtBusPhone(String agtBusPhone) {
        this.agtBusPhone = agtBusPhone;
    }

    public String getAgtEmail() {
        return agtEmail;
    }

    public void setAgtEmail(String agtEmail) {
        this.agtEmail = agtEmail;
    }

    public String getAgtPosition() {
        return agtPosition;
    }

    public void setAgtPosition(String agtPosition) {
        this.agtPosition = agtPosition;
    }

    public Integer getAgencyId() {
        return agencyId;
    }

    public void setAgencyId(Integer agencyId) {
        this.agencyId = agencyId;
    }
}
