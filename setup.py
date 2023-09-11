from setuptools import setup

from hubble import NAME, VERSION

setup(
    name=NAME,
    author="arash@kamangir.net",
    version=VERSION,
    description="tools to access and process Hubble Space Telescope imagery.",
    packages=[NAME],
)
