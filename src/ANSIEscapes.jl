module ANSIEscapes

using TERMIOS

const T = TERMIOS

# See <https://en.wikipedia.org/wiki/ANSI_escape_code>

# C0 control codes

const BEL = '\a'                # bell
const BS = '\b'                 # backspace
const HT = '\t'                 # tab
const LF = '\n'                 # line feed
const FF = '\f'                 # form feed
const CR = '\r'                 # carriage return
const ESC = '\e'                # escape

# C1 control codes

const SS2 = "$(ESC)N"           # 0x8e   single shift two
const SS3 = "$(ESC)O"           # 0x8f   single shift three
const DCS = "$(ESC)P"           # 0x90   device control string
const CSI = "$(ESC)["           # 0x9b   control sequence introducer
const ST = "$(ESC)\\"           # 0x9c   string terminator
const OSC = "$(ESC)]"           # 0x9d   operating system command
const SOS = "$(ESC)X"           # 0x98   start of string
const PM = "$(ESC)^"            # 0x9e   privacy message
const APC = "$(ESC)_"           # 0x9f   application program command

# CSI commands

CUU(n::Integer) = "$(CSI)$(Unsigned(n))A" # cursor up
CUU() = "$(CSI)A"

CUD(n::Integer) = "$(CSI)$(Unsigned(n))B" # cursor down
CUD() = "$(CSI)B"

CUF(n::Integer) = "$(CSI)$(Unsigned(n))C" # cursor forward
CUF() = "$(CSI)C"

CUB(n::Integer) = "$(CSI)$(Unsigned(n))D" # cursor back
CUB() = "$(CSI)D"

CNL(n::UInt) = "$(CSI)$(n)E"    # cursor next line
CNL(n::Integer) = CNL(UInt(n))
CNL() = CNL(1)

CPL(n::UInt) = "$(CSI)$(n)F"    # cursor previous line
CPL(n::Integer) = CPL(UInt(n))
CPL() = CPL(1)

CHA(n::UInt) = "$(CSI)$(n)G"    # cursor horizontal absolute
CHA(n::Integer) = CHA(UInt(n))
CHA() = CHA(1)

# cursor position
function CUP(; row::Union{Nothing,Integer}=nothing, col::Union{Nothing,Integer}=nothing)
    rowcode = row === nothing ? "" : "$(Unsigned(row))"
    colcode = col === nothing ? "" : "$(Unsigned(col))"
    return "$(CSI)$(rowcode);$(colcode)H"
end
CUP(row, col) = CUP(; row, col)
CUP(row) = CUP(; row)

ED(n::UInt) = "$(CSI)$(n)J"    # erase in display
ED(n::Integer) = ED(UInt(n))
ED() = ED(1)

EL(n::Integer) = "$(CSI)$(Unsigned(n))K" # erase in line
EL() = "$(CSI)K"

SU(n::UInt) = "$(CSI)$(n)S"    # scroll up
SU(n::Integer) = SU(UInt(n))
SU() = SU(1)

SD(n::UInt) = "$(CSI)$(n)T"    # scroll down
SD(n::Integer) = SD(UInt(n))
SD() = SD(1)

HVP(n::UInt, m::UInt) = "$(CSI)$(n);$(m)f" # horizontal vertical position
HVP(n::Integer, m::Integer) = HVP(UInt(n), UInt(m))
HVP(; row::Integer=1, col::Integer=1) = HVP(row, col)

# select graphic rendition
function SGR(ns::Integer...)
    codes = join(Unsigned.(ns), ';')
    return "$(CSI)$(codes)m"
end

AUXon() = "$(CSI)5i"            # AUX port on
AUXoff() = "$(CSI)4i"           # AUX port off

DSR() = "$(CSI)6n"              # device status report

report_window_size() = "$(CSI)18t"

# Private CSI commands

DA() = "$(CSI)c"
DA2() = "$(CSI)>c"

SCP() = "$(CSI)s"               # save current cursor position
RCP() = "$(CSI)u"               # restore saved cursor position

show_cursor() = "$(CSI)?25h"
hide_cursor() = "$(CSI)?25l"

enable_reporting_focus() = "$(CSI)?1004h"
disable_reporting_focus() = "$(CSI)?1004l"

enable_alternative_screen_buffer() = "$(CSI)?1049h"
disable_alternative_screen_buffer() = "$(CSI)?1049l"

enable_bracketed_paste() = "$(CSI)?2004h"
disable_bracketed_paste() = "$(CSI)?2004l"

# OSC commands

wezterm_version() = "$(OSC)1337;WezTerm;version$(ST)"

################################################################################

# SGR codes

@enum Color begin
    black
    red
    green
    yellow
    blue
    magenta
    cyan
    white
    light_black
    light_red
    light_green
    light_yellow
    light_blue
    light_magenta
    light_cyan
    light_white
end
@assert Int(black) == 0
@assert Int(light_white) == 15

