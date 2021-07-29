#!/bin/bash

cd /var/www/html/
CURRENTDATE=`date +"%Y-%m-%d %T"`
before='updated:'
after="updated:${CURRENTDATE}"
sed -i "s/${before}/${after}/" index.html
