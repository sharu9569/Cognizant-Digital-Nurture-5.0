public class Forecast {

    public static double futureValue(double presentValue, double growthRate, int years){

        if(years == 0)
            return presentValue;

        return futureValue(presentValue*(1+growthRate),growthRate,years-1);

    }

    public static void main(String[] args) {

        double presentValue = 10000;
        double growthRate = 0.10;
        int years = 5;

        double future = futureValue(presentValue,growthRate,years);

        System.out.println("Future Value = "+future);

    }
}