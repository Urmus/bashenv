# Redo previous command as sudo
alias fuck='sudo $(history -p \!\!)'

alias ..='cd ..'         # Go up one directory
alias ...='cd ../..'     # Go up two directories
alias ....='cd ../../..' # Go up two directories
alias -- -="cd -"        # Go back

# path pretty print
function pathpp {
    echo $PATH | tr ':' '\n'
}

# Tree
if [ ! -x "$(which tree 2>/dev/null)" ]
then
  alias tree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"
fi

# env pretty print
function envpp {
    # Get variable max length for formatting
    maxlength=$(env | gawk -F"=" '(maxlength < length($1)){maxlength=length($1)} END{print maxlength}')
    
    # If width is specified, get it, else get console width
    if [ $# -eq 1 ]
    then
        linelength=$1
    else
        linelength=$(tput cols) #console width
    fi
    
    # get env with -0 to have \0 instead of \n for newlines. sort -z to use \0 too.
    env -0 | sort -z | gawk -F"=" -v maxlength=$maxlength -v linelength=$linelength '
        BEGIN {RS="\0"}
        
        # Green text in bash console
        function green(s) {
            printf "\033[1;32m" s "\033[0m"
        }
        {
            # Get variable value croped
            value=substr($2,1,linelength - maxlength - 4);
            
            # Print variable name in green
            
            printf("%s ", green($1));
            
            # Write dots until maxlength
            for (i=length($1)+1;i<=maxlength;i++) {
                printf(".");
            }
            
            # write croped value
            printf(" = %s\n", value);
        }
    '
}

