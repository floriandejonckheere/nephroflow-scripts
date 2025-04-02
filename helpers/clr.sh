#
# Constants and functions for terminal colors.
# Author: Max Tsepkov <max@yogi.pw>

CLR_ESC="\033["

# All these varibles has a function with the same name, but in lower case.
#
CLR_RESET=0             # reset all attributes to their defaults
CLR_RESET_UNDERLINE=24  # underline off
CLR_RESET_REVERSE=27    # reverse off
CLR_DEFAULT=39          # set underscore off, set default foreground color
CLR_DEFAULTB=49         # set default background color

CLR_BOLD=1              # set bold
CLR_BRIGHT=2            # set half-bright (simulated with color on a color display)
CLR_ITALIC=3            # set italic
CLR_UNDERSCORE=4        # set underscore (simulated with color on a color display)
CLR_REVERSE=7           # set reverse video
CLR_CONCEAL=8           # set conceal
CLR_CROSSED=9           # set crossed out

CLR_BLACK=30            # set black foreground
CLR_RED=31              # set red foreground
CLR_GREEN=32            # set green foreground
CLR_BROWN=33            # set brown foreground
CLR_BLUE=34             # set blue foreground
CLR_MAGENTA=35          # set magenta foreground
CLR_CYAN=36             # set cyan foreground
CLR_WHITE=37            # set white foreground

CLR_BLACKB=40           # set black background
CLR_REDB=41             # set red background
CLR_GREENB=42           # set green background
CLR_BROWNB=43           # set brown background
CLR_BLUEB=44            # set blue background
CLR_MAGENTAB=45         # set magenta background
CLR_CYANB=46            # set cyan background
CLR_WHITEB=47           # set white background

# General function to wrap string with escape seqence(s).
# Ex: console_escape foobar $CLR_RED $CLR_BOLD
function clr_escape
{
    local result="$1"
    until [ -z "$2" ]; do
  if ! [ $2 -ge 0 -a $2 -le 47 ] 2>/dev/null; then
      echo "clr_escape: argument \"$2\" is out of range" >&2 && return 1
  fi
        result="${CLR_ESC}${2}m${result}${CLR_ESC}${CLR_RESET}m"
  shift || break
    done

    echo -e "$result"
}

function clr_reset           { clr_escape "$1" $CLR_RESET;           }
function clr_reset_underline { clr_escape "$1" $CLR_RESET_UNDERLINE; }
function clr_reset_reverse   { clr_escape "$1" $CLR_RESET_REVERSE;   }
function clr_default         { clr_escape "$1" $CLR_DEFAULT;         }
function clr_defaultb        { clr_esacpe "$1" $CLR_DEFAULTB;        }
function clr_bold            { clr_escape "$1" $CLR_BOLD;            }
function clr_bright          { clr_escape "$1" $CLR_BRIGHT;          }
function clr_italic          { clr_escape "$1" $CLR_ITALIC;          }
function clr_underscore      { clr_escape "$1" $CLR_UNDERSCORE;      }
function clr_reverse         { clr_escape "$1" $CLR_REVERSE;         }
function clr_conceal         { clr_escape "$1" $CLR_CONCEAL;         }
function clr_crossed         { clr_escape "$1" $CLR_CROSSED;         }
function clr_black           { clr_escape "$1" $CLR_BLANK;           }
function clr_red             { clr_escape "$1" $CLR_RED;             }
function clr_green           { clr_escape "$1" $CLR_GREEN;           }
function clr_brown           { clr_escape "$1" $CLR_BROWN;           }
function clr_blue            { clr_escape "$1" $CLR_BLUE;            }
function clr_magenta         { clr_escape "$1" $CLR_MAGENTA;         }
function clr_cyan            { clr_escape "$1" $CLR_CYAN;            }
function clr_white           { clr_escape "$1" $CLR_WHITE;           }
function clr_blackb          { clr_escape "$1" $CLR_BLACKB;          }
function clr_redb            { clr_escape "$1" $CLR_REDB;            }
function clr_greenb          { clr_escape "$1" $CLR_GREENB;          }
function clr_brownb          { clr_escape "$1" $CLR_BROWNB;          }
function clr_blueb           { clr_escape "$1" $CLR_BLUEB;           }
function clr_magentab        { clr_escape "$1" $CLR_MAGENTAB;        }
function clr_cyanb           { clr_escape "$1" $CLR_CYANB;           }
function clr_whiteb          { clr_escape "$1" $CLR_WHITEB;          }

# Outputs colors table
function clr_dump
{
    local T='gYw'

    echo -e "\n                 40m     41m     42m     43m     44m     45m     46m     47m";

    for FGs in '   0m' '   1m' '  30m' '1;30m' '  31m' '1;31m' \
               '  32m' '1;32m' '  33m' '1;33m' '  34m' '1;34m' \
               '  35m' '1;35m' '  36m' '1;36m' '  37m' '1;37m';
    do
        FG=${FGs// /}
        echo -en " $FGs \033[$FG  $T  "
        for BG in 40m 41m 42m 43m 44m 45m 46m 47m; do
            echo -en " \033[$FG\033[$BG  $T  \033[0m";
        done
        echo;
    done

    echo
    clr_bold "    Code     Function           Variable              Output"
    echo \
'    0        clr_reset          $CLR_RESET            '$(clr_reset "Example text")'
    1        clr_bold           $CLR_BOLD             '$(clr_bold "Example text")'
    2        clr_bright         $CLR_BRIGHT           '$(clr_bright "Example text")'
    3        clr_italic         $CLR_ITALIC           '$(clr_italic "Example text")'
    4        clr_underscore     $CLR_UNDERSCORE       '$(clr_underscore "Example text")'
    7        clr_reverse        $CLR_REVERSE          '$(clr_reverse "Example text")'
    8        clr_conceal        $CLR_CONCEAL          '$(clr_conceal "Example text")'
    9        clr_crossed        $CLR_CROSSED          '$(clr_crossed "Example text")'

    30       clr_black          $CLR_BLACK            '$(clr_black "Example text")'
    31       clr_red            $CLR_RED              '$(clr_red "Example text")'
    32       clr_green          $CLR_GREEN            '$(clr_green "Example text")'
    33       clr_brown          $CLR_BROWN            '$(clr_brown "Example text")'
    34       clr_blue           $CLR_BLUE             '$(clr_blue "Example text")'
    35       clr_magenta        $CLR_MAGENTA          '$(clr_magenta "Example text")'
    36       clr_cyan           $CLR_CYAN             '$(clr_cyan "Example text")'
    37       clr_white          $CLR_WHITE            '$(clr_white "Example text")'

    40       clr_blackb         $CLR_BLACKB           '$(clr_blackb "Example text")'
    41       clr_redb           $CLR_REDB             '$(clr_redb "Example text")'
    42       clr_greenb         $CLR_GREENB           '$(clr_greenb "Example text")'
    43       clr_brownb         $CLR_BROWNB           '$(clr_brownb "Example text")'
    44       clr_blueb          $CLR_BLUEB            '$(clr_blueb "Example text")'
    45       clr_magentab       $CLR_MAGENTAB         '$(clr_magentab "Example text")'
    46       clr_cyanb          $CLR_CYANB            '$(clr_cyanb "Example text")'
    47       clr_whiteb         $CLR_WHITEB           '$(clr_whiteb "Example text")'
'
}
