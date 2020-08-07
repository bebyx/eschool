#!/bin/sh

vagrant up db && notify-send "Database has been deployed"
vagrant up be1 && notify-send "Backend-1 has been deployed"
vagrant up be2 && notify-send "Backend-2 has been deployed"
vagrant up lb_be && notify-send "LoadBalancer (Backend) has been deployed"
vagrant up fe1 && notify-send "Frontend-1 has been deployed"
vagrant up fe2 && notify-send "Frontend-2 has been deployed"
vagrant up lb_fe && notify-send "LoadBalancer (Frontend) has been deployed"

notify-send "Web app has been completely deployed to Google Cloud"
