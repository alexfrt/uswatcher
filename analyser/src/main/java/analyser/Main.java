package analyser;

import org.apache.storm.Config;
import org.apache.storm.LocalCluster;
import org.apache.storm.topology.TopologyBuilder;
import org.elasticsearch.storm.EsSpout;

public class Main {
    public static void main(String[] args) throws InterruptedException {
        TopologyBuilder builder = new TopologyBuilder();
        builder.setSpout("es-spout", new EsSpout("packetbeat-2017.09.13/doc"));
        builder.setBolt("printer", new PrinterBolt()).shuffleGrouping("es-spout");

        Config config = new Config();
        config.put("es.nodes", "172.20.0.2");
        config.setDebug(true);

        LocalCluster cluster = new LocalCluster();
        cluster.submitTopology("analyserTopology", config, builder.createTopology());
    }
}
