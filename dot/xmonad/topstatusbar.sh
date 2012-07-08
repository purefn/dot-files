#!/bin/bash

#Layout
BAR_H=8
BIGBAR_W=60
SMABAR_W=30
WIDTH=$1
HEIGHT=16
X_POS=0
Y_POS=0

#Look and feel
CRIT="#d74b73"
BAR_FG="#60a0c0"
BAR_BG="#363636"
DZEN_FG="#9d9d9d"
DZEN_FG2="#5f656b"
DZEN_BG="#050505"
COLOR_ICON="#60a0c0"
COLOR_SEP="#007b8c"
#FONT="-*-montecarlo-medium-r-normal-*-11-*-*-*-*-*-*-*"
FONT=$2

#Options
IFS='|' #internal field separator (conky)
CONKYFILE="/home/rwallace/.xmonad/conkyrc"
ICONPATH="/home/rwallace/.icons/subtle"
INTERVAL=1
CPUTemp=0
GPUTemp=0
CPULoad0=0
CPULoad1=0
NetUp=0
NetDown=0

printVolInfo() {
	Perc=$(amixer get Master | grep "Mono:" | awk '{print $4}' | tr -d '[]%')
	Mute=$(amixer get Master | grep "Mono:" | awk '{print $6}')
	if [[ $Mute == "[off]" ]]; then
		echo -n "^fg($COLOR_ICON)^i($ICONPATH/volume_off.xbm) "
		echo -n "^fg()"
		echo -n "$(echo $Perc | gdbar -fg $CRIT -bg $BAR_BG -h $BAR_H -w $BIGBAR_W -nonl)"
	else
		echo -n "^fg($COLOR_ICON)^i($ICONPATH/volume_on.xbm)"
		echo -n "^fg()"
		echo -n "$(echo $Perc | gdbar -fg $BAR_FG -bg $BAR_BG -h $BAR_H -w $BIGBAR_W -nonl)"
	fi
	return
}

printCPUInfo() {
	echo -n "^fg($COLOR_ICON)^i($ICONPATH/cpu.xbm) "
	echo -n "^fg()"
	echo -n "$(echo $CPULoad0 | gdbar -fg $BAR_FG -bg $BAR_BG -h $BAR_H -w $SMABAR_W -nonl) "
	echo -n "^fg()"
	#echo -n "$(echo $CPULoad1 | gdbar -fg $BAR_FG -bg $BAR_BG -h $BAR_H -w $SMABAR_W -nonl) "
	echo -n "${CPUFreq}GHz"
	return
}

printTempInfo() {
	CPUTemp=$(acpi --thermal -f | awk '{print $4}' | awk -F . '{print $1}')
	GPUTemp=$(nvidia-settings -q gpucoretemp | grep 'Attribute' | awk '{print $4}' | tr -d '.')
	if [[ $CPUTemp -gt 176 ]]; then
		CPUTemp="^fg($CRIT)$CPUTemp^fg()"
	fi
	if [[ $GPUTemp -gt 70 ]]; then
		GPUTemp="^fg($CRIT)$GPUTemp^fg()"
	fi
	echo -n "^fg($COLOR_ICON)^i($ICONPATH/temp.xbm) "
	echo -n "^fg($DZEN_FG2)cpu ^fg()${CPUTemp}f "
	echo -n "^fg($DZEN_FG2)gpu ^fg()${GPUTemp}f"
	return
}

printMemInfo() {
	echo -n "^fg($COLOR_ICON)^i($ICONPATH/memory.xbm) "
	echo -n "^fg()${MemUsed} "
	echo -n "$(echo $MemPerc | gdbar -fg $BAR_FG -bg $BAR_BG -h $BAR_H -w $SMABAR_W -nonl)"
	return
}

printBattery() {
	HasBat=$(acpi -b 2>&1 | grep -c power_supply)
	if [[ $HasBat == "1" ]]; then
		return
	fi
	BatPresent=$(acpi -b | wc -l)
	ACPresent=$(acpi -a | grep -c on-line)
	if [[ $ACPresent == "1" ]]; then
		echo -n "^fg($COLOR_ICON)^i($ICONPATH/ac1.xbm) "
	else
		echo -n "^fg($COLOR_ICON)^i($ICONPATH/battery_vert3.xbm) "
	fi
	if [[ $BatPresent == "0" ]]; then
		echo -n "^fg($DZEN_FG2)AC ^fg()on ^fg($DZEN_FG2)Bat ^fg()off"
		return
	else
		RPERC=$(acpi -b | awk '{print $4}' | tr -d "%,")
		echo -n "^fg()"
		if [[ $ACPresent == "1" ]]; then
			echo -n "$(echo $RPERC | gdbar -fg $BAR_FG -bg $BAR_BG -h $BAR_H -w $BIGBAR_W -nonl)"
		else
			echo -n "$(echo $RPERC | gdbar -fg $CRIT -bg $BAR_BG -h $BAR_H -w $BIGBAR_W -nonl)"
		fi
	fi
	return
}

printDateInfo() {
	echo -n "^fg()$(date '+%Y^fg(#444).^fg()%m^fg(#444).^fg()%d^fg(#007b8c)/^fg(#5f656b)%a ^fg(#a488d9)| ^fg()%H^fg(#444):^fg()%M^fg(#444):^fg()%S')"
	return
}

printSpace() {
	echo -n " ^fg($COLOR_SEP)|^fg() "
	return
}

printArrow() {
	echo -n " ^fg(#a488d9)>^fg(#007b8c)>^fg(#444444)> "
	return
}

printBar() {
	while true; do
		#read CPULoad0 CPULoad1 CPUFreq MemUsed MemPerc Uptime
		read CPULoad0 CPUFreq MemUsed MemPerc Uptime
		echo -n "^pa(1100)"
		printSpace
		printCPUInfo
		printSpace
		printMemInfo
		printArrow
		printSpace
		printTempInfo
		printSpace
		printBattery
		printSpace
		printVolInfo
		printArrow
		#echo -n "^pa(1760)"
		printDateInfo
		echo
	done
	return
}

#Print all and pipe into dzen
conky -c $CONKYFILE -u $INTERVAL | printBar | dzen2 -x $X_POS -y $Y_POS -w $WIDTH -h $HEIGHT -fn "$FONT" -ta 'l' -bg $DZEN_BG -fg $DZEN_FG -p -e ''

