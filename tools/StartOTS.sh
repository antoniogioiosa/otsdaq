#!/bin/sh

function defineColors ()
{
  # Regular Colors
  Black='\033[0;30m'        # Black
  Red='\033[0;31m'          # Red
  Green='\033[0;32m'        # Green
  Yellow='\033[0;33m'       # Yellow
  Blue='\033[0;34m'         # Blue
  Purple='\033[0;35m'       # Purple
  Cyan='\033[0;36m'         # Cyan
  White='\033[0;37m'        # White

  # Bold
  BBlack='\033[1;30m'       # Black
  BRed='\033[1;31m'         # Red
  BGreen='\033[1;32m'       # Green
  BYellow='\033[1;33m'      # Yellow
  BBlue='\033[1;34m'        # Blue
  BPurple='\033[1;35m'      # Purple
  BCyan='\033[1;36m'        # Cyan
  BWhite='\033[1;37m'       # White

  # Underline
  UBlack='\033[4;30m'       # Black
  URed='\033[4;31m'         # Red
  UGreen='\033[4;32m'       # Green
  UYellow='\033[4;33m'      # Yellow
  UBlue='\033[4;34m'        # Blue
  UPurple='\033[4;35m'      # Purple
  UCyan='\033[4;36m'        # Cyan
  UWhite='\033[4;37m'       # White

  # Background
  On_Black='\033[40m'       # Black
  On_Red='\033[41m'         # Red
  On_Green='\033[42m'       # Green
  On_Yellow='\033[43m'      # Yellow
  On_Blue='\033[44m'        # Blue
  On_Purple='\033[45m'      # Purple
  On_Cyan='\033[46m'        # Cyan
  On_White='\033[47m'       # White

  # High Intensity
  IBlack='\033[0;90m'       # Black
  IRed='\033[0;91m'         # Red
  IGreen='\033[0;92m'       # Green
  IYellow='\033[0;93m'      # Yellow
  IBlue='\033[0;94m'        # Blue
  IPurple='\033[0;95m'      # Purple
  ICyan='\033[0;96m'        # Cyan
  IWhite='\033[0;97m'       # White

  # Bold High Intensity
  BIBlack='\033[1;90m'      # Black
  BIRed='\033[1;91m'        # Red
  BIGreen='\033[1;92m'      # Green
  BIYellow='\033[1;93m'     # Yellow
  BIBlue='\033[1;94m'       # Blue
  BIPurple='\033[1;95m'     # Purple
  BICyan='\033[1;96m'       # Cyan
  BIWhite='\033[1;97m'      # White

  # High Intensity backgrounds
  On_IBlack='\033[0;100m'   # Black
  On_IRed='\033[0;101m'     # Red
  On_IGreen='\033[0;102m'   # Green
  On_IYellow='\033[0;103m'  # Yellow
  On_IBlue='\033[0;104m'    # Blue
  On_IPurple='\033[0;105m'  # Purple
  On_ICyan='\033[0;106m'    # Cyan
  On_IWhite='\033[0;107m'   # White

  Bold=`tput bold`          # Select bold mode                  
  DIM=`tput dim`            # Select dim (half-bright) mode     
  Blink=`tput blink`        # Select dim (half-bright) mode 
  EUNDERLINE=`tput smul`    # Enable underline mode             
  DUNDERLINE=`tput rmul`    # Disable underline mode            
  REV=`tput rev`            # Turn on reverse video mode        
  Reset=`tput sgr0`         # Reset all                         
  EBold=`tput smso`         # Enter standout (bold) mode        
  DBold=`tput rmso`         # Exit standout mode                
}

#for some reason, this function does not exist in this script.. recreating
function toffS () 
{ 
	${TRACE_BIN}/trace_cntl lvlclr 0 `bitN_to_mask "$@"` 0
}

function muteTrace() 
{
	#source /data/ups/setup
	#setup TRACE v3_13_04
	#ups active
	#which trace_cntl
	#type toffS
	
	#for muting trace
	export TRACE_NAME=OTSDAQ_TRACE
	 
	#type toffS
	
	toffS 0-63 -n CONF:OpBase_C
	toffS 0-63 -n CONF:OpLdStr_C
	toffS 0-63 -n CONF:CrtCfD_C
	toffS 0-63 -n COFS:DpFle_C
	toffS 0-63 -n PRVDR:FileDB_C
	toffS 0-63 -n PRVDR:FileDBIX_C
	toffS 0-63 -n JSNU:Document_C
	toffS 0-63 -n JSNU:DocUtils_C
	toffS 0-63 -n CONF:LdStrD_C
	toffS 0-63 -n FileDB:RDWRT_C
	
	${TRACE_BIN}/trace_cntl lvlset 0 0x1f 0	
}

export TRACE_FILE=/tmp/trace_buffer_${USER}

defineColors
muteTrace
		
HOSTNAME_ARR=($(echo "${HOSTNAME}" | tr '.' " "))
#for i in "${!HOSTNAME_ARR[@]}"
#do
#    echo "$i=>${HOSTNAME_ARR[i]}"
#done
#echo ${HOSTNAME_ARR[0]}

echo
echo
echo "  |"
echo "  |"
echo "  |"
echo " _|_"
echo " \ /"
echo "  V "
echo "${Reset}"

STARTTIME=`date +"%h%y.%T"` #to fully ID one StartOTS from another
echo -e "${STARTTIME}  <==  StartOTS.sh start time."
echo 

echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t${Green}=========================== StartOTS.sh =============================${Reset}"
echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t${BGreen}Launching server on {${HOSTNAME}}.${Reset}"

SCRIPT_DIR="$( 
 cd "$(dirname "$(readlink "$0" || printf %s "$0")")"
 pwd -P 
)"
		
unalias ots.exe &>/dev/null 2>&1 #hide output
alias ots.exe='xdaq.exe' &>/dev/null #hide output



ISCONFIG=0
QUIET=1
CHROME=0
FIREFOX=0
BACKUPLOGS=0

#check for options
if [[ "$1"  == "--config" || "$1"  == "--configure" || "$1"  == "--wizard" || "$1"  == "--wiz" || "$1"  == "-w" || "$2"  == "--config" || "$2"  == "--configure" || "$2"  == "--wizard" || "$2"  == "--wiz" || "$2"  == "-w" ]]; then	
	echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t************* ${RED}WIZ MODE ENABLED!${Reset}             *************"      
    ISCONFIG=1
fi

if [[ "$1"  == "--verbose" || "$2"  == "--verbose" || "$1"  == "-v" || "$2"  == "-v"  ]]; then
	echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t************* ${RED}VERBOSE MODE ENABLED!${Reset}         ************"
	QUIET=0
fi

if [[ "$1"  == "--chrome" || "$2"  == "--chrome" || "$1"  == "-c" || "$2"  == "-c"  ]]; then
	echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t************* ${RED}GOOGLE-CHROME LAUNCH ENABLED!${Reset} ************"
	CHROME=1
