from dotenv import load_dotenv
import os 
import yaml 
load_dotenv('/project/.env')



class Config :
    with open('/project/config/config.yml','r') as file:
        config_data = yaml.load(file , Loader=yaml.FullLoader)







config = Config()    
#print(config.access)