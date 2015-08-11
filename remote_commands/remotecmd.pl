#!/usr/bin/perl
#  this assumes you have access without providing a password (kinit or keys)

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
                chomp;
                $hostname=$_;
                #as root
                $sshcmd="ssh -o ConnectTimeout=2 -o BatchMode=yes -o StrictHostKeyChecking=no -naxt $user\@$hostname \"(echo '$cmd') | sudo su - root\" 2>&1";
                #as user               
                $sshcmd="ssh -o ConnectTimeout=2 -o BatchMode=yes -o StrictHostKeyChecking=no -naxt $user\@$hostname \"($cmd)\" 2>&1";
                $output=`$sshcmd`;
                chomp($output);
                print $hostname . " - " . $output . "\n";
        }
close(HOSTLIST);