fi

if [[ "$1"  == "--firefox" || "$2"  == "--firefox" || "$1"  == "-f" || "$2"  == "-f"  ]]; then
	echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t************* ${RED}FIREFOX LAUNCH ENABLED${Reset}!       ************"
	FIREFOX=1
fi

if [[ "$1"  == "--backup" || "$2"  == "--backup" || "$1"  == "-b" || "$2"  == "-b"  ]]; then
	echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t************* ${RED}BACKUP LOGS ENABLED!${Reset}          ************"
	BACKUPLOGS=1
fi
#end check for options

#############################
#initializing StartOTS action file
#attempt to mkdir for full path so that it exists to move the database to
# assuming mkdir is non-destructive
#Note: quit file added to universally quit StartOTS scripts originating from same USER_DATA
#Note: local path quit file added to universally quit StartOTS scripts originating from same directory (regardless of USER_DATA)
# can not come from action file because individual StartOTS scripts need to respond to that one.
# The gateway supervisor StartOTS script drives the quit file.

OTSDAQ_STARTOTS_ACTION_FILE="${USER_DATA}/ServiceData/StartOTS_action_${HOSTNAME}.cmd" #the targeted hostname action script gives commands to StartOTS scripts running on that host
OTSDAQ_STARTOTS_QUIT_FILE="${USER_DATA}/ServiceData/StartOTS_action_quit.cmd" #the global quit gives exit commonds to the non-gateway StartOTS scripts
OTSDAQ_STARTOTS_LOCAL_QUIT_FILE=".StartOTS_action_quit.cmd" #the local quit is used to remove other StartOTS calls from the same directory (it catches the case when switching USER_DATA paths)

echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\tScript path              = ${SCRIPT_DIR}/StartOTS.sh         "
echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\tStartOTS_action path     = ${OTSDAQ_STARTOTS_ACTION_FILE}    "
echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\tStartOTS_quit path       = ${OTSDAQ_STARTOTS_QUIT_FILE}      "
echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\tStartOTS_local_quit path = ${OTSDAQ_STARTOTS_LOCAL_QUIT_FILE}"

SAP_ARR=$(echo "${USER_DATA}/ServiceData" | tr '/' "\n")
SAP_PATH=""
for SAP_EL in ${SAP_ARR[@]}
do
	#echo $SAP_EL
	SAP_PATH="$SAP_PATH/$SAP_EL"
	#echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t$SAP_PATH"
			
	mkdir -p $SAP_PATH &>/dev/null #hide output
done

#exit any old action loops
echo "EXIT_LOOP" > $OTSDAQ_STARTOTS_ACTION_FILE

#done initializing StartOTS action file
#############################

#############################
#############################
# function to kill all things ots
function killprocs 
{	
	if [[ "x$1" == "x" ]]; then #kill all ots processes

		killall ots.exe 	&>/dev/null 2>&1 #hide output
		killall xdaq.exe 	&>/dev/null 2>&1 #hide output
		killall otsConsoleFwd 	&>/dev/null 2>&1 #hide output #message viewer display without decoration
		killall mf_rcv_n_fwd 			&>/dev/null 2>&1 #hide output #message viewer display without decoration #deprecated name		
		killall art 		&>/dev/null 2>&1 #hide output
		killall -9 ots.exe 	&>/dev/null 2>&1 #hide output
		killall -9 xdaq.exe	&>/dev/null 2>&1 #hide output
		killall -9 otsConsoleFwd &>/dev/null 2>&1 #hide output #message viewer display without decoration
		killall -9 mf_rcv_n_fwd 		 &>/dev/null 2>&1 #hide output #message viewer display without decoration #deprecated name
		killall -9 art 		&>/dev/null 2>&1 #hide output
		
		usershort=`echo $USER|cut -c 1-10`
		for key in `ipcs|grep $usershort|grep ' 0 '|awk '{print $1}'`;do ipcrm -M $key;done

		
	else #then killing only non-gateway contexts
		
		PIDS=""
		for contextPID in "${ContextPIDArray[@]}"
		do
			echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t${Red}{$Rev}Killing Nongateway-PID${Reset} ${contextPID}"
			PIDS+=" ${contextPID}"
		done
		
		#echo Killing PIDs: $PIDS
		kill    $PIDS &>/dev/null 2>&1 #hide output
		kill -9 $PIDS &>/dev/null 2>&1 #hide output

		unset ContextPIDArray #done with array of PIDs, so clear
	fi
	
	sleep 1 #give time for cleanup to occur
	
} #end killprocs
export -f killprocs

if [[ "$1"  == "--killall" || "$1"  == "--kill" || "$1"  == "--kx" || "$1"  == "-k" ]]; then

	echo
	echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t${Yellow}${Bold}${Rev}******************************************************${Reset}"
	echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t${Yellow}${Bold}${Rev}*************        otsdaq!        **************${Reset}"
        echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t${Yellow}${Bold}${Rev}******************************************************${Reset}"
	echo
	
	#try to force kill other StartOTS scripts
	echo "EXIT_LOOP" > $OTSDAQ_STARTOTS_QUIT_FILE
	echo "EXIT_LOOP" > $OTSDAQ_STARTOTS_LOCAL_QUIT_FILE
	
        echo "${IBRed}"
        killprocs	
	killall -9 StartOTS.sh &>/dev/null 2>&1 #hide output
        echo "${Reset}"
	
	exit
fi

if [[ $ISCONFIG == 0 && $QUIET == 1 && $CHROME == 0 && $FIREFOX == 0 && $BACKUPLOGS == 0 && "$1x" != "x" ]]; then
	echo 
	echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t${Red}${Bold}${Blink}Unrecognized parameter(s)${Reset} ${BIBlue}$1 $2${Reset} [Note: only two parameters are considered, others are ignored]. "
	echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t${BIGreen}Usage${Reset}:"
	echo
        echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t******************************************************"
	echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t*************    StartOTS.sh Usage      **************"
        echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t******************************************************"
	echo
	echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\tTo kill all otsdaq running processes, please use any of these options:"
	echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t--killall  --kill  --kx  -k"
	echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t	e.g.: StartOTS.sh --kx"
	echo
	echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\tTo start otsdaq in 'wiz mode' please use any of these options:"
	echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t--configure  --config  --wizard  --wiz  -w"
	echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\te.g.: StartOTS.sh --wiz"
	echo
	echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\tTo start otsdaq with 'verbose mode' enabled, add one of these options:"
	echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t--verbose  -v"
	echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\te.g.: StartOTS.sh --wiz -v     or    StartOTS.sh --verbose"
	echo
	echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\tTo start otsdaq and launch google-chrome, add one of these options:"
	echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t--chrome  -c"
	echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\te.g.: StartOTS.sh --wiz -c     or    StartOTS.sh --chrome"
	echo
	echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\tTo start otsdaq and launch firefox, add one of these options:"
	echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t--firefox  -f"
	echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\te.g.: StartOTS.sh --wiz -f     or    StartOTS.sh --firefox"
	echo
	echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\tTo backup and not overwrite previous quiet log files, add add one of these options:"
	echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t--backup  -b"
	echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\te.g.: StartOTS.sh -b     or    StartOTS.sh --backup"
	echo
	echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\tExiting StartOTS.sh. Please see usage tips above."
	echo
	exit
