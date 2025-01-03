from setuptools import setup, find_packages
import os
from glob import glob

package_name = 'mypkg'

setup(
    name=package_name,
    version='0.0.0',
    packages=find_packages(include=['mypkg']),
    data_files=[
        ('share/ament_index/resource_index/packages',
            ['resource/' + package_name]),
        ('share/' + package_name, ['package.xml']),
        (os.path.join('share',package_name), glob('launch/*.launch.py'))        ],
    install_requires=['setuptools'],
    zip_safe=True,
    maintainer='taku0225',
    maintainer_email='s23c1037tg@s.chibakoudai.jp',
    description='a package for practice',
    license='BSD-3-Clause',
    tests_require=['pytest'],
    entry_points={
        'console_scripts': [
            'temperature = mypkg.temperature:main', #talker.pyのmain関数という意味
        ],
    },
)                                             
