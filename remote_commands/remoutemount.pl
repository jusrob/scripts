#!/usr/bin/perl

$mount="$ARGV[0]\n";
$user=user
chomp($mount);
if ($mount eq ""){
        print "Must provide share name!!!\n";
        exit;
}
$hostlist="hostlist_" . $mount;
unless (-e $hostlist){
        print "No hostlist file present!!!\n";
        exit;
}
$cmd="hostname -f;df";
open(ISSUES,'>>issues_output.txt');
open(OUTPUT,'>>output.txt');
open(HOSTLIST,$hostlist);
        while(<HOSTLIST>) {
                $output="";
                @lines = ();
                @cleanlines = ();
                chomp;
                $hostname=$_;
                #print "================$_\n";
                $sshcmd="ssh -o ConnectTimeout=2 -o BatchMode=yes -o StrictHostKeyChecking=no -naxt $user\@$hostname \"(echo '$cmd') | sudo su - root\" 2>&1";
                $output=`$sshcmd`;
                my @lines = split(/\n/, $output);
                foreach my $line ( @lines ) {
                        if (($line !~ /The Oracle base for ORACLE_HOME/) && ($line !~ /Found ASM instance, setting up environment/) && ($line !~ /NOTE: remember to add utl NFS to fstab/) && ($line !~ /Warning: Permanently added/) && ($line !~ /Could not chdir to home directory/))
                        {
                                #print "KEEPING LINE - $line\n";
                                push(@cleanlines, $line);
                        }
                }
                if ($output =~ /$mount/) {
                        print OUTPUT "MOUNTED: $cleanlines[0]\n";
                }
                if (($cleanlines[0] !~ /ge.com/)||($lines[0] =~ m/Permission denied/)) {
                        print ISSUES "ISSUE: $hostname\n$output\n";
                }elsif($output !~ /$mount/) {
                        print OUTPUT "NOT MOUNTED: $cleanlines[0]\n";
                }
        }
close(HOSTLIST);
close(OUTPUT);
close(ISSUES);