fi

#SERVER=`hostname -f || ifconfig eth0|grep "inet addr"|cut -d":" -f2|awk '{print $1}'`
export SUPERVISOR_SERVER=$HOSTNAME #$SERVER
if [ $ISCONFIG == 1 ]; then
    export OTS_CONFIGURATION_WIZARD_SUPERVISOR_SERVER=$SERVER
fi

 #Can be File, Database, DatabaseTest
export CONFIGURATION_TYPE=File

# Setup environment when building with MRB
if [ "x$MRB_BUILDDIR" != "x" ] && [ -e $OTSDAQ_DEMO_DIR/CMakeLists.txt ]; then
  export OTSDAQDEMO_BUILD=${MRB_BUILDDIR}/otsdaq_demo
  export OTSDAQ_DEMO_LIB=${MRB_BUILDDIR}/otsdaq_demo/lib
  export OTSDAQDEMO_REPO=$OTSDAQ_DEMO_DIR
  unset  OTSDAQ_DEMO_DIR
fi

if [ "x$MRB_BUILDDIR" != "x" ] && [ -e $OTSDAQ_DIR/CMakeLists.txt ]; then
  export OTSDAQ_BUILD=${MRB_BUILDDIR}/otsdaq
  export OTSDAQ_LIB=${MRB_BUILDDIR}/otsdaq/lib
  export OTSDAQ_REPO=$OTSDAQ_DIR
  export FHICL_FILE_PATH=.:$OTSDAQ_REPO/tools/fcl:$FHICL_FILE_PATH
fi
  
if [ "x$MRB_BUILDDIR" != "x" ] && [ -e $OTSDAQ_UTILITIES_DIR/CMakeLists.txt ]; then
  export OTSDAQUTILITIES_BUILD=${MRB_BUILDDIR}/otsdaq_utilities
  export OTSDAQ_UTILITIES_LIB=${MRB_BUILDDIR}/otsdaq_utilities/lib
  export OTSDAQUTILITIES_REPO=$OTSDAQ_UTILITIES_DIR
fi

if [ "x$OTSDAQ_DEMO_DIR" == "x" ]; then
  export OTSDAQ_DEMO_DIR=$OTSDAQDEMO_BUILD
fi

if [ "x$USER_WEB_PATH" == "x" ]; then  #setup the location for user web-apps
  export USER_WEB_PATH=$OTSDAQ_DEMO_DIR/UserWebGUI 
fi

#setup web path as XDAQ is setup.. 
#then make a link to user specified web path.
WEB_PATH=${OTSDAQ_UTILITIES_DIR}/WebGUI
#echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\tWEB_PATH=$WEB_PATH"
#echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\tUSER_WEB_PATH=$USER_WEB_PATH"
#echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\tMaking symbolic link to USER_WEB_PATH"
#echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\tln -s $USER_WEB_PATH $WEB_PATH/UserWebPath"
ln -s $USER_WEB_PATH $WEB_PATH/UserWebPath &>/dev/null  #hide output


if [ "x$USER_DATA" == "x" ]; then
	echo
	echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t${Red}${Bold}${Blink}Fatal Error${Reset}."
	echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\tEnvironment variable ${Cyan}${Bold}USER_DATAr${Reset} has not been setup!"
	echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\tTo setup, use 'export USER_DATA=<path to user data>'"
	echo
	echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t(If you do not have a user data folder copy '<path to ots source>/otsdaq-demo/Data' as your starting point.)"
	echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t${Red}${Bold}${Blink}Aborting launch${Reset}"
	echo
	exit    
fi

if [ ! -d $USER_DATA ]; then
	echo
	echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t${Red}${Bold}${Blink}Fatal Error${Reset}."
	echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\tUSER_DATA=$USER_DATA"
	echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\tEnvironment variable ${Cyan}${Bold}USER_DATA${Reset} does not point to a valid directory!"
	echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\tTo setup, use 'export USER_DATA=<path to user data>'"
	echo 
	echo
	echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t(If you do not have a user data folder copy '<path to ots source>/otsdaq-demo/Data' as your starting point.)"
	echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t${Red}${Bold}${Blink}Aborting launch${Reset}"
	echo
	exit   
fi

#print out important environment variables
echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t\$USER_DATA               = ${YELLOW}${USER_DATA}${Reset}          "
echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t\$ARTDAQ_DATABASE_URI     = ${YELLOW}${Bold}${ARTDAQ_DATABASE_URI}${DBold}${Reset}"
echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t\$OTSDAQ_DATA             = ${YELLOW}${OTSDAQ_DATA}${Reset}        "
#end print out important environment variables

#check for antiquated artdaq databse
ARTDAQ_DATABASE_DIR=`echo ${ARTDAQ_DATABASE_URI}|sed 's|.*//|/|'`	
if [ ! -e ${ARTDAQ_DATABASE_DIR}/fromIndexRebuild ]; then
	# Rebuild ARTDAQ_DATABASE indicies
	echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\tRebuilding database indices..."
	rebuild_database_index >/dev/null 2>&1; rebuild_database_index --uri=${ARTDAQ_DATABASE_URI} >/dev/null 2>&1
	
	mv ${ARTDAQ_DATABASE_DIR} ${ARTDAQ_DATABASE_DIR}.bak.$$		
	mv ${ARTDAQ_DATABASE_DIR}_new ${ARTDAQ_DATABASE_DIR}
	echo "rebuilt" > ${ARTDAQ_DATABASE_DIR}/fromIndexRebuild
#else
#	echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t${ARTDAQ_DATABASE_DIR}/fromIndexRebuild file exists, so not rebuilding indices."
fi

export CONFIGURATION_DATA_PATH=${USER_DATA}/ConfigurationDataExamples
export CONFIGURATION_INFO_PATH=${USER_DATA}/ConfigurationInfo
export SERVICE_DATA_PATH=${USER_DATA}/ServiceData
export XDAQ_CONFIGURATION_DATA_PATH=${USER_DATA}/XDAQConfigurations
export LOGIN_DATA_PATH=${USER_DATA}/ServiceData/LoginData
export LOGBOOK_DATA_PATH=${USER_DATA}/ServiceData/LogbookData
export PROGRESS_BAR_DATA_PATH=${USER_DATA}/ServiceData/ProgressBarData
export ROOT_DISPLAY_CONFIG_PATH=${USER_DATA}/RootDisplayConfigData

