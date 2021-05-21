# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
 config.vm.box = "bento/ubuntu-20.04"

 # Configs for web server 1
 config.vm.define :servidorVM2 do |servidorVM2|
   servidorVM2.vm.network "public_network" , ip:"192.168.0.3" 
   servidorVM2.vm.hostname = "servidorVM2"
 end

 # Configs for web server 2
 config.vm.define :servidorVM3 do |servidorVM3|
   servidorVM3.vm.network "public_network" , ip:"192.168.0.4" 
   servidorVM3.vm.hostname = "servidorVM3"
 end
 # Configs for web server 3 backup
 config.vm.define :servidorVM4 do |servidorVM4|
   servidorVM4.vm.network "public_network" , ip:"192.168.0.5" 
   servidorVM4.vm.hostname = "servidorVM4"
 end

 # Configs for web server 4 backup
 config.vm.define :servidorVM5 do |servidorVM5|
   servidorVM5.vm.network "public_network" , ip:"192.168.0.6" 
   servidorVM5.vm.hostname = "servidorVM5"
 end

 # Configs for haproxy
 config.vm.define :clienteVM1 do |clienteVM1|
   clienteVM1.vm.network "public_network" , ip:"192.168.0.31" 
   clienteVM1.vm.hostname = "clienteVM1"
 end
end
