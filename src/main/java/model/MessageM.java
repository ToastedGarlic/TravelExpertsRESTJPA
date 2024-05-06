//created by Michael Chessal
package model;

import jakarta.persistence.*;
import jakarta.validation.constraints.Size;

import java.sql.Timestamp;

@Entity(name = "MessageM")
@Table(name = "messages")
public class MessageM {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MessageId", nullable = false)
    private Integer messageId;

    public Integer getMessageId() {
        return messageId;
    }

    public void setMessageId(Integer messageId) {
    }

    @Column(name = "MsgDate")
    private transient Timestamp msgDate;

    public Timestamp getMsgDate() {
        return msgDate;
    }

    public void setMsgDate(Timestamp msgDate) {
    }


    @Size(max = 50)
    @Column(name = "MsgContent", length = 50)
    private String msgContent;

    public String getMsgContent() {
        return msgContent;
    }

    public void setMsgContent(String msgContent) {
    }

    @Column(name = "AgentId")
    private Integer agentId;

    public Integer getAgentId() {
        return agentId;
    }
    public void setAgent(Integer agentId) {
        this.agentId = agentId;
    }

    @Column(name = "CustomerId")
    private Integer customerId;

    public Integer getCustomerId() {return customerId;}
    public void setCustomerId(Integer customerId) {this.customerId = customerId;}


}

