#!/bin/bash

#run this script to install pip dependencies
virtualenv .env && source .env/bin/activate && pip install -r requirements.txt