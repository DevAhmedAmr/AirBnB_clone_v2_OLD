#!/usr/bin/python3
"""
doc
"""
from fabric.api import *
from os.path import exists
from datetime import datetime
import os

env.hosts = ["34.227.93.198", "54.166.169.232"]
env.user = "ubuntu"
env.key_filename = r"C:\Users\ahmed\.ssh\pk3.pem"


def create_folder(name):
    if not exists(f"./{name}"):
        os.mkdir(name)


def create_tgz_name():
    time = datetime.now()
    current_time = time.strftime("%Y%m%d%H%M%S")
    return "web_static_" + current_time + ".tgz"


def do_pack():
    """create tar.gz of ./web_static folder"""
    create_folder("versions")
    tgz_fileName = create_tgz_name()
    try:
        output = local(f"tar -czvf {tgz_fileName}.tar.gz ./web_static", capture=True)
        return f"./{tgz_fileName}.tar.gz"
    except:
        return None


def extract_filename_from_path(archive_path):
    if archive_path is None or not archive_path:
        return ""  # Return empty string for None or empty path

    # Use os.path.basename to get the filename
    return os.path.basename(archive_path)


def do_deploy(archive_path):

    if archive_path is not None and exists(archive_path):
        archive_name = extract_filename_from_path(archive_path)
        c = put(archive_path, remote_path="/tmp/")
        filename, extension = os.path.splitext(archive_name)
        filename, extension = os.path.splitext(filename)
        filename, extension = os.path.splitext(filename)
        print(f"filename= {filename}")
        with cd("/tmp/"):
            sudo(f"mkdir /data/web_static/releases/{filename}")

            sudo(
                f"tar -xzf /tmp/{archive_name} -C /data/web_static/releases/{filename}"
            )
            run("pwd")
            sudo(f"rm ./{archive_name}")
            sudo("rm -r /data/web_static/current")
            sudo(
                f"ln -sf /data/web_static/releases/{filename} /data/web_static/current"
            )
            sudo(
                f"mv /data/web_static/releases/{filename}/web_static/* /data/web_static/releases/{filename}"
            )
            sudo(f"rm -rf /data/web_static/releases/{filename}/web_static")
            sudo(f"rm -rf /data/web_static/current")
            sudo(
                f"ln -s /data/web_static/releases/{filename}/ /data/web_static/current"
            )
            return True

    return False


def deploy():
    archive_path = do_pack()
    if archive_path is None:
        return False
    return do_deploy(archive_path)