SGR_normal() = SGR(0)
SGR_bold() = SGR(1)
SGR_dim() = SGR(2)
SGR_italic() = SGR(3)
SGR_underline() = SGR(4)
SGR_blink() = SGR(5)
SGR_rapid_blink() = SGR(6)
SGR_reverse() = SGR(7)
SGR_hidden() = SGR(8)
SGR_cross_out() = SGR(9)
SGR_font_default() = SGR(10)
SGR_font_1() = SGR(11)
SGR_font_2() = SGR(12)
SGR_font_3() = SGR(13)
SGR_font_4() = SGR(14)
SGR_font_5() = SGR(15)
SGR_font_6() = SGR(16)
SGR_font_7() = SGR(17)
SGR_font_8() = SGR(18)
SGR_font_9() = SGR(19)
SGR_fraktur() = SGR(20)
SGR_double_underline() = SGR(21)
SGR_normal_intensity() = SGR(22)
SGR_not_italic_or_fraktur() = SGR(23)
SGR_not_italic() = SGR_not_italic_or_fraktur()
SGR_not_fraktur() = SGR_not_italic_or_fraktur()
SGR_not_underlined() = SGR(24)
SGR_not_blink() = SGR(25)
SGR_proportional() = SGR(26)
SGR_not_reverse() = SGR(27)
SGR_not_hidden() = SGR(28)
SGR_not_cross_out() = SGR(29)
SGR_fgcolor(color::Color) = SGR(30 + 60 * (Int(color) ÷ 8) + Int(color) % 8)
SGR_fgcolor(n::Integer) = SGR(38, 5, n)
SGR_fgcolor(r::Integer, g::Integer, b::Integer) = SGR(38, 2, r, g, b)
SGR_fgcolor(r::Integer, g::Integer, b::Integer, a::Integer) = SGR(38, 6, r, g, b, a)
SGR_fgcolor_default() = SGR(39)
SGR_bgcolor(color::Color) = SGR(40 + 60 * (Int(color) ÷ 8) + Int(color) % 8)
SGR_bgcolor(n::Integer) = SGR(48, 5, n)
SGR_bgcolor(r::Integer, g::Integer, b::Integer) = SGR(48, 2, r, g, b)
SGR_bgcolor(r::Integer, g::Integer, b::Integer, a::Integer) = SGR(48, 6, r, g, b, a)
SGR_bgcolor_default() = SGR(49)
SGR_not_proportional() = SGR(50)
SGR_framed() = SGR(51)
SGR_encircled() = SGR(52)
SGR_overlined() = SGR(53)
SGR_not_framed() = SGR(54)
SGR_not_circled_or_overlined() = SGR(54)
SGR_not_circled() = SGR_not_circled_or_overlined()
SGR_not_overlined() = SGR_not_circled_or_overlined()
SGR_ulcolor(n::Integer) = SGR(58, 5, n)
SGR_ulcolor(r::Integer, g::Integer, b::Integer) = SGR(59, 2, r, g, b)
SGR_ulcolor(r::Integer, g::Integer, b::Integer, a::Integer) = SGR(59, 6, r, g, b, a)
SGR_superscript() = SGR(73)
SGR_subscript() = SGR(74)
SGR_not_superscript_or_subscript() = SGR(75)
SGR_not_superscript() = SGR_not_superscript_or_subscript()
SGR_not_subscript() = SGR_not_superscript_or_subscript()

################################################################################

function read_response(command::AbstractString)
    # Open terminal
    tty = open("/dev/tty", "r+")
    fd = Base.fd(tty)

    # Output buffer
    buf = UInt8[]

    saved = T.termios()
    try
        # Switch terminal to raw mode
        T.tcgetattr(fd, saved)
        raw = deepcopy(saved)
        T.cfmakeraw(raw)
        T.tcsetattr(fd, T.TCSANOW, raw)

        # Output DSR sequency
        write(tty, command)
        flush(tty)

        # Read reply
        in_escape = false
        in_arguments = false
        while true
            ch = read(tty, UInt8)
            push!(buf, ch)
            if !in_escape
                if ch == UInt8('\e')
                    @assert !in_escape
                    in_escape = true
                else
                    break
                end
            else
                if !in_arguments
                    in_arguments = true
                else
                    ch in 0x40:0x7e && break
                end
            end
        end

    finally
        # Switch terminal back to cooked mode
        T.tcsetattr(fd, T.TCSANOW, saved)
    end

    close(tty)

    return String(buf)
end

function read_DSR()
    reply = read_response(DSR())

    # Decode reply: ESC [ <rows> ; <cols> R
    m = match(r"\e\[(\d+);(\d+)R", reply)
    m === nothing && error("Unexpected DSR reply: $(repr(reply))")
    row = parse(Int, m.captures[1])
    col = parse(Int, m.captures[2])

    return row, col
end

function read_wezterm_version()
    reply = read_response(wezterm_version())
    return reply::String
end

function read_window_size()
    reply = read_response(report_window_size())

    # Decode reply: ESC [ 8; <rows> ; <cols> t
    m = match(r"\e\[8;(\d+);(\d+)t", reply)
    m === nothing && error("Unexpected report_window_size reply: $(repr(reply))")
    nrows = parse(Int, m.captures[1])
    ncols = parse(Int, m.captures[2])

    return nrows, ncols
end

end
