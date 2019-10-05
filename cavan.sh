#!/bin/sh /etc/rc.common

START=99
WGET="/usr/bin/wget -T 10 -t 5 -q --no-check-certificate"

cavan_daemon() {
	delay=0

	cd /tmp || return 1
	mkdir ./cavan
	cd ./cavan || return 1

	while :;
	do
		md5sum -c ./md5sum.txt && break

		sleep ${delay}
		[ ${delay} -lt 60 ] && let delay=1+${delay}

		rm * -rf
		${WGET} https://raw.githubusercontent.com/FuangCao/test/master/md5sum.txt || continue
		${WGET} https://raw.githubusercontent.com/FuangCao/test/master/cavan-main || continue
	done

	chmod a+x cavan-main

	./cavan-main tcp_repeater -dp 8864
	./cavan-main tcp_dd_server -dp 8888
	./cavan-main http_service -dp 8021
	./cavan-main web_proxy -dp 9090
}

start() {
	cavan_daemon &
}

stop() {
	killall cavan-main
}

