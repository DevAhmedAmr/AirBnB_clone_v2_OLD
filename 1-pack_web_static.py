#!/usr/bin/python3
"""
doc
"""
from os.path import exists
from datetime import datetime
import os
from fabric.api import local


def create_folder(name):
    if not exists(f"./{name}"):
        os.mkdir(name)


def create_tgz_name():
    time = datetime.now()
    current_time = time.strftime("%Y%m%d%H%M%S")
    return "web_static_" + current_time + ".tgz"


def do_pack():
    create_folder("versions")
    tgz_fileName = create_tgz_name()
    output = local(f"tar -czvf {tgz_fileName}.tar.gz ./web_static", capture=True)
    return f"./{tgz_fileName}.tar.gz"