if [ "x$OTSDAQ_DATA" == "x" ];then
	export OTSDAQ_DATA=/tmp
fi

#make directory if it does not exist
mkdir -p ${OTSDAQ_DATA} || echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\tError: OTSDAQ_DATA path (${OTSDAQ_DATA}) does not exist and mkdir failed!"

if [ "x$ROOT_BROWSER_PATH" == "x" ];then
	export ROOT_BROWSER_PATH=${OTSDAQ_DATA}
fi

if [ "x$OTSDAQ_LOG_DIR" == "x" ];then
    export OTSDAQ_LOG_DIR="${USER_DATA}/Logs"
fi

if [ "x${ARTDAQ_OUTPUT_DIR}" == "x" ]; then
    export ARTDAQ_OUTPUT_DIR="${USER_DATA}/ArtdaqData"
fi

if [ ! -d $ARTDAQ_OUTPUT_DIR ]; then
    mkdir -p $ARTDAQ_OUTPUT_DIR
fi

if [ ! -d $OTSDAQ_LOG_DIR ]; then
    mkdir -p $OTSDAQ_LOG_DIR
fi
export OTSDAQ_LOG_ROOT=$OTSDAQ_LOG_DIR

##############################################################################
export XDAQ_CONFIGURATION_XML=otsConfigurationNoRU_CMake #-> 
##############################################################################


#echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\tARTDAQ_MFEXTENSIONS_DIR=" ${ARTDAQ_MFEXTENSIONS_DIR}

#at end print out connection instructions using MAIN_URL
MAIN_URL="unknown_url"
MPI_RUN_CMD=""

	
#declare launch functions

####################################################################
####################################################################
################## Wiz Mode OTS Launch ###########################
####################################################################
####################################################################
#make URL print out a function so that & syntax can be used to run in background (user has immediate terminal access)
launchOTSWiz() {	
	
	#kill all things otsdaq, before launching new things	
	killprocs
	
	echo
	echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t*****************************************************"
	echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t*************    Launching WIZ MODE!    *************"
	echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t*****************************************************"
	echo
	
	####################################################################
	########### start console & message facility handling ##############
	####################################################################
	#decide which MessageFacility console viewer to run
	# and configure otsdaq MF library with MessageFacility*.fcl to use
	
	export OTSDAQ_LOG_FHICL=${USER_DATA}/MessageFacilityConfigurations/MessageFacilityGen.fcl
	#this fcl tells the MF library used by ots source how to behave
	#echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\tOTSDAQ_LOG_FHICL=" ${OTSDAQ_LOG_FHICL}
	
	
	USE_WEB_VIEWER="$(cat ${USER_DATA}/MessageFacilityConfigurations/UseWebConsole.bool)"
	USE_QT_VIEWER="$(cat ${USER_DATA}/MessageFacilityConfigurations/UseQTViewer.bool)"
			
	
	#echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\tUSE_WEB_VIEWER" ${USE_WEB_VIEWER}
	#echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\tUSE_QT_VIEWER" ${USE_QT_VIEWER}
	
	
	if [[ $USE_WEB_VIEWER == "1" ]]; then
		#echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\tCONSOLE: Using web console viewer"
		
		#start quiet forwarder with wiz receiving port and destination port parameter file
		cp ${USER_DATA}/MessageFacilityConfigurations/QuietForwarderWiz.cfg ${USER_DATA}/MessageFacilityConfigurations/QuietForwarder.cfg
		
		if [ $QUIET == 1 ]; then

			if [ $BACKUPLOGS == 1 ]; then
				DATESTRING=`date +'%s'`
				echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t     Backing up logfile to *** ${OTSDAQ_LOG_DIR}/otsdaq_quiet_run-mf-${HOSTNAME}.${DATESTRING}.txt ***"
				mv ${OTSDAQ_LOG_DIR}/otsdaq_quiet_run-mf-${HOSTNAME}.txt ${OTSDAQ_LOG_DIR}/otsdaq_quiet_run-mf-${HOSTNAME}.${DATESTRING}.txt
			fi
			
			echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t${Red}${Bold}Quiet mode${Reset}. Output into ${OTSDAQ_LOG_DIR}/otsdaq_quiet_run-mf-${HOSTNAME}.txt ***  "
			otsConsoleFwd ${USER_DATA}/MessageFacilityConfigurations/QuietForwarder.cfg  &> ${OTSDAQ_LOG_DIR}/otsdaq_quiet_run-mf-${HOSTNAME}.txt &
		else
			otsConsoleFwd ${USER_DATA}/MessageFacilityConfigurations/QuietForwarder.cfg  &
		fi		 	
	fi
	
	if [[ $USE_QT_VIEWER == "1" ]]; then
		echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\tCONSOLE: Using QT console viewer"
		if [ "x$ARTDAQ_MFEXTENSIONS_DIR" == "x" ]; then #qtviewer library missing!
			echo
			echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\tError: ARTDAQ_MFEXTENSIONS_DIR missing for qtviewer!"
			echo
			exit
		fi
		
		#start the QT Viewer (only if it is not already started)
		if [ $( ps aux|egrep -c $USER.*msgviewer ) -eq 1 ]; then				
			msgviewer -c ${USER_DATA}/MessageFacilityConfigurations/QTMessageViewerGen.fcl  &
			sleep 2	 #give time for msgviewer to be ready for messages	
		fi		
	fi
	
	####################################################################
	########### end console & message facility handling ################
	####################################################################
	
	
	
	
	#setup wiz mode environment variables
	export CONSOLE_SUPERVISOR_ID=260
	export CONFIGURATION_GUI_SUPERVISOR_ID=280
	export WIZARD_SUPERVISOR_ID=290	
	export OTS_CONFIGURATION_WIZARD_SUPERVISOR_ID=290	
	MAIN_PORT=2015

	if [ "x$OTS_WIZ_MODE_MAIN_PORT" != "x" ]; then
	  MAIN_PORT=${OTS_WIZ_MODE_MAIN_PORT}
	elif [ "x$OTS_MAIN_PORT" != "x" ]; then
	  MAIN_PORT=${OTS_MAIN_PORT}
	elif [ $USER == rrivera ]; then
	  MAIN_PORT=1983
	elif [ $USER == lukhanin ]; then
	  MAIN_PORT=2060
	elif [ $USER == uplegger ]; then
	  MAIN_PORT=1974
	elif [ $USER == parilla ]; then
	   MAIN_PORT=9000
	elif [ $USER == eflumerf ]; then
	   MAIN_PORT=1987
	elif [ $USER == swu ]; then
	   MAIN_PORT=1994
	elif [ $USER == rrivera ]; then
	   MAIN_PORT=1776
	elif [ $USER == naodell ]; then
	   MAIN_PORT=2030
	elif [ $USER == bschneid ]; then
	   MAIN_PORT=2050
	fi
	export PORT=${MAIN_PORT}	
	
		
	#substitute environment variables into template wiz-mode xdaq config xml
	envsubst <${XDAQ_CONFIGURATION_DATA_PATH}/otsConfigurationNoRU_Wizard_CMake.xml > ${XDAQ_CONFIGURATION_DATA_PATH}/otsConfigurationNoRU_Wizard_CMake_Run.xml
	
	#use safe Message Facility fcl in config mode
	export OTSDAQ_LOG_FHICL=${USER_DATA}/MessageFacilityConfigurations/MessageFacility.fcl #MessageFacilityWithCout.fcl
	
	echo
	echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\tStarting wiz mode on port ${PORT}; to change, please setup environment variable OTS_WIZ_MODE_MAIN_PORT."
	echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\tWiz mode xdaq config is ${XDAQ_CONFIGURATION_DATA_PATH}/otsConfigurationNoRU_Wizard_CMake_Run.xml"
			
	sleep 1 #attempt to avoid false starts by xdaq
	if [ $QUIET == 1 ]; then
		echo

		if [ $BACKUPLOGS == 1 ]; then
			DATESTRING=`date +'%s'`
			echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t     Backing up logfile to *** ${OTSDAQ_LOG_DIR}/otsdaq_quiet_run-wiz-${HOSTNAME}.${DATESTRING}.txt ***"
			mv ${OTSDAQ_LOG_DIR}/otsdaq_quiet_run-wiz-${HOSTNAME}.txt ${OTSDAQ_LOG_DIR}/otsdaq_quiet_run-wiz-${HOSTNAME}.${DATESTRING}.txt
		fi
		
		echo
		echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t${Red}${Bold}Quiet mode${Reset}. Output into ${OTSDAQ_LOG_DIR}/otsdaq_quiet_run-wiz-${HOSTNAME}.txt ***  "
		echo
		
		ots.exe -p ${PORT} -h ${HOSTNAME} -e ${XDAQ_CONFIGURATION_DATA_PATH}/otsConfiguration_CMake.xml -c ${XDAQ_CONFIGURATION_DATA_PATH}/otsConfigurationNoRU_Wizard_CMake_Run.xml &> ${OTSDAQ_LOG_DIR}/otsdaq_quiet_run-wiz-${HOSTNAME}.txt &
	else
		ots.exe -p ${PORT} -h ${HOSTNAME} -e ${XDAQ_CONFIGURATION_DATA_PATH}/otsConfiguration_CMake.xml -c ${XDAQ_CONFIGURATION_DATA_PATH}/otsConfigurationNoRU_Wizard_CMake_Run.xml &
	fi

	################
	# start node db server
	
	#echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\tARTDAQ_UTILITIES_DIR=" ${ARTDAQ_UTILITIES_DIR}
	#cd $ARTDAQ_UTILITIES_DIR/node.js
	#as root, once...
	# chmod +x setupNodeServer.sh 
	# ./setupNodeServer.sh 
	# chown -R products:products *
	
	#uncomment to use artdaq db nodejs web gui
	#node serverbase.js > /tmp/${USER}_serverbase.log &
	
	MAIN_URL="http://${HOSTNAME}:${PORT}/urn:xdaq-application:lid=$WIZARD_SUPERVISOR_ID/Verify?code=$(cat ${SERVICE_DATA_PATH}//OtsWizardData/sequence.out)"
	
	printMainURL &
	
} #end launchOTSWiz
export -f launchOTSWiz
		
