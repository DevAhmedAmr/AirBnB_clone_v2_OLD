from fabric.api import *

env.hosts = ["34.227.93.198", "54.166.169.232"]
env.user = "ubuntu"
env.key_filename = r"C:\Users\ahmed\.ssh\pk3.pem"
put("./0-setup_web_static.sh", remote_path="/home/ubuntu")
sudo("chmod +x /home/ubuntu/0-setup_web_static.sh")
sudo("/home/ubuntu/0-setup_web_static.sh")
