from setuptools import find_packages
from setuptools import setup

setup(
    name='musashi_msgs',
    version='0.0.0',
    packages=find_packages(
        include=('musashi_msgs', 'musashi_msgs.*')),
)
