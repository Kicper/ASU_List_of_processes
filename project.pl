#author: Kacper Kipa

#!usr/bin/perl

use warnings;
use strict;
use Tk;



my $filename = '/etc/passwd';
open(FH, '<', $filename) or die $!;

my @user_arr;
my $user;
while(<FH>){
	($user) = split /\s*:\s*/, $_, 2;
	push(@user_arr, ($user));
}
close(FH);



my $mw = MainWindow->new;
$mw->Label(
	-width => 40,
	-height => 6,
	-text => 'Program which shows user\'s processes!'
)->pack;

$mw->Label(
	-width => 40,
	-text => 'Choose if you want to skip root\'s processes:'
)->pack;

my $var = '0';
$mw->Checkbutton(
	-width => 40,
    	-text => 'Skip root\'s processes',
    	-variable => \$var,
	-onvalue  => '1',
	-offvalue => '0',
)->pack;

$mw->Button(
	-width => 20,
    	-text => 'Execute',
    	-command => sub{execute()},
)->pack;

$mw->Label(
	-width => 40,
	-text => 'Choose user from list:'
)->pack;

my $lb = $mw->Scrolled("Listbox", -scrollbars => "osoe")->pack(-side => "left"); $lb->insert("end", @user_arr);

my $lb_res = $mw->Scrolled("Listbox", -scrollbars => "osoe")->pack(-side => "right");

$mw->Button(-text => "Clear text",-command => sub { $lb_res->delete('0.0', 'end') })->pack;

MainLoop;



my @result;
my @chosen_user;
my @name;
sub execute(){
	@chosen_user = $lb->curselection();
	@result = ();
	if (!@chosen_user) {
		print "You have to choose user before checking processes\n";
	}else{
		foreach my $line ( qx[ps -ef] ){
			@name = split('\s', $line);
			if($var eq '0') {
				if(@user_arr[@chosen_user] eq "$name[0]" or $name[0] eq "root"){
					push(@result, ($line));
				}
			}else{
				if(@user_arr[@chosen_user] eq "root"){
				}else{
					if(@user_arr[@chosen_user] eq "$name[0]"){
						push(@result, ($line));
					}
				}
			}
		}
		$lb_res->insert("end", @result);
		MainLoop;
	}
}
