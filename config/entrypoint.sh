#!/bin/sh
cd app 
composer update 
php artisan serve --host=0.0.0.0 --port=8000
