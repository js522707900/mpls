#!/usr/bin/env bash
RED_COLOR="\033[0;31m"
NO_COLOR="\033[0m"
GREEN="\033[32m\033[01m"
BLUE="\033[0;36m"
FUCHSIA="\033[0;35m"
echo "export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin:$PATH" >> ~/.bashrc
source ~/.bashrc
echo -e "
 ${GREEN} 1.部署mpls
 ${GREEN} 2.落地机添加新代理
 ${GREEN} 3.安装frp
 ${GREEN} 4.安装内核
 ${GREEN} 5.删除防火墙
 ${GREEN} 6.管理frp
 "
 cd
 read -p "输入选项:" aNum
 if [ "$aNum" = "1" ];then
 cd
echo -e "
 ${GREEN} 1.落地机
 ${GREEN} 2.中转机
 "
 read -p "输入选项:" bNum
if [ "$bNum" = "1" ];then
echo -e "
 ${GREEN} 1.广港1(gzhkmpls1) 
 "
 read -p "请输入括号里的代号:" mplsdh
 cd
 wget -N --no-check-certificate "https://github.91chi.fun//https://raw.githubusercontent.com/js522707900/mpls/${mplsdh}/luodi/client.crt"
 wget -N --no-check-certificate "https://github.91chi.fun//https://raw.githubusercontent.com/js522707900/mpls/${mplsdh}/luodi/client.key"
 wget -N --no-check-certificate "https://github.91chi.fun//https://raw.githubusercontent.com/js522707900/mpls/${mplsdh}/luodi/ca.crt"
 cd frp_0.39.0_linux_amd64 && rm -rf frpc.ini && wget -N --no-check-certificate "https://github.91chi.fun//https://raw.githubusercontent.com/js522707900/mpls/${mplsdh}/luodi/frpc.ini"
 nohup ./frpc -c ./frpc.ini >> /dev/null 2>&1 &
 elif [ "$bNum" = "2" ];then
echo -e "
 ${GREEN} 1.广港1(gzhkmpls1) 
 "
 read -p "请输入括号里的代号:" mplsdh
 cd
 wget -N --no-check-certificate "https://github.91chi.fun//https://raw.githubusercontent.com/js522707900/mpls/${mplsdh}/zhongzhuan/server.crt"
 wget -N --no-check-certificate "https://github.91chi.fun//https://raw.githubusercontent.com/js522707900/mpls/${mplsdh}/zhongzhuan/server.key"
 wget -N --no-check-certificate "https://github.91chi.fun//https://raw.githubusercontent.com/js522707900/mpls/${mplsdh}/zhongzhuan/ca.crt"
 cd frp_0.39.0_linux_amd64 && rm -rf frps.ini &&  wget -N --no-check-certificate "https://github.91chi.fun//https://raw.githubusercontent.com/js522707900/mpls/${mplsdh}/zhongzhuan/frps.ini"
 nohup ./frps -c ./frps.ini >> /dev/null 2>&1 &
 fi
 elif [ "$aNum" = "2" ];then
 cd
 echo -e "
 ${GREEN} 1.tcp代理
 ${GREEN} 2.udp代理
 "
 read -p "请输入选项:" bNum
 if [ "$bNum" = "1" ];then
 read -p "请输入代理名称(不可重复):" dlname
 read -p "输入ss节点ip:" ssip
 read -p "输入ss节点端口:" ssport
 read -p "输入中转监听端口:" zzport
echo "
[${dlname}]
type = tcp
local_ip = ${ssip}
local_port = ${ssport}
remote_port = ${zzport}
" >> /root/frp_0.39.0_linux_amd64/frpc.ini
 elif [ "$bNum" = "2" ];then
echo "
[${dlname}]
type = udp
local_ip = ${ssip}
local_port = ${ssport}
remote_port = ${zzport}
" >> /root/frp_0.39.0_linux_amd64/frpc.ini
 fi
 systemctl restart frpc
 elif [ "$aNum" = "3" ];then
 cd
 wget https://github.91chi.fun//https://github.com//fatedier/frp/releases/download/v0.39.0/frp_0.39.0_linux_amd64.tar.gz
 tar -xvzf frp_0.39.0_linux_amd64.tar.gz
 echo -e "
 ${GREEN} 1.落地机
 ${GREEN} 2.中转机
 "
read -p "输入选项:" bNum
if [ "$bNum" = "1" ] ;then
echo "
[Unit]
Description=frpc service
After=network.target network-online.target syslog.target
Wants=network.target network-online.target
[Service]
Type=simple
#启动服务的命令（此处写你的frpc的实际安装目录）
ExecStart=/root/frp_0.39.0_linux_amd64/frpc -c /root/frp_0.39.0_linux_amd64/frpc.ini
[Install]
WantedBy=multi-user.target
" > /lib/systemd/system/frpc.service
systemctl enable frpc
elif [ "$bNum" = "2" ] ;then
echo "
[Unit]
Description=frps service
After=network.target network-online.target syslog.target
Wants=network.target network-online.target
[Service]
Type=simple
#启动服务的命令（此处写你的frps的实际安装目录）
ExecStart=/root/frp_0.39.0_linux_amd64/frps -c /root/frp_0.39.0_linux_amd64/frps.ini
[Install]
WantedBy=multi-user.target
" > /lib/systemd/system/frps.service
systemctl enable frps
fi
 elif [ "$aNum" = "4" ];then
 wget -N --no-check-certificate "https://raw.githubusercontent.com/ylx2016/Linux-NetSpeed/master/tcp.sh" && chmod +x tcp.sh && ./tcp.sh
 elif [ "$aNum" = "5" ];then
 if [[ "$EUID" -ne 0 ]]; then
    echo "false"
  else
    echo "true"
  fi
if [[ -f /etc/redhat-release ]]; then
		release="centos"
	elif cat /etc/issue | grep -q -E -i "debian"; then
		release="debian"
	elif cat /etc/issue | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
	elif cat /proc/version | grep -q -E -i "debian"; then
		release="debian"
	elif cat /proc/version | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
    fi
    
     if [[ $release = "ubuntu" || $release = "debian" ]]; then
ufw disable
apt-get remove ufw
apt-get purge ufw
  elif [[ $release = "centos" ]]; then
  systemctl stop firewalld.service
  systemctl disable firewalld.service 
  else
    exit 1
  fi
  elif [ "$aNum" = "6" ];then
  echo -e "
 ${GREEN} 1.停止frpc
 ${GREEN} 2.启动frpc
 ${GREEN} 3.重启frpc
 ${GREEN} 4.停止frps
 ${GREEN} 5.启动frps
 ${GREEN} 6.重启frps
 ${GREEN} 7.查看frpc状态
 ${GREEN} 8.查看frps状态
 "
 read -p "请输入选项:" bNum
 if [ "$bNum" = "1" ];then
 systemctl stop frpc
 elif [ "$bNum" = "2" ];then
 systemctl start frpc
 elif [ "$bNum" = "3" ];then
 systemctl restart frpc
 elif [ "$bNum" = "4" ];then
 systemctl stop frps
 elif [ "$bNum" = "5" ];then
 systemctl start frps
 elif [ "$bNum" = "6" ];then
 systemctl restart frps
 elif [ "$bNum" = "7" ];then
 systemctl enable frpc
 elif [ "$bNum" = "8" ];then
 systemctl enable frps
 fi
  fi
