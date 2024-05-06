//created by mohsen
package model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.math.BigDecimal;
import java.sql.Timestamp;

@Entity
@Table(name = "packages")
public class Package {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "PackageId", nullable = false)
    private Integer id;

    @Size(max = 50)
    @NotNull
    @Column(name = "PkgName", nullable = false, length = 50)
    private String pkgName;

    @Column(name = "PkgStartDate")
    private Timestamp pkgStartDate;

    @Column(name = "PkgEndDate")
    private Timestamp pkgEndDate;

    @Size(max = 50)
    @Column(name = "PkgDesc", length = 50)
    private String pkgDesc;

    @NotNull
    @Column(name = "PkgBasePrice", nullable = false, precision = 19, scale = 4)
    private BigDecimal pkgBasePrice;

    @Column(name = "PkgAgencyCommission", precision = 19, scale = 4)
    private BigDecimal pkgAgencyCommission;

    // Getters and Setters
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getPkgName() {
        return pkgName;
    }

    public void setPkgName(String pkgName) {
        this.pkgName = pkgName;
    }

    public Timestamp getPkgStartDate() {
        return pkgStartDate;
    }

    public void setPkgStartDate(Timestamp pkgStartDate) {
        this.pkgStartDate = pkgStartDate;
    }

    public Timestamp getPkgEndDate() {
        return pkgEndDate;
    }

    public void setPkgEndDate(Timestamp pkgEndDate) {
        this.pkgEndDate = pkgEndDate;
    }

    public String getPkgDesc() {
        return pkgDesc;
    }

    public void setPkgDesc(String pkgDesc) {
        this.pkgDesc = pkgDesc;
    }

    public BigDecimal getPkgBasePrice() {
        return pkgBasePrice;
    }

    public void setPkgBasePrice(BigDecimal pkgBasePrice) {
        this.pkgBasePrice = pkgBasePrice;
    }

    public BigDecimal getPkgAgencyCommission() {
        return pkgAgencyCommission;
    }

    public void setPkgAgencyCommission(BigDecimal pkgAgencyCommission) {
        this.pkgAgencyCommission = pkgAgencyCommission;
    }
}
