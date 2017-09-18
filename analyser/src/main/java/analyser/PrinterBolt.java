package analyser;

import org.apache.storm.topology.BasicOutputCollector;
import org.apache.storm.topology.OutputFieldsDeclarer;
import org.apache.storm.topology.base.BaseBasicBolt;
import org.apache.storm.tuple.Tuple;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class PrinterBolt extends BaseBasicBolt {

    private static final Logger LOGGER = LoggerFactory.getLogger(PrinterBolt.class);

    @Override
    public void execute(Tuple input, BasicOutputCollector collector) {
        Object value = input.getValueByField("doc");
        LOGGER.info("babau", value);

        collector.
    }

    @Override
    public void declareOutputFields(OutputFieldsDeclarer declarer) {
    }

}