####################################################################
####################################################################
################## Normal Mode OTS Launch ##########################
####################################################################
####################################################################
#make URL print out a function so that & syntax can be used to run in background (user has immediate terminal access)
#ContextPIDArray is context PID array 
launchOTS() {
	
	ISGATEWAYLAUNCH=1
	if [ "x$1" != "x" ]; then #if parameter, then is nongateway launch
		ISGATEWAYLAUNCH=0
		killprocs nongateway
		
		unset ContextPIDArray 
		unset xdaqPort
		unset xdaqHost	
		
	else 					#else is full gateway and nongateway launch
		GATEWAY_PID=-1
		#kill all things otsdaq, before launching new things	
		killprocs
	fi
	
        echo 
	echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t${Purple}${REV}*****************************************************${Reset}"
	if [ $ISGATEWAYLAUNCH == 1 ]; then
		echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t${Purple}${REV}***********       Launching OTS!         ************${Reset}"
	else
		echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t${Purple}${REV}*******    Launching OTS Non-gateway Apps!    *******${Reset}"
	fi
	echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t${Purple}${REV}*****************************************************${Reset}"
	echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\tXDAQ Configuration XML   = ${XDAQ_CONFIGURATION_DATA_PATH}/${XDAQ_CONFIGURATION_XML}.xml"	
	
	####################################################################
	########### start console & message facility handling ##############
	####################################################################
	#decide which MessageFacility console viewer to run
	# and configure otsdaq MF library with MessageFacility*.fcl to use
	
	export OTSDAQ_LOG_FHICL=${USER_DATA}/MessageFacilityConfigurations/MessageFacilityGen.fcl
	#this fcl tells the MF library used by ots source how to behave
	#echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\tOTSDAQ_LOG_FHICL=" ${OTSDAQ_LOG_FHICL}
	
	
	if [[ $ISGATEWAYLAUNCH == 1 ]]; then
		USE_WEB_VIEWER="$(cat ${USER_DATA}/MessageFacilityConfigurations/UseWebConsole.bool)"
		USE_QT_VIEWER="$(cat ${USER_DATA}/MessageFacilityConfigurations/UseQTViewer.bool)"
				
		
		#echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\tUSE_WEB_VIEWER" ${USE_WEB_VIEWER}
		#echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\tUSE_QT_VIEWER" ${USE_QT_VIEWER}
		
		
		if [[ $USE_WEB_VIEWER == "1" ]]; then
                        echo
			echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t${Green}${Bold}Launching message facility web console assistant...${Reset}"
			
			#start quiet forwarder with receiving port and destination port parameter file
			cp ${USER_DATA}/MessageFacilityConfigurations/QuietForwarderGen.cfg ${USER_DATA}/MessageFacilityConfigurations/QuietForwarder.cfg
			
			if [[ $QUIET == 1 ]]; then

				if [ $BACKUPLOGS == 1 ]; then
					DATESTRING=`date +'%s'`
					echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\tBacking up logfile into ${Yellow}${Bold}${OTSDAQ_LOG_DIR}/otsdaq_quiet_run-mf-${HOSTNAME}.${DATESTRING}.txt${Reset}"
					mv ${OTSDAQ_LOG_DIR}/otsdaq_quiet_run-mf-${HOSTNAME}.txt ${OTSDAQ_LOG_DIR}/otsdaq_quiet_run-mf-${HOSTNAME}.${DATESTRING}.txt
				fi
				
				echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t${Red}${Bold}Quiet mode${Reset}. Output into ${Yellow}${Bold}${OTSDAQ_LOG_DIR}/otsdaq_quiet_run-mf-${HOSTNAME}.txt${Reset}"
				otsConsoleFwd ${USER_DATA}/MessageFacilityConfigurations/QuietForwarder.cfg  &> ${OTSDAQ_LOG_DIR}/otsdaq_quiet_run-mf-${HOSTNAME}.txt &
			else
				otsConsoleFwd ${USER_DATA}/MessageFacilityConfigurations/QuietForwarder.cfg  &
			fi		 	
			echo
		fi
		
		if [[ $USE_QT_VIEWER == "1" ]]; then
			echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t${Green}${Bold}Launching QT console viewer...${Reset}"
			if [ "x$ARTDAQ_MFEXTENSIONS_DIR" == "x" ]; then #qtviewer library missing!
				echo
				echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t${Red}${Bold}Error${Reset}: ARTDAQ_MFEXTENSIONS_DIR missing for qtviewer!"
				echo
				exit
			fi
			
			#start the QT Viewer (only if it is not already started)
			if [ $( ps aux|egrep -c $USER.*msgviewer ) -eq 1 ]; then				
				msgviewer -c ${USER_DATA}/MessageFacilityConfigurations/QTMessageViewerGen.fcl  &
				sleep 2	 #give time for msgviewer to be ready for messages			
			fi		
		fi
	fi
	
	####################################################################
	########### end console & message facility handling ################
	####################################################################
	
			
	envString="-genv OTSDAQ_LOG_ROOT ${OTSDAQ_LOG_DIR} -genv ARTDAQ_OUTPUT_DIR ${ARTDAQ_OUTPUT_DIR}"

	#create argument to pass to xdaq executable
	export XDAQ_ARGS="${XDAQ_CONFIGURATION_DATA_PATH}/otsConfiguration_CMake.xml -c ${XDAQ_CONFIGURATION_DATA_PATH}/${XDAQ_CONFIGURATION_XML}.xml"
	
	#echo
	#echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\tXDAQ ARGS PASSED TO ots.exe:"
	#echo ${XDAQ_ARGS}
	#echo
	#echo	

	#for Supervisor backwards compatibility, convert to GatewaySupervisor stealthily
	sed -i s/ots::Supervisor/ots::GatewaySupervisor/g ${XDAQ_CONFIGURATION_DATA_PATH}/${XDAQ_CONFIGURATION_XML}.xml
	sed -i s/libSupervisor\.so/libGatewaySupervisor\.so/g ${XDAQ_CONFIGURATION_DATA_PATH}/${XDAQ_CONFIGURATION_XML}.xml

	value=`cat ${XDAQ_CONFIGURATION_DATA_PATH}/${XDAQ_CONFIGURATION_XML}.xml`	
	#echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t$value"
	#re="http://(${HOSTNAME}):([0-9]+)"
	
	re="http(s*)://(.+):([0-9]+)"
	superRe="id=\"([0-9]+)\""		
	
	#echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\tMATCHING REGEX"
	
	haveXDAQContextPort=false
	insideContext=false
	ignore=false
	isLocal=false
	gatewayHostname=""
	gatewayPort=0
			
	while read line; do    
		if [[ ($line == *"<!--"*) ]]; then		
			ignore=true
		fi
		if [[ ($line == *"-->"*) ]]; then
			ignore=false
		fi
		if [[ ${ignore} == true ]]; then
			continue
		fi
		#echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t$line"
				
		if [[ ($line == *"xc:Context"*) && ($line == *"url"*) ]]; then
			if [[ ($line =~ $re) ]]; then
				#if https && hostname matches
				#   convert hostname to localhost
				#   create node config files with https:port forwarding to localhost:madeupport
				#   run nodejs
				#   run xdaq
			
				#echo ${BASH_REMATCH[1]}
				#echo ${BASH_REMATCH[2]}
			
				port=${BASH_REMATCH[3]}
				host=${BASH_REMATCH[2]}
				insideContext=true
						
				#echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t$host $port "				
						
				if [[ (${BASH_REMATCH[2]} == ${HOSTNAME}) || (${BASH_REMATCH[2]} == ${HOSTNAME}"."*) || (${BASH_REMATCH[2]} == "localhost") ]]; then
				    isLocal=true
				else
				    isLocal=false
				fi
				if [[ ${contextHostname[*]} != ${BASH_REMATCH[2]} ]]; then
					contextHostname+=(${BASH_REMATCH[2]})
					#echo ${BASH_REMATCH[1]}    
				fi
			fi
			#echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t------------------------------------------ out"
	
		fi
		if [[ $line == *"/xc:Context"* ]]; then
			insideContext=false
			haveXDAQContextPort=false
			#echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\tin ------------------------------------------"
		fi
		if [[ ($insideContext == true) ]]; then 
			
			if [[ ($line == *"class"*) ]] && [[ "${isLocal}" == "true" ]]; then #IT'S A XDAQ SUPERVISOR		
				
				if [[ ($line == *"ots::GatewaySupervisor"*) ]]; then #IT's the SUPER supervisor, record LID 
					if [[ ($line =~ $superRe) ]]; then
					    gatewayHostname=${host}
						gatewayPort=${port}
						
						#echo ${BASH_REMATCH[1]}	#should be supervisor LID
						MAIN_URL="http://${host}:${port}/urn:xdaq-application:lid=${BASH_REMATCH[1]}/"
								
						#if gateway launch, do it
						if [[ $ISGATEWAYLAUNCH == 1 && ${host} == ${HOSTNAME} ]]; then
						
							sleep 1 #attempt to avoid false starts by xdaq
							if [ $QUIET == 1 ]; then
								echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t${Green}${Bold}Launching the Gateway Application on host {${HOSTNAME}}...${Reset}"								

								if [ $BACKUPLOGS == 1 ]; then
									DATESTRING=`date +'%s'`
									echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\tBacking up logfile into ${OTSDAQ_LOG_DIR}/otsdaq_quiet_run-gateway-${HOSTNAME}-${port}.${DATESTRING}.txt ***"
									mv ${OTSDAQ_LOG_DIR}/otsdaq_quiet_run-gateway-${HOSTNAME}-${port}.txt ${OTSDAQ_LOG_DIR}/otsdaq_quiet_run-gateway-${HOSTNAME}-${port}.${DATESTRING}.txt
								fi
								
								echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t${Red}${Bold}Quiet mode${Reset}. Output into ${Yellow}${Bold}${OTSDAQ_LOG_DIR}/otsdaq_quiet_run-gateway-${HOSTNAME}-${port}.txt${Reset}"
								ots.exe -h ${host} -p ${port} -e ${XDAQ_ARGS} &> ${OTSDAQ_LOG_DIR}/otsdaq_quiet_run-gateway-${HOSTNAME}-${port}.txt &								
								
							else
								ots.exe -h ${host} -p ${port} -e ${XDAQ_ARGS} &
							fi
							
							GATEWAY_PID=$!
							echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\tGateway-PID = ${Blue}${Bold}${GATEWAY_PID}${Rev}${Reset}"
							echo
							

							printMainURL &
															
						fi
					fi
				elif [[ ($haveXDAQContextPort == false) && ($gatewayHostname != $host || $gatewayPort != $port) ]]; then 
					xdaqPort+=($port)
					xdaqHost+=($host)					
					haveXDAQContextPort=true
				fi
				
			  #IF THERE IS AT LEAST ONE NOT ARTDAQ APP THEN I CAN GET OUT OF THIS CONTEXT AND RUN XDAQ ONCE JUST FOR THIS
			  #insideContext=false #RAR commented because need Super Supervisor connection LID for URL
			  #echo $line          
			fi
		fi   
	done < ${XDAQ_CONFIGURATION_DATA_PATH}/${XDAQ_CONFIGURATION_XML}.xml
		
	
	echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t${Green}${Bold}Launching all otsdaq Applications for host {${HOSTNAME}}...${Reset}"
	i=0	
	for port in "${xdaqPort[@]}"
	do
	  : 
	  	#echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\tots.exe -h ${xdaqHost[$i]} -p ${port} -e ${XDAQ_ARGS} &"
		#echo
		  

		if [[ ${xdaqHost[$i]} != ${HOSTNAME} ]]; then
			continue
		fi
	
		sleep 1 #attempt to avoid false starts by xdaq
		if [ $QUIET == 1 ]; then		  

			if [ $BACKUPLOGS == 1 ]; then
				DATESTRING=`date +'%s'`				
				
				echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\tBacking up logfile to *** ${OTSDAQ_LOG_DIR}/otsdaq_quiet_run-${HOSTNAME}-${port}.${DATESTRING}.txt ***"				
				mv ${OTSDAQ_LOG_DIR}/otsdaq_quiet_run-${HOSTNAME}-${port}.txt ${OTSDAQ_LOG_DIR}/otsdaq_quiet_run-${HOSTNAME}-${port}.${DATESTRING}.txt
			fi
		  			
			echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t${Red}${Bold}Quiet mode${Reset}. Output into ${OTSDAQ_LOG_DIR}/otsdaq_quiet_run-${HOSTNAME}-${port}.txt ***  "			
			ots.exe -h ${xdaqHost[$i]} -p ${port} -e ${XDAQ_ARGS} &> ${OTSDAQ_LOG_DIR}/otsdaq_quiet_run-${HOSTNAME}-${port}.txt &
		else
		  ots.exe -h ${xdaqHost[$i]} -p ${port} -e ${XDAQ_ARGS} &
		fi
		
		ContextPIDArray+=($!)
		echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\tNongateway-PID = ${ContextPIDArray[$i]}"
		
		i=$(( $i + 1 ))
	done

	FIRST_TIME=0 #used to supress printouts
		
	if [[ ${#contextHostname[@]} == 1 ]]; then 
		echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\tThis is the ONLY host configured to run xdaq applications: ${contextHostname[@]}" 	    
	  else
		echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\tThese are the hosts configured to run xdaq applications: ${contextHostname[@]}"
	fi
	echo
	  
	if [[ (${#xdaqPort[@]} == 0) && $gatewayHostname != ${HOSTNAME} ]]; then
	  echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t${Yellow}${Bold}************************************************************************************${Reset}"
	  echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t${Yellow}${Bold}************************************************************************************${Reset}"

	  echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t${Red}${Bold}${Blink}WARNING${Reset}: There are no configured processes for hostname ${HOSTNAME}." 
	  echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\tAre you sure your configuration is written for ${Red}${Bold}${Blink}${HOSTNAME}${Reset}?" 
	 
	  echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t${Yellow}${Bold}************************************************************************************${Reset}"
	  echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t${Yellow}${Bold}************************************************************************************${Reset}"
	fi

}   #end launchOTS
export -f launchOTS


#########################################################
#########################################################
#make URL print out a function so that & syntax can be used to run in background (user has immediate terminal access)
printMainURL() {	
	
	#echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\tprintMainURL()"
	
	#check if StartOTS.sh was aborted
	#OTSDAQ_STARTOTS_ACTION="$(cat ${OTSDAQ_STARTOTS_ACTION_FILE})"
	#	if [ "$OTSDAQ_STARTOTS_ACTION" == "EXIT_LOOP" ]; then
	#		exit
	#	fi
	
	if [ $QUIET == 0 ]; then
		sleep 4 #give a little more time before injecting printouts in scrolling printouts
	else
		sleep 2 #give a little time for other StartOTS printouts to occur (so this one is last)  
	fi
	
	echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\tOpen the URL below in your Google Chrome or Mozilla Firefox web browser:"	
	
	if [ $MAIN_URL == "unknown_url" ]; then
		echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\tINFO: No gateway supervisor found for node {${HOSTNAME}}."
		exit
	fi
	
	for i in {1..5}
	do
		#check if StartOTS.sh was aborted
		#OTSDAQ_STARTOTS_ACTION="$(cat ${OTSDAQ_STARTOTS_ACTION_FILE})"
		#if [ "$OTSDAQ_STARTOTS_ACTION" == "EXIT_LOOP" ]; then
		#exit
		#fi		
		
		echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t${BICyan}${EUNDERLINE}${MAIN_URL}${Reset}"
		echo
		
		if [ $QUIET == 1 ]; then
			exit
		fi
		sleep 2 #for delay between each printout
	done
}  #end printMainURL
export -f printMainURL
	
#########################################################
#########################################################
otsActionHandler() {

    echo		
	echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t${Green}${Bold}Starting action handler...${Reset}"

	#clear file initially
	echo "0" > $OTSDAQ_STARTOTS_ACTION_FILE
	

	if [[ ($ISCONFIG == 1) || ("${HOSTNAME}" == "${gatewayHostname}") ]]; then
		echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\tThe script, on ${HOSTNAME}, is the gateway StartOTS.sh script, so it will drive the exit of StartOTS.sh scripts running on other hosts."
		

		echo "EXIT_LOOP" > $OTSDAQ_STARTOTS_QUIT_FILE
		echo "EXIT_LOOP" > $OTSDAQ_STARTOTS_LOCAL_QUIT_FILE
		
		#time for other stale StartOTS to quit
		sleep 5
		echo "0" > $OTSDAQ_STARTOTS_QUIT_FILE
		echo "0" > $OTSDAQ_STARTOTS_LOCAL_QUIT_FILE
	else
		sleep 10 #non masters sleep for a while, to give time to quit stale scripts
	fi	
		
	FIRST_TIME=1 #to enable url printouts
	
	
	
	#listen for file commands
	while true; do
		#In OTSDAQ_STARTOTS_ACTION_FILE
		#0 is the default. No action is taken
		#REBUILD_OTS will rebuild otsdaq
		#Reset_MPI will reboot artdaq MPI runs
		#EXIT_LOOP will exit StartOTS loop
		#if cmd file is missing, exit StartOTS loop
		
		OTSDAQ_STARTOTS_ACTION="$(cat ${OTSDAQ_STARTOTS_ACTION_FILE})"
		OTSDAQ_STARTOTS_QUIT="$(cat ${OTSDAQ_STARTOTS_QUIT_FILE})"
		OTSDAQ_STARTOTS_LOCAL_QUIT="$(cat ${OTSDAQ_STARTOTS_LOCAL_QUIT_FILE})"
		
		#echo "command ${OTSDAQ_STARTOTS_ACTION} ${OTSDAQ_STARTOTS_QUIT} ${OTSDAQ_STARTOTS_LOCAL_QUIT} "
		
		if [ "$OTSDAQ_STARTOTS_ACTION" == "REBUILD_OTS" ]; then
		
			echo
			echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t "
			echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\tRebuilding..."
			echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t "			
			#echo "1" > mrbresult.num; mrb b > otsdaq_startots_mrbreport.txt && echo "0" > mrbresult.num			
			echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t "
			#grep -A 1 -B 1 "INFO: Stage build successful." otsdaq_startots_mrbreport.txt
			echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t "
			sleep 5
		
		elif [ "$OTSDAQ_STARTOTS_ACTION" == "OTS_APP_SHUTDOWN" ]; then
		
			echo
			echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t "
			echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\tShutting down non-gateway contexts..."
			echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t "	
			
			#kill all non-Gateway context processes
			killprocs nongateway
			
			
		elif [ "$OTSDAQ_STARTOTS_ACTION" == "OTS_APP_STARTUP" ]; then
		
			echo
			echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t "
			echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\tStarting up non-gateway contexts..."
			echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t "	
			
			launchOTS nongateway #launch all non-gateway apps			
	
		elif [ "$OTSDAQ_STARTOTS_ACTION" == "LAUNCH_WIZ" ]; then
			
			echo
			echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\tStarting otsdaq Wiz mode for host {${HOSTNAME}}..."
			echo
			killprocs
			
			launchOTSWiz
			
			sleep 3 #so that the terminal comes back after the printouts in quiet mode
			
			FIRST_TIME=1 #re-enable printouts for launch ots, in case of context changes

		elif [ "$OTSDAQ_STARTOTS_ACTION" == "LAUNCH_OTS" ]; then
				
			echo
			echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\tStarting otsdaq in normal mode for host {${HOSTNAME}}..."
			echo
			killprocs
			
			launchOTS

			sleep 3 #so that the terminal comes back after the printouts in quiet mode			

		elif [ "$OTSDAQ_STARTOTS_ACTION" == "FLATTEN_TO_SYSTEM_ALIASES" ]; then

			echo
			echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\tRemoving unused tables and groups based on active System Aliases..."
			echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\totsdaq_flatten_system_aliases 0"
			echo	
			echo 
			if [ $QUIET == 1 ]; then			

				if [ $BACKUPLOGS == 1 ]; then
					DATESTRING=`date +'%s'`
					echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t     Backing up logfile to *** ${OTSDAQ_LOG_DIR}/otsdaq_quiet_run-flatten-${HOSTNAME}.${DATESTRING}.txt ***"
					mv ${OTSDAQ_LOG_DIR}/otsdaq_quiet_run-flatten-${HOSTNAME}.txt ${OTSDAQ_LOG_DIR}/otsdaq_quiet_run-flatten-${HOSTNAME}.${DATESTRING}.txt
				fi
				
				echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\t${Red}${Bold}Quiet mode${Reset}. Output into ${OTSDAQ_LOG_DIR}/otsdaq_quiet_run-flatten-${HOSTNAME}.txt ***  "	
				otsdaq_flatten_system_aliases 0 &> ${OTSDAQ_LOG_DIR}/otsdaq_quiet_run-flatten-${HOSTNAME}.txt &
			else
				otsdaq_flatten_system_aliases 0 &
			fi		
						
		elif [[ "$OTSDAQ_STARTOTS_ACTION" == "EXIT_LOOP" || "$OTSDAQ_STARTOTS_QUIT" == "EXIT_LOOP" || "$OTSDAQ_STARTOTS_LOCAL_QUIT" == "EXIT_LOOP" ]]; then

			echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\tExiting StartOTS.sh.."
			if [[ ($ISCONFIG == 1) || ("${HOSTNAME}" == "${gatewayHostname}") ]]; then
				echo "EXIT_LOOP" > $OTSDAQ_STARTOTS_QUIT_FILE
				echo "EXIT_LOOP" > $OTSDAQ_STARTOTS_LOCAL_QUIT_FILE
			fi
			
		    exit
			
		elif [[ "${OTSDAQ_STARTOTS_ACTION:-"0"}" != "0"  || "${OTSDAQ_STARTOTS_QUIT:-"0"}" != "0" || "${OTSDAQ_STARTOTS_LOCAL_QUIT:-"0"}" != "0" ]]; then
		
			echo -e "${STARTTIME}-"`date +"%h%y.%T"` "${HOSTNAME_ARR[0]}-ots [${Cyan}${LINENO}${Reset}]\tExiting StartOTS.sh.. Unrecognized command !=0 in Action:${OTSDAQ_STARTOTS_ACTION}-Quit:${OTSDAQ_STARTOTS_QUIT}-Local:${OTSDAQ_STARTOTS_LOCAL_QUIT}"			
			exit
			
		fi
		
		echo "0" > $OTSDAQ_STARTOTS_ACTION_FILE #clear the command in the file; it has been responded to
		sleep 1
	done

		
} #end otsActionHandler
export -f otsActionHandler



#functions have been declared
#now launch things


if [ $ISCONFIG == 1 ]; then
	launchOTSWiz
else
	launchOTS #only launch gateway once.. on shutdown and startup others can relaunch
fi


sleep 2 #attempt to avoid false starts by xdaq 
#after gateway node has been decided and xdaq has been launched, start action handler
otsActionHandler &


#launch chrome here if enabled
if [ $CHROME == 1 ]; then
	sleep 3 #give time for server to be live
	google-chrome $MAIN_URL &
fi

#launch firefox here if enabled
if [ $FIREFOX == 1 ]; then
	sleep 3 #give time for server to be live
	firefox $MAIN_URL &
fi

sleep 3 #so that the terminal comes back after the printouts are done ( in quiet mode )











