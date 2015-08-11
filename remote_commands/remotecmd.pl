#!/usr/bin/perl

$user=<username>;
$hostlist="<hostlist file>";
unless (-e $hostlist){
        print "No hostlist file present!!!\n";
        exit;
}
$cmd="<commands to run>";
open(HOSTLIST,$hostlist);
        while(<HOSTLIST>) {
                $output="";
                @split="";
                chomp;
                $hostname=$_;
                $sshcmd="ssh -o ConnectTimeout=2 -o BatchMode=yes -o StrictHostKeyChecking=no -naxt $user\@$hostname \"($cmd)\" 2>&1";
                $output=`$sshcmd`;
                chomp($output);
                print $hostname . " - " . $output . "\n";
        }
close(HOSTLIST);
