package models;

import java.io.Serializable;

public class StatisticUnit implements Serializable {

    private String statusLabel;
    private String repairTimeLabel;
    private String warrantyLabel;

    private int count;

    private StatisticUnit(Builder builder) {
        this.statusLabel = builder.statusLabel;
        this.repairTimeLabel = builder.repairTimeLabel;
        this.warrantyLabel = builder.warrantyLabel;
        this.count = builder.count;
    }

    public static class Builder implements Serializable {
        private String statusLabel;
        private String repairTimeLabel;
        private String warrantyLabel;

        private int count;

        public Builder() {
        }

        public StatisticUnit build() {
            return new StatisticUnit(this);
        }

        public Builder statusLabel(String statusLabel) {
            this.statusLabel = statusLabel;
            return this;
        }

        public Builder repairTimeLabel(String repairTimeLabel) {
            this.repairTimeLabel = repairTimeLabel;
            return this;
        }

        public Builder count(int count) {
            this.count = count;
            return this;
        }

        public Builder warrantyLabel(String warrantyLabel) {
            this.warrantyLabel = warrantyLabel;
            return this;
        }
    }

    public String getStatusLabel() {
        return statusLabel;
    }

    public void setStatusLabel(String statusLabel) {
        this.statusLabel = statusLabel;
    }

    public String getRepairTimeLabel() {
        return repairTimeLabel;
    }

    public void setRepairTimeLabel(String repairTimeLabel) {
        this.repairTimeLabel = repairTimeLabel;
    }

    public int getCount() {
        return count;
    }

    public void setCount(int count) {
        this.count = count;
    }

    public String getWarrantyLabel() {
        return warrantyLabel;
    }

    public void setWarrantyLabel(String warrantyLabel) {
        this.warrantyLabel = warrantyLabel;
    }
}
