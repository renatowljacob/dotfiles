//Modify this file to change what commands output to your statusbar, and recompile using the make command.
static const Block blocks[] = {
	/*Icon*/	/*Command*/		/*Update Interval*/	/*Update Signal*/
	{""  , "sb-spotify",							1,		4},

	{""  , "sb-volume",							3600,		3},

	{" ", "free -h | awk '/^Mem/ { print $3 }' | sed s/i/B/g",		1,		2},

	{"󰥔 ", "date '+%R %a | %d %B %Y'",					60,		1},
};

//sets delimiter between status commands. NULL character ('\0') means no delimiter.
static char delim[] = " | ";
static unsigned int delimLen = 5;
