package analyser;

import org.apache.storm.LocalCluster;

import java.util.Date;

public class Main {
    public static void main(String[] args) {
        LocalCluster cluster = new LocalCluster();
        cluster.activate("");
        System.out.println(new Date());
    }
}
