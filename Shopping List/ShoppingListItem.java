public class ShoppingListItem {
    private String name;
    private double quantity;
    private String unit; // e.g., "cups", "grams", "pieces"

    public ShoppingListItem(String name, double quantity, String unit) {
        this.name = name;
        this.quantity = quantity;
        this.unit = unit;
    }

    public String getName() {
        return name;
    }

    public double getQuantity() {
        return quantity;
    }

    public void setQuantity(double quantity) {
        this.quantity = quantity;
    }

    public String getUnit() {
        return unit;
    }
}