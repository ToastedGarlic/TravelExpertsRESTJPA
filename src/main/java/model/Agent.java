package model;

import jakarta.persistence.*;
import jakarta.validation.constraints.Size;
import jakarta.validation.constraints.NotNull;

@Entity
@Table(name = "agents")
public class Agent {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "AgentId", nullable = false)
    private Integer agentId;

    @Size(max = 20)
    @NotNull
    @Column(name = "AgtFirstName", nullable = false, length = 20)
    private String agtFirstName;

    @Size(max = 5)
    @Column(name = "AgtMiddleInitial", length = 5)
    private String agtMiddleInitial;

    @Size(max = 25)
    @NotNull
    @Column(name = "AgtLastName", nullable = false, length = 25)
    private String agtLastName;

    @Size(max = 20)
    @NotNull
    @Column(name = "AgtBusPhone", nullable = false, length = 20)
    private String agtBusPhone;

    @Size(max = 50)
    @NotNull
    @Column(name = "AgtEmail", nullable = false, length = 50)
    private String agtEmail;

    @Size(max = 20)
    @NotNull
    @Column(name = "AgtPosition", nullable = false, length = 20)
    private String agtPosition;

    @Column(name = "AgencyId")
    private Integer agencyId;

    @Size(max = 10)
    @Column(name = "userid", length = 10)
    private String userid;

    @Size(max = 10)
    @Column(name = "password", length = 10)
    private String password;

    // Standard getters and setters
    public Integer getAgentId() { return agentId; }
    public void setAgentId(Integer agentId) { this.agentId = agentId; }
    public String getAgtFirstName() { return agtFirstName; }
    public void setAgtFirstName(String agtFirstName) { this.agtFirstName = agtFirstName; }
    public String getAgtMiddleInitial() { return agtMiddleInitial; }
    public void setAgtMiddleInitial(String agtMiddleInitial) { this.agtMiddleInitial = agtMiddleInitial; }
    public String getAgtLastName() { return agtLastName; }
    public void setAgtLastName(String agtLastName) { this.agtLastName = agtLastName; }
    public String getAgtBusPhone() { return agtBusPhone; }
    public void setAgtBusPhone(String agtBusPhone) { this.agtBusPhone = agtBusPhone; }
    public String getAgtEmail() { return agtEmail; }
    public void setAgtEmail(String agtEmail) { this.agtEmail = agtEmail; }
    public String getAgtPosition() { return agtPosition; }
    public void setAgtPosition(String agtPosition) { this.agtPosition = agtPosition; }
    public Integer getAgencyId() { return agencyId; }
    public void setAgencyId(Integer agencyId) { this.agencyId = agencyId; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    @Override
    public String toString() {
        return "Agent{" +
                "agentId=" + agentId +
                ", agtFirstName='" + agtFirstName + '\'' +
                ", agtMiddleInitial='" + agtMiddleInitial + '\'' +
                ", agtLastName='" + agtLastName + '\'' +
                ", agtBusPhone='" + agtBusPhone + '\'' +
                ", agtEmail='" + agtEmail + '\'' +
                ", agtPosition='" + agtPosition + '\'' +
                ", agencyId=" + agencyId +
                ", password='" + password + '\'' +
                '}';
    }
}
