import requests
import time
import logging


def get_module_logger(mod_name):
    logger = logging.getLogger(mod_name)
    handler = logging.StreamHandler()
    formatter = logging.Formatter(
        '%(asctime)s [%(name)-12s] %(levelname)-8s %(message)s')
    handler.setFormatter(formatter)
    logger.addHandler(handler)
    logger.setLevel(logging.DEBUG)
    return logger

if __name__ == '__main__':
	restURL = 'http://producer:9090/v1.0/items/'
	sleepTime = 10
	log = get_module_logger("Consumer")
	while True:
		try:
			response = requests.get(restURL)
			assert response.status_code == 200
			log.info("Successfully retrieved data from Rest API")
			log.info(response.json())
			time.sleep(sleepTime)
		except:
			log.info("Connection refused by the server..")
			log.info("Retrying after 10 seconds")
			time.sleep(sleepTime)
			continue
        