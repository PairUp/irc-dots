use strict; use warnings;
$INC{'Encode/ConfigLocal.pm'}=1;
require Encode;

# to read the following docs, you can use "perldoc menu.pl"

=head1 NAME

colour_popup - show mirc colours when needed

=head1 SYNOPSIS

the colour numbers will be shown when a colour control code is
present.

=cut

use constant SCRIPT_NAME => 'colour_popup';
weechat::register(SCRIPT_NAME, 'Nei <anti.teamidiot.de>', '0.0', 'GPL3', 'show mirc colour codes', '', '');

weechat::hook_modifier('input_text_display_with_cursor', 'colour_popup', '');

## colour_popup -- show mirc colours
## () - modifier handler
## $_[2] - buffer pointer
## $_[3] - input string
## returns modified input string
sub colour_popup {
	return $_[3] unless weechat::current_buffer() eq $_[2];
	Encode::_utf8_on($_[3]);
	my ($p1, $x, $p2) = split '((?:\03(?:\d{1,2}(?:,(?:\d{1,2})?)?)?|\02|\x1d|\x0f|\x12|\x15)?\x19b#)', $_[3], 2;
	for ($p1, $p2) {
		Encode::_utf8_on($_ = weechat::hook_modifier_exec('irc_color_decode', 1, $_));
	}
	$x .= ' ' . weechat::hook_modifier_exec('irc_color_decode', 1, join '', map { "\03" . ($_ ~~ [0, 8, 14, 15] ? 1 : 0) . ',' . (sprintf "%02d", $_)x2 } 0..15) if $x =~ /^\03/;
	"$p1$x$p2"
}
